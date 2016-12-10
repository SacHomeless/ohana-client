require "csv"
#require 'smarter_csv'
require 'ostruct'

class FoodDist
  attr_reader :stores

  Store = Struct.new(:name, :street, :city, :zip, :state, :phone, :days, :hours, :zip, :neighborhood,:notes)


  def initialize(filename)
    @stores = []
    index = 0
    begin
      CSV.foreach(filename, encoding: "ISO8859-1") do |row|
        index += 1
        next if row[2].nil? || row[1].nil?
        puts "#{index}--------------\n"
        #puts "**row[1] == #{row[1].gsub("\r", ' ')}"
        next if index <= 1
        address = parse_address_field(row[1])
        #puts "address parts == #{address}"
        @stores << Store.new(row[0].gsub("\r",' '),
                             address.street,
                             address.city,
                             address.zip,
                             address.state,
                             (row[2].gsub("\r",' ') if row[2]),
                             row[3].gsub("\r",' '),
                             row[4].gsub("\r",' '),
                             row[5].gsub("\r",' '),
                             row[6].gsub("\r",' '),
                             row[7].gsub("\r",' '))
      end
    rescue ArgumentError => e
      puts "Error on index #{index}"
      puts e
      exit
    end
    puts "Read #{@stores.size} food distribution stores"
  end

  def parse_address_field ( addr_field )
    addr_parts = addr_field.split("\r")
    addr_parts.each do |part|
      part.gsub!(/[, ]*$/, '')
    end
    addr_field = addr_parts.join(',')
    sub_parts = addr_field.split(',')
    puts addr_field
    if sub_parts[3].nil?
      state_zip = sub_parts[2].split ' '
      sub_parts[2] = state_zip[0]
      sub_parts[3] = state_zip[1]
    end
    OpenStruct.new(:street => sub_parts[0].strip, :city => sub_parts[1].strip, :state => sub_parts[2].strip, :zip => sub_parts[3].strip)
  end
end
