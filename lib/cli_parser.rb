require "slop"
require "ostruct"

class CliParser
  def args
    opts_help = Slop.parse do |opts|
      opts.bool '-t', '--test', 'perform a test'
      opts.bool '-e', '--upload-ebt', 'Upload an ebt file'
      opts.bool '-w', '--upload-wic', 'Upload a wic file'
      opts.bool '-p', '--upload-food-dist', 'Upload a food-dist file'
      opts.bool '--purge-ebt', 'Purge ebt locations'
      opts.bool '--purge-wic', 'Purge wic locations'
      opts.bool '--purge-food', 'Purge food dist locations'
      opts.string '-f', '--filename', 'File to upload'
      opts.bool '-h', '--help', 'This output'
    end
  end
end
