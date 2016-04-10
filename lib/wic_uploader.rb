require "wic"
require "ohanakapa"
require 'ostruct'

class WicUploader
  def wic_org
    #TODO
    @wic ||= Ohanakapa.organization('wic')
  end

  def wic_category
    #TODO
    #@wic_category ||= Ohanakapa.organization(62)
    #puts @ebt_category.to_s
    #raise "halt"
    @wic_category ||= OpenStruct.new(:id => 12)
  end

  def upload(store)
    if store.name.nil?
      puts "Skipping nil store: #{store.inspect}"
      return
    end

    result = Ohanakapa.post("organizations/#{wic_org['id']}/locations", query: {
      name: store.name,
      description: "Store accepting WIC benefits",
      address_attributes: {
        address_1: store.address,
        city: store.city,
        postal_code: store.zip5,
        county: store.county,
        country: "us"
      },
      latitude: store.latitude,
      longitude: store.longitude
    })
    location_id = result.id

    # A location service to add to all locations, with the standard category
    service = Ohanakapa.post("locations/#{location_id}/services", query: { name: 'wic', audience: 'WIC is accepted here.', description: 'WIC benefits are accepted here.'} )

    result = Ohanakapa.put("services/#{service.id}/categories", query: { taxonomy_ids: ['wic'] } )
     puts "Loaded #{store.name}"
  end

  def upload_file(filename)
    wic = Wic.new(filename)
    index = 0
    wic.stores.each do |store|
      if ['SACRAMENTO','YOLO','PLACER','SUTTER'].include? store.county.upcase
          index += 1
          upload(store)
      end
    end
    puts "Loaded #{index} wic stores"
  end

  def purge_all
    puts "PURGING WIC records"
    locations = Ohanakapa.get("organizations/#{wic_org['id']}/locations")
    while locations.size > 0 do
      puts "Found #{locations.size}"
      locations.each do |location|
        puts "Delete #{location.id} #{location.name}"
        Ohanakapa.delete("locations/#{location.id}")
      end
      locations = Ohanakapa.get("organizations/#{wic_org['id']}/locations")
    end
  end
end
