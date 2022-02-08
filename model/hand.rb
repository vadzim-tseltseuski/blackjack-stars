class Hand
    attr_reader :cards

  def initialize
    @cards = []
  end

  def score
    cards.map(&:score).sum
  end

  def show
    cards.map(&:show)
  end
end