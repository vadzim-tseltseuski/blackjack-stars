require_relative 'deck'

class Table
  attr_accessor :player, :dealer, :deck
  attr_reader :bank

  def initialize
    @deck = Deck.new
    @bank = { player: 0, dealer: 0 }
  end

  def sum_bank
    bank.values.sum
  end

  %i[player dealer].each do |type|
    define_method "deal_card_for_#{type}" do
      eval(type.to_s).hand.cards << deck.take_card
    end
  end

  def get_bet
    bank[:player] = player.bet
    bank[:dealer] = dealer.bet
  end

  def pay_win(result)
    case result
    when :player_win
      player.get_win(sum_bank)
    when :dealer_win
      dealer.get_win(sum_bank)
    when :draw, :bust
      player.get_win(bank[:player])
      dealer.get_win(bank[:dealer])
    end
    bank.each { |k, _| bank[k] = 0 }
  end

  def show(all = false)
    %(
++++++++++++++++++++++++++
Банкролл игрока: #{player.bankroll} $
#{player.name} - #{player.hand.score} score
#{player.hand.show}

++++++++++++++++++++++++++
Банкролл дилера: #{dealer.bankroll} $
Dealer - #{all ? dealer.hand.score : '**'} score
#{dealer.hand.show(all)}

++++++++++++++++++++++++++
В банке #{sum_bank} $

)
  end
end
