require "ebt"
require "ohanakapa"
require 'ostruct'

class EbtUploader
  def ebt_org
    #@ebt ||= Ohanakapa.organization(62)
    @ebt ||= OpenStruct.new(:id => 62)
  end

  def upload(store)
    if store.name.nil?
      puts "Skipping nil store: #{store.inspect}"
      return
    end
    Ohanakapa.post("organizations/#{ebt_org['id']}/locations", query: {
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
  end

  def upload_file(filename)
    ebt = Ebt.new(filename)
    index = 0
    ebt.stores.each do |store|
      if store.state == 'CA'
        if ['SACRAMENTO','YOLO','PLACER','EL DORADO','SUTTER'].include? store.county.upcase
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
    puts "Found #{locations.size}"
    locations.each do |location|
      puts "Delete #{location.id} #{location.name}"
      Ohanakapa.delete("locations/#{location.id}")
    end
  end
end
