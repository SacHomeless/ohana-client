class CommandRunner
  def initialize(args, ebt_uploader = EbtUploader.new,
                 wic_uploader = WicUploader.new, food_dist_uploader = FoodDistUploader.new)
    @ebt_uploader = ebt_uploader
    @wic_uploader = wic_uploader
    @food_dist_uploader = food_dist_uploader
    @tester = Tester.new
    @args = args
  end

  def run

    if @args.help?
      puts @args
      exit
    end

    if @args.test?
      @tester.test
    end
    if @args.upload_ebt?
      @ebt_uploader.upload_file(@args[:filename])
    end

    if @args.upload_wic?
      @wic_uploader.upload_file(@args[:filename])
    end

    if @args.upload_food_dist?
      @food_dist_uploader.upload_file(@args[:filename])
    end

    if @args.purge_ebt?
      @ebt_uploader.purge_all
    end

    if @args.purge_wic?
      @wic_uploader.purge_all
    end

    if @args.purge_food?
      @food_dist_uploader.purge_all
    end
  end
end
