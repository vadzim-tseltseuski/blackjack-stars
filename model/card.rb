class Card
  SUITS = ['♦', '♣', '♥', '♠']
  VALUE = %w[2 3 4 5 6 7 8 9 10 J Q K A]

  attr_reader :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def score
    return [value.to_i] if value[/^\d+$/]
    return [1, 11] if value == 'A'

    [10]
  end

  def show(face = true)
    return '[*]' unless face

    "[#{value}#{suit}]"
  end
end
