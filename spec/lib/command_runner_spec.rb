require "command_runner"
require "ebt_uploader"
require "ostruct"

describe CommandRunner do
  let(:args)     { OpenStruct.new(upload_ebt?: true) }
  let(:filename) { "./spec/support_files/ebt.csv" }
  let(:ebt)      { Ebt.new(filename) }
  let(:store)    { ebt.stores.first }
  let(:uploader) { EbtUploader.new }
  let(:runner)   { CommandRunner.new(args, uploader) }

  it "uploads an ebt file" do
    allow(args).to receive(:[]).with(:filename).and_return("foo.csv")
    expect(uploader).to receive(:upload_file).with("foo.csv")
    runner.run
  end
end
