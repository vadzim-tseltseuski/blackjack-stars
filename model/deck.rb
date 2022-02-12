require_relative 'card'

class Deck
  attr_reader :deck

  def initialize
    deck = Card::VALUE.product(Card::SUITS).map { |value, suit| Card.new(value, suit) }
    @deck = (deck * 3).shuffle
  end

  def take_card
    @deck.pop
  end
end
