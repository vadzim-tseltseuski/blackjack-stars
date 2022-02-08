class Card
  SUITS = ['♦', '♣', '♥', '♠']
  VALUE = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  attr_accessor :face

  def initialize(value, suit, face = 0)
    @value = value
    @suit = suit
    @face = 0
  end

  def score
    return [value.to_i] if value[/^\d+$/]
    return [1, 11] if value == 'A'
    return [10]
  end

  def show
    return "[*]" if face == 0
    "[#{value}#{suit}]"
  end
end