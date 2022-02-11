require_relative '../model/player'
require_relative '../model/dealer'
require_relative '../model/table'

class Game
    attr_reader :now_move, :table

  class << self
    def start_game
      Game.new.round
    end
  end

  def initialize
    create_table
    create_player
    create_dealer
  end

  def round
    system 'clear'
    table.get_bet
    2.times do
      table.deal_card_for_player
      table.deal_card_for_dealer
    end
    show_menu
  end

  def show_menu
    loop do
        puts table.show
        break if finish_game?
        puts '0 - ВЫХОД'
        MENU.each { |k, v| puts "#{k} - #{v[:text]}" }
        print "Сделайте выбор >> "
        menu_key = gets.chomp
        return if menu_key == '0'

        send(MENU[menu_key][:method])
        system 'clear'
      end
    finish
  end

  MENU = {
    '1' => { text: 'Пропустить', method: 'skip'},
    '2' => { text: 'Добавить карту', method: 'add_card'},
    '3' => { text: 'Открыть карты', method: 'finish'}
  }

private

  def finish
    system 'clear'
    game_result = result
    puts game_result
    sleep(2)
    table.pay_win(game_result)
    puts RESULT_MSG[game_result]
    puts table.player.hand.show
    puts table.dealer.hand.face_up.show
    continue_story
    table.player.hand.drop
    table.dealer.hand.drop
    finish_menu
  end

  def finish_menu
    system 'clear'
    puts '0 - ВЫХОД'
    puts '1 - Сыграть еще?'
    menu_key = gets.chomp
    return if menu_key == '0'

    round
  end

  def result
    p_score = table.player.hand.score
    d_score = table.dealer.hand.score
    if p_score > 21 && d_score > 21
      :bust
    elsif p_score < 21 && d_score > 21
      :player_win
    elsif p_score > 21 && d_score < 21
      :dealer_win
    elsif 21 - p_score < d_score - 21
      :player_win
    elsif 21 - p_score > d_score - 21
      :dealer_win
    else
      :draw
    end
  end

  RESULT_MSG = {
    player_win: "Игрок победил",
    dealer_win: "Дилер победилю",
    draw: "Ничья",
    bust: "У обоих перебор"
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
    else
      puts "Дилер больше не набирает..."
      sleep(1)
    end
  end

  def add_card
    if table.player.one_more_card?
      table.deal_card_for_player
      dealer_move
    else
        puts "Вы не можете набрать больше карт"
        sleep(1)
      end
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
    puts "Дилер присоединился..."
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