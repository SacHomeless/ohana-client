require "csv"

class Ebt
  attr_reader :stores

  Store = Struct.new(:name, :longitude, :latitude, :address, :address2, :city, :state, :zip5, :zip4, :county)


  def initialize(filename)
    @stores = []
    index = 0
    begin
      CSV.foreach(filename, encoding: "ISO8859-1") do |row|
        index += 1
        next if index == 1
        @stores << Store.new(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9])
      end
    rescue ArgumentError => e
      puts "Error on index #{index}"
      puts e
      exit
    end
  end
end
