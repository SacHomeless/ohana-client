require "csv"

class Ebt
  Store = Struct.new(:name, :address, :city, :state, :state_origin)

  def initialize(filename)
    @rows = []
    index = 0
    CSV.foreach(filename) do |row|
      index += 1
      next if index == 1
      @rows << Store.new(row[0], row[1], row[2], row[3], row[4])
    end
  end

  def rows
    @rows
  end
end
