require 'io/console'

require_relative '../model/player'
require_relative '../model/dealer'
require_relative '../model/table'

class Game
  attr_reader :now_move, :table

  class << self
    def start_game
      Game.new.new_round
    end
  end

  def initialize
    create_table
    create_player
    create_dealer
  end

  def new_round
    system 'clear'
    puts table.show(true)
    sleep(1)
    table.get_bet
    2.times do
      table.deal_card_for_player
      table.deal_card_for_dealer
    end
    show_menu
  end

  private

  MENU = {
    '1' => { text: 'Пропустить', method: 'skip' },
    '2' => { text: 'Добавить карту', method: 'add_card' },
    '3' => { text: 'Открыть карты', method: 'finish' }
  }

  def show_menu
    loop do
      system 'clear'
      puts table.show
      sleep(1)
      break if finish_game?

      puts '0 - ВЫХОД'
      MENU.each { |k, v| puts "#{k} - #{v[:text]}" }
      print 'Сделайте выбор >> '
      menu_key = gets.chomp
      exit if menu_key == '0'
      next unless MENU[menu_key]

      send(MENU[menu_key][:method])
    end
    finish
  end

  def finish
    system 'clear'
    game_result = result
    table.pay_win(game_result)

    puts table.show(true)
    puts RESULT_MSG[game_result]
    continue_story
    table.player.hand.drop
    table.dealer.hand.drop
    finish_menu
  end

  def finish_menu
    system 'clear'
    puts table.show(true)
    sleep(1)
    puts '0 - ВЫХОД'
    puts '1 - Сыграть еще?'
    print '>> '
    menu_key = gets.chomp
    exit if menu_key == '0'

    new_round
  end

  def result
    p_score = table.player.hand.score
    d_score = table.dealer.hand.score
    if p_score > 21 && d_score > 21
      :bust
    elsif p_score <= 21 && d_score > 21
      :player_win
    elsif p_score > 21 && d_score <= 21
      :dealer_win
    elsif 21 - p_score < 21 - d_score
      :player_win
    elsif 21 - p_score > 21 - d_score
      :dealer_win
    else
      :draw
    end
  end

  RESULT_MSG = {
    player_win: 'Игрок победил',
    dealer_win: 'Дилер победил',
    draw: 'Ничья',
    bust: 'У обоих перебор'
  }

  def finish_game?
    (table.player.hand.size == 3 && table.dealer.hand.size == 3)
  end

  def skip
    dealer_move
  end

  def dealer_move
    if table.dealer.one_more_card?
      table.deal_card_for_dealer
      system 'clear'
      puts table.show
      puts 'Дилер набрал...'
      sleep(1)
    else
      puts 'Дилер больше не набирает...'
      sleep(1)
    end
    finish
  end

  def add_card
    if table.player.one_more_card?
      table.deal_card_for_player
      system 'clear'
      puts table.show
      puts 'Вы набрали карту...'
      sleep(1)
    else
      puts 'Вы не можете набрать больше карт...'
      sleep(1)
    end

    dealer_move
  end

  def create_player
    system 'clear'
    puts '------------------'
    puts 'Введите имя игрока'
    puts '------------------'
    begin
      print '>> '
      name = gets.chomp
      table.player = Player.new(name)
      sleep(1)
      system 'clear'
      puts "Игрок #{name} присоединился..."
    rescue ValidationError => e
      puts e
      continue_story
      retry
    end
  end

  def create_dealer
    table.dealer = Dealer.new
    puts 'Дилер присоединился...'
    sleep(1)
    system 'clear'
  end

  def create_table
    @table = Table.new
  end

  def continue_story
    puts '_____________________________'
    print 'press any key to continue...'
    $stdin.getch
    print ''
  end
end
