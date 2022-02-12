class Dealer < Player
  def initialize
    super('Dealer', 100, :dealer)
  end

  def one_more_card?
    hand.score < 17 && hand.size < 3
  end
end
