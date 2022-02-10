class Hand
    attr_reader :cards

  def initialize
    @cards = []
  end

  def score
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

  def show
    cards.map(&:show).join(" ")
  end

  def size
    cards.size
  end



  def all_combination
    arr = cards.map(&:score)
    arr.shift.product(*arr)
  end
end