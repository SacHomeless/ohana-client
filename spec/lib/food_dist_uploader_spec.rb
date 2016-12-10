require "food_dist_uploader"
require 'ostruct'

describe FoodDistUploader do
  let(:filename) { "./spec/support_files/food_dist.csv" }
  let(:uploader) { FoodDistUploader.new }
  let(:food_dist) { FoodDist.new(filename) }

  before do
    allow(food_dist).to receive(:puts)
    allow(Ohanakapa).to receive(:get)
    allow(Ohanakapa).to receive(:post)
    allow(Ohanakapa).to receive(:post).with("organizations/3/locations", anything).and_return(OpenStruct.new(:id => 3))
    allow(Ohanakapa).to receive(:post).with("locations", anything).and_return(OpenStruct.new(:id => "3"))
    allow(Ohanakapa).to receive(:post).with("locations/3/services", anything).and_return(OpenStruct.new(:id => "33"))
  end

  describe "#upload" do
    before do
      allow(uploader).to receive(:food_dist_org).and_return(OpenStruct.new(:id => 3))
    end
    it "creates the location" do
      expect(Ohanakapa).to receive(:post).with("organizations/3/locations", query: {
        name: "Store 1",
        description: "Food Distribution site",
        address_attributes: {
          address_1: "100 Marconi Ave",
          city: "Carmichael",
          postal_code: "95608",
          country: "us"
        }
      })
      puts "SEND: #{food_dist.stores.first.name}"
      uploader.upload(food_dist.stores.first)
    end
  end

  describe "#upload_file" do
    let(:location_return) { OpenStruct.new( :id => 99 ) }
    let(:service_return) { OpenStruct.new( :id => 999 ) }
    it "creates all the things" do
      expect(Ohanakapa).to receive(:post).exactly(4).times.and_return(location_return, service_return, location_return, service_return)
      uploader.upload_file(filename)
    end
  end

  describe "#food_dist_org" do
    it "gets the food_dist org" do
      expect(uploader.food_dist_org)
    end
  end

  describe "#food_dist_category" do
    it "gets the food_dist category" do
      expect(uploader.food_dist_category)
    end
  end

  describe "#purge_all" do
    let(:location) { OpenStruct.new( :id => 99 ) }
    before do
      allow(uploader).to receive(:food_dist_org).and_return(OpenStruct.new(:id => 3))
      allow(Ohanakapa).to receive(:get).with("organizations/3/locations").and_return([location], [])
    end

    it "gets the food dist org's locations" do
      expect(Ohanakapa).to receive(:get).with("organizations/3/locations")
      uploader.purge_all
    end

    it "gets the food dist  org's locations" do
      expect(Ohanakapa).to receive(:delete).with("locations/99")
      uploader.purge_all
    end
  end
end
