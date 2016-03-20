require "ebt_uploader"

describe EbtUploader do
  let(:filename) { "./spec/support_files/ebt.csv" }
  let(:uploader) { EbtUploader.new }
  let(:ebt) { Ebt.new(filename) }

  before do
    allow(ebt).to receive(:puts)
    allow(Ohanakapa).to receive(:get)
    allow(Ohanakapa).to receive(:post)
    allow(Ohanakapa).to receive(:post).with("organizations", anything).and_return("id" => "3")
  end

  describe "#upload" do

    it "creates the organization" do
      expect(Ohanakapa).to receive(:post).with("organizations", query: { name: "Store 1", })
      uploader.upload(ebt.stores.first)
    end

    it "creates the location" do
      expect(Ohanakapa).to receive(:post).with("organizations/3/locations", query: {
        name: "Store 1",
        address: "1234 5th Street",
        city: "Sacramento",
        state: "CA"
      })
      uploader.upload(ebt.stores.first)
    end
  end

  describe "#upload_file" do
    it "creates all the things" do
      expect(Ohanakapa).to receive(:post).exactly(4).times
      uploader.upload_file(filename)
    end
  end
end
