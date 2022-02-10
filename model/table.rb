require_relative 'deck'

class Table
  attr_accessor :player, :dealer, :deck
  attr_reader :bank

  def initialize
    @deck = Deck.new
    @bank = {player: 0, dealer: 0}
  end

  def sum_bank
    bank.values.sum
  end

  [:player, :dealer].each do |type|
      define_method "deal_card_for_#{type}" do
        face_up = true if type == :player
        eval("#{type}").hand.cards << deck.take_card(face_up)
      end
  end

  def show
    "#{player.name} - #{player.hand.score}\n#{player.hand.show}\nDealer - #{dealer.hand.score}\n#{dealer.hand.show}"
  end

end