class CommandRunner
  def initialize(args, uploader = EbtUploader.new)
    @uploader = uploader
    @args = args
  end

  def run
    if @args.upload_ebt?
      @uploader.upload_file(@args[:filename])
    end
  end
end
