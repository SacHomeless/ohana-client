require "wic_uploader"
require 'ostruct'

describe WicUploader do
  let(:filename) { "./spec/support_files/wic_locations.csv" }
  let(:uploader) { WicUploader.new }
  let(:wic) { Wic.new(filename) }

  before do
    allow(wic).to receive(:puts)
    allow(Ohanakapa).to receive(:get)
    allow(Ohanakapa).to receive(:post)
    allow(Ohanakapa).to receive(:post).with("organizations/3/locations", anything).and_return(OpenStruct.new(:id => 3))
    allow(Ohanakapa).to receive(:post).with("locations", anything).and_return(OpenStruct.new(:id => "3"))
    allow(Ohanakapa).to receive(:post).with("locations/3/services", anything).and_return(OpenStruct.new(:id => "33"))
  end

  describe "#upload" do
    before do
      allow(uploader).to receive(:wic_org).and_return(OpenStruct.new(:id => 3))
    end
    it "creates the location" do
      expect(Ohanakapa).to receive(:post).with("organizations/3/locations", query: {
        name: "Wic Store 1",
        description: "Store accepting WIC benefits",
        address_attributes: {
          address_1: "7632 GREENBACK LN",
          city: "CITRUS HEIGHTS",
          postal_code: "95610",
          county: "SACRAMENTO",
          country: "us"
        },
        latitude: "38.678213",
        longitude: "-121.28356"
      })
      puts "SEND: #{wic.stores.first.name}"
      uploader.upload(wic.stores.first)
    end
  end

  describe "#upload_file" do
    let(:location_return) { OpenStruct.new( :id => 99 ) }
    let(:service_return) { OpenStruct.new( :id => 999 ) }
    it "creates all the things" do
      expect(Ohanakapa).to receive(:post).exactly(6).times.and_return(location_return, service_return, location_return, service_return, location_return, service_return)
      uploader.upload_file(filename)
    end
  end

  describe "#wic_org" do
    it "gets the wic org" do
      expect(uploader.wic_org)
    end
  end

  describe "#wic_category" do
    it "gets the wic category" do
      expect(uploader.wic_category)
    end
  end

  describe "#purge_all" do
    let(:location) { OpenStruct.new( :id => 99 ) }
    before do
      allow(uploader).to receive(:wic_org).and_return(OpenStruct.new(:id => 3))
      allow(Ohanakapa).to receive(:get).with("organizations/3/locations").and_return([location], [])
    end

    it "gets the wic org's locations" do
      expect(Ohanakapa).to receive(:get).with("organizations/3/locations")
      uploader.purge_all
    end

    it "gets the wic org's locations" do
      expect(Ohanakapa).to receive(:delete).with("locations/99")
      uploader.purge_all
    end
  end
end
