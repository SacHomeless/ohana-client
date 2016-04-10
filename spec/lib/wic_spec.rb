require "wic"

describe Wic do
  describe "#new" do
    let(:wic) {Wic.new("./spec/support_files/wic_locations.csv")}
    it "returns two wic records" do
      expect(wic.stores.count).to eql(3)
    end

    it "skips the first row" do
      store = wic.stores.first
      expect(store.name).to eql("Wic Store 1")
    end

    it "instantiates the last row correctly" do
      store = wic.stores[1]
      expect(store.name).to eql("Wic Store 2")
      expect(store.longitude).to eql("-121.50211")
      expect(store.latitude).to eql("38.564441")
      expect(store.address).to eql("831 BROADWAY")
      expect(store.address2).to eql(nil)
      expect(store.city).to eql("SACRAMENTO")
      expect(store.zip5).to eql("95818")
    end
  end
end
