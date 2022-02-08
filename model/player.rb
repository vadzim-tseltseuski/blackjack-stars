require_relative 'bankroll'
require_relative 'validation/validation'

class Player
  include Validation

  attr_accessor :name
  attr_reader :bankroll, :hand

  validate :name, :presence
  validate :name, :type, String
  validate :bankroll, :type, Bankroll


  def initialize(name, bankroll)
    @name = name
    @bankroll = bankroll
    @hand = nil
    validate!
  end

  def hand_score
  end


end