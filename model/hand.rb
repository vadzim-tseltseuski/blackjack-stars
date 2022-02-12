class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def score
    return 0 if cards.empty?

    all_combination.reduce do |curr, prev|
      if curr.sum > 21 && prev.sum > 21
        21 - curr.sum > 21 - prev.sum ? curr : prev
      elsif curr.sum < 21 && prev.sum < 21
        21 - curr.sum < 21 - prev.sum ? curr : prev
      else
        curr.sum > 21 ? prev : curr
      end
    end.sum
  end

  def show(face = true)
    cards.map { |card| card.show(face) }.join(' ')
  end

  def drop
    cards.clear
  end

  def size
    cards.size
  end

  def all_combination
    arr = cards.map(&:score)
    arr.shift.product(*arr)
  end
end
