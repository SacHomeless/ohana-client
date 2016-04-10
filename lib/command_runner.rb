class CommandRunner
  def initialize(args, ebt_uploader = EbtUploader.new,
                 wic_uploader = WicUploader.new)
    @ebt_uploader = ebt_uploader
    @wic_uploader = wic_uploader
    @args = args
  end

  def run
    if @args.upload_ebt?
      @ebt_uploader.upload_file(@args[:filename])
    end
    if @args.upload_wic?
      @wic_uploader.upload_file(@args[:filename])
    end
    if @args.purge_ebt?
      @ebt_uploader.purge_all
    end

    if @args.purge_wic?
      @wic_uploader.purge_all
    end
  end
end
