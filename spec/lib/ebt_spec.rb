require "ebt"

describe Ebt do
  describe "#new" do
    let(:ebt) {Ebt.new("./spec/support_files/ebt.csv")}
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
      expect(store.address).to eql("2345 6th Street")
      expect(store.city).to eql("San Francisco")
      expect(store.state).to eql("CA")
      expect(store.state_origin).to eql("CA")
    end
  end
end
