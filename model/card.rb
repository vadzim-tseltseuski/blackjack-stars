class Card
  SUITS = ['♦', '♣', '♥', '♠']
  VALUE = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def cost
    return [value.to_i] if value[/^\d+$/]
    return [1, 11] if value == 'A'
    return [10]
  end

  def to_s
    "[#{value}#{suit}]"
  end
end