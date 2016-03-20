require "slop"
require "ostruct"

class CliParser
  def args
    Slop.parse do |opts|
      opts.bool '-e', '--upload-ebt', 'Upload an ebt file'
      opts.string '-f', '--filename', 'File to upload'
    end
  end
end
