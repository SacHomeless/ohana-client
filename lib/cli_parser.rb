require "slop"
require "ostruct"

class CliParser
  def args
    Slop.parse do |opts|
      opts.bool '-e', '--upload-ebt', 'Upload an ebt file'
      opts.bool '-w', '--upload-wic', 'Upload a wic file'
      opts.bool '--purge-ebt', 'Purge ebt locations'
      opts.bool '--purge-wic', 'Purge wic locations'
      opts.string '-f', '--filename', 'File to upload'
    end
  end
end
