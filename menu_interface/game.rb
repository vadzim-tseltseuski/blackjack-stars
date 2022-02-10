require_relative '../model/player'
require_relative '../model/dealer'
require_relative '../model/table'

class Game
    attr_reader :now_move, :table

  class << self
    def start_game
      Game.new.show_menu
    end
  end

  def initialize
    create_table
    create_player
    create_dealer
    2.times do
      table.deal_card_for_player
      table.deal_card_for_dealer
    end
    @now_move = table.player
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
    finish_menu
  end

  MENU = {
    '1' => { text: 'Пропустить', method: 'skip'},
    '2' => { text: 'Добавить карту', method: 'add_card'},
    '3' => { text: 'Открыть карты', method: 'finish_menu'}
  }

  private

  def finish_menu
    puts result_msg
    puts '0 - ВЫХОД'
    puts '1 - Сыграть еще?'
    menu_key = gets.chomp
    return if menu_key == '0'
    Game.start_game
  end

  def result_msg
    p_score = table.player.hand.score
    d_score = table.dealer.hand.score
    if p_score > 21 && d_score > 21
      "У обоих перебор"
    elsif p_score < 21 && d_score > 21
      "Игрок победил. Дилер перебор"
    elsif p_score > 21 && d_score < 21
      "Дилер победилю. Игрок перебор"
    elsif 21 - p_score < d_score - 21
      "Игрок победил"
    elsif 21 - p_score > d_score - 21
      "Дилер победил"
    else
        "Ничья"
    end
  end

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