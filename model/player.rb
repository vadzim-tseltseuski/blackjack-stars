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

  def one_more_card?
    hand.size < 3
  end

  def bet(bet_sum = 10)
    self.bankroll -= bet_sum
    bet_sum
  end

  def get_win(win_sum)
    self.bankroll += win_sum
  end
end

