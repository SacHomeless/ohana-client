require "ebt"

describe Ebt do
  describe "#new" do
    let(:ebt) {Ebt.new("./spec/support_files/ebt_locations.csv")}
    it "returns two ebt records" do
      expect(ebt.stores.count).to eql(2)
    end

    it "skips the first row" do
      store = ebt.stores.first
      expect(store.name).to eql("Store 1")
    end

    it "instantiates the last row correctly" do
      store = ebt.stores.last
      expect(store.name).to eql("Store 2")
      expect(store.longitude).to eql("-80.234567")
      expect(store.latitude).to eql("35.234567")
      expect(store.address).to eql("5678 Pleasant HWY")
      expect(store.address2).to eql("")
      expect(store.city).to eql("Anytown")
      expect(store.state).to eql("CA")
      expect(store.zip5).to eql("95678")
      expect(store.zip4).to eql("")
      expect(store.county).to eql("Sacramento")
    end
  end
end
