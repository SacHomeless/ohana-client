require "food_dist"

describe FoodDist do
  describe "#new" do
    let(:food_dist) {FoodDist.new("./spec/support_files/Food_Dist.csv")}
    it "returns two food_dist records" do
      expect(food_dist.stores.count).to eql(111)
    end

    it "skips the first row" do
      store = food_dist.stores.first
      expect(store.name).to eql("Carmichael Presbyterian Church")
    end

    it "instantiates the last row correctly" do
      store = food_dist.stores[1]
      expect(store.name).to eql("S.V.D.P. Our Lady of Assumption")
      expect(store.street).to eql("5057 Cottage Way")
      expect(store.city).to eql("Carmichael")
      expect(store.state).to eql("CA")
      expect(store.zip).to eql("95608")
      expect(store.neighborhood).to eql("Carmichael")
      expect(store.notes).to eql('Food distribution')
    end
  end

  describe "#parse_address_field" do
    let(:food_dist) {FoodDist.new("./spec/support_files/Food_Dist.csv")}
    it "parses addresses" do
      struct = food_dist.parse_address_field "2771 Grove Ave,\rSacramento, CA\r95815"
        expect(struct.street).to eq("2771 Grove Ave")
        expect(struct.city).to eq("Sacramento")
    end
  end
end
