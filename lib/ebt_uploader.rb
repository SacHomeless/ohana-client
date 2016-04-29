require "ebt"
require "ohanakapa"
require 'ostruct'

class EbtUploader
  def ebt_org
    #TODO
    @ebt ||= Ohanakapa.organization('ebt')
  end

  def ebt_category
    #TODO
    #@ebt_category ||= Ohanakapa.organization(62)
    #puts @ebt_category.to_s
    #raise "halt"
    @ebt_category ||=  Ohanakapa.organization('ebt')
    raise if @ebt_category.nil?
    raise "@ebt_category is #{@ebt_category}"
  end

  def upload(store)
    if store.name.nil?
      puts "Skipping nil store: #{store.inspect}"
      return
    end

    #Ohanakapa.post('locations/1/services', query: { name: 'Free Eye Exam', audience: 'Low-income children between the ages of 5 and 12.', description: 'Provides free eye exams for low-income children between the ages of 5 and 12.' })

    result = Ohanakapa.post("organizations/#{ebt_org['id']}/locations", query: {
      name: store.name,
      description: "Store accepting EBT transactions",
      address_attributes: {
        address_1: store.address,
        city: store.city,
        state: store.state,
        postal_code: store.zip5,
        county: store.county,
        country: "us"
      },
      latitude: store.latitude,
      longitude: store.longitude
    })
    location_id = result.id

    # A location service to add to all locations, with the standard category
    service = Ohanakapa.post("locations/#{location_id}/services", query: { name: 'ebt', audience: 'EBT is accepted here.', description: 'EBT (Electronic Benefits Transfer) is accepted here.'} )

    result = Ohanakapa.put("services/#{service.id}/categories", query: { taxonomy_ids: ['ebt'] } )
    puts "Loaded #{store.name}.result of put was #{result}"
  end

  def upload_file(filename)
    ebt = Ebt.new(filename)
    index = 0
    ebt.stores.each do |store|
      if store.state == 'CA'
        if ['SACRAMENTO','YOLO','PLACER','SUTTER'].include? store.county.upcase
          index += 1
          upload(store)
        end
      end
    end
    puts "Loaded #{index} ebt stores"
  end

  def purge_all
    puts "PURGING EBT records"
    locations = Ohanakapa.get("organizations/#{ebt_org['id']}/locations")
    while locations.size > 0 do
      puts "Found #{locations.size}"
      locations.each do |location|
        puts "Delete #{location.id} #{location.name}"
        Ohanakapa.delete("locations/#{location.id}")
      end
      locations = Ohanakapa.get("organizations/#{ebt_org['id']}/locations")
    end
  end
end
