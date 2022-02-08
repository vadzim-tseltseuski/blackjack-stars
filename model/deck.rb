require_relative 'card'

class Deck
  attr_reader :deck

  def initialize
    deck = Card::VALUE.product(Card::SUITS).map {|value, suit| Card.new(value, suit)}
    @deck = (deck * 3).shuffle
  end

  def take_card(face_up = false)
    card = @deck.pop
    card.face = 1 if face_up
    card
  end
end