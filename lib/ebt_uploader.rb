require "ebt"
require "ohanakapa"

class EbtUploader
  def upload(store)
    if store.name.nil?
      puts "Skipping nil store: #{store.inspect}"
      return
    end
    new_organization = Ohanakapa.post('organizations', query: {name: store.name, description: "Store accepting EBT transactions"})

    Ohanakapa.post("organizations/#{new_organization['id']}/locations", query: {
      name: store.name,
      description: "Store accepting EBT transactions",
      address_attributes: {
        address_1: store.address,
        city: store.city,
        state: store.state,
        postal_code: "11111",
        country: "us"
      }
    })
  end

  def upload_file(filename)
    ebt = Ebt.new(filename)
    ebt.stores.each do |store|
      upload(store)
    end
  end
end
