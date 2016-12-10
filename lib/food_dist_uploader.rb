require "food_dist"
require "ohanakapa"
require 'ostruct'

class FoodDistUploader
  def food_dist_org
    #TODO
    @food_dist ||= Ohanakapa.organization('food-distribution-list')
  end

  def food_dist_category
    #TODO
    #@food_dist_category ||= Ohanakapa.rganization(62)
    #raise "halt"
    @food_dist_category ||= Ohanakapa.organization('food_distribution')
    raise if @food_dist_category.nil?
    raise "@food_dist_category is #{@food_dist_category}"
  end

  def upload(store)
    if store.name.nil?
      puts "Skipping nil store: #{store.inspect}"
      return
    end

    result = Ohanakapa.post("organizations/#{food_dist_org['id']}/locations", query: {
      name: store.name,
      description: store.notes,
      address_attributes: {
        address_1: store.street,
        city: store.city,
        postal_code: store.zip,
        country: "us"
      }
    })
    location_id = result.id

    # A location service to add to all locations, with the standard category
    service = Ohanakapa.post("locations/#{location_id}/services", query: { name: 'food-pantry', audience: 'public.', description: 'Food distribution.'} )

    result = Ohanakapa.put("services/#{service.id}/categories", query: { taxonomy_ids: ['food_distribution'] } )
     puts "Loaded #{store.name}"
  end

  def upload_file(filename)
    food_dist = FoodDist.new(filename)
    index = 0
    food_dist.stores.each do |store|
      index += 1
      upload(store)
    end
    puts "Loaded #{index} food_dist stores"
  end

  def purge_all
    puts "PURGING food_dist records"
    locations = Ohanakapa.get("organizations/#{food_dist_org['id']}/locations")
    while locations.size > 0 do
      puts "Found #{locations.size}"
      locations.each do |location|
        puts "Delete #{location.id} #{location.name}"
        Ohanakapa.delete("locations/#{location.id}")
      end
      locations = Ohanakapa.get("organizations/#{food_dist_org['id']}/locations")
    end
  end
end
