require "ebt"
require "ohanakapa"

class EbtUploader
  def upload(store)
    # puts "uploading #{store.inspect}"
    new_organization = Ohanakapa.post('organizations', query: {name: store.name})
    Ohanakapa.post("organizations/#{new_organization['id']}/locations", query: {
      name: store.name,
      address: store.address,
      city: store.city,
      state: store.state
    })
  end

  def upload_file(filename)
    ebt = Ebt.new(filename)
    ebt.stores.each do |store|
      upload(store)
    end
  end
end
