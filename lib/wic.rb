require "csv"

class Wic
  attr_reader :stores

  Store = Struct.new(:name, :address, :address2, :city, :zip5, :county, :longitude, :latitude)


  def initialize(filename)
    @stores = []
    index = 0
    begin
      CSV.foreach(filename, encoding: "ISO8859-1") do |row|
        index += 1
        next if index == 1
        coords = row[6].split(/[\(,\)]/)[1,2]
        @stores << Store.new(row[0], row[1], row[2], row[3], row[4], row[5], coords[1].strip, coords[0].strip)
      end
    rescue ArgumentError => e
      puts "Error on index #{index}"
      puts e
      exit
    end
  end
end
