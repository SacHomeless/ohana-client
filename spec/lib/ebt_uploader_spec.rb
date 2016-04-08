require "ebt_uploader"
require 'ostruct'

describe EbtUploader do
  let(:filename) { "./spec/support_files/ebt_locations.csv" }
  let(:uploader) { EbtUploader.new }
  let(:ebt) { Ebt.new(filename) }

  before do
    allow(ebt).to receive(:puts)
    allow(Ohanakapa).to receive(:get)
    allow(Ohanakapa).to receive(:post)
    allow(Ohanakapa).to receive(:post).with("locations", anything).and_return("id" => "3")
  end

  describe "#upload" do
    before do
      allow(uploader).to receive(:ebt_org).and_return(OpenStruct.new(:id => 3))
    end
    it "creates the location" do
      expect(Ohanakapa).to receive(:post).with("organizations/3/locations", query: {
        name: "Store 1",
        description: "Store accepting EBT transactions",
        address_attributes: {
          address_1: "1234 Mayberry Hwy",
          city: "Someville",
          state: "CA",
          postal_code: "98765",
          county: "Sacramento",
          country: "us"
        },
        latitude: "32.123456",
        longitude: "-80.123456"
      })
      uploader.upload(ebt.stores.first)
    end
  end

  describe "#upload_file" do
    it "creates all the things" do
      expect(Ohanakapa).to receive(:post).exactly(2).times
      uploader.upload_file(filename)
    end
  end

  describe "#ebt_org" do
    it "gets the ebt org" do
      expect(uploader.ebt_org)
    end
  end

  describe "#ebt_category" do
    it "gets the ebt category" do
      expect(uploader.ebt_category)
    end
  end

  describe "#purge_all" do
    let(:location) { OpenStruct.new( :id => 99 ) }
    before do
      allow(uploader).to receive(:ebt_org).and_return(OpenStruct.new(:id => 3))
      allow(Ohanakapa).to receive(:get).with("organizations/3/locations").and_return([location])
    end

    it "gets the ebt org's locations" do
      expect(Ohanakapa).to receive(:get).with("organizations/3/locations")
      uploader.purge_all
    end

    it "gets the ebt org's locations" do
      expect(Ohanakapa).to receive(:delete).with("locations/99")
      uploader.purge_all
    end
  end
end
