require_relative 'validation/validation'
require_relative 'hand'

class Player
  include Validation

  attr_accessor :name, :hand, :bankroll, :table

  validate :name, :presence
  validate :name, :type, String

  def initialize(name, bankroll = 100, type = :player)
    @name = name
    @bankroll = bankroll
    @hand = Hand.new
    @type = type
    validate!
  end

  def sit_table(table)
    table.send(@type, self)
    @table = table
  end

  def make_bet(bet_sum = 10)
    bankroll -= bet_sum
    table.send("#{@type}_bet", bet_sum)
  end

end