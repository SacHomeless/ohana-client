require "csv"

class Ebt
  attr_reader :stores

  Store = Struct.new(:name, :address, :city, :state, :state_origin)

  def initialize(filename)
    @stores = []
    index = 0
    CSV.foreach(filename) do |row|
      index += 1
      next if index == 1
      @stores << Store.new(row[0], row[1], row[2], row[3], row[4])
    end
  end
end
