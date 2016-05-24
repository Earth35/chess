class Chess
  attr_reader :player_1, :player_2, :save_file
  attr_accessor :board, :current_player
  
  def initialize
    @save_file = './lib/save.yaml'
    @player_1 = Player.new(:white)
    @player_2 = Player.new(:black)
    @board = Board.new
    @player_1.king = @board.state[0][4]
    @player_2.king = @board.state[7][4]
    @current_player = @player_1
  end
  
  def start
    draw_title
    puts "Would you like to START a new game or LOAD saved state?"
    choice = gets.chomp.downcase
    while choice !~ /^start$|^load$/
      puts "Invalid input. Start/load only:"
      choice = gets.chomp.downcase
    end
    case choice
    when "start"
      begin_game
    when "load"
      load_game
    end
  end
  
  def move
    move_valid = false
    while !move_valid
      puts "Make a move or type 'save' to save the game:"
      user_input = gets.chomp.downcase # e.g. a0, a1
      if user_input == 'save'
        save_state
        puts "Game saved. Please make a move:"
        user_input = gets.chomp.downcase # e.g. a0, a1
      end
      until input_valid?(user_input)  # checkpoint 1 - checks if the player doesn't try to move beyond the board
        puts "Invalid input. Correct formatting example: a1, a5"
        user_input = gets.chomp.downcase
      end
      raw_coords = user_input.split(/, /)
      coordinates = input_to_coords(raw_coords[0], raw_coords[1])
      move_valid = validate_move(@board.state, coordinates)
      if move_valid
        move_selected_piece(@board.state, coordinates)
        king_position = @board.state[coordinates[0][1]][coordinates[0][0]].class == King ? coordinates[1].reverse : @current_player.king.position
        danger_zones = find_danger_zones(@current_player.king, @board.state)
        move_valid = danger_zones.include?(king_position) ? false : true
        if !move_valid
          puts "Invalid move, your King would be at risk"
          move_selected_piece(@board.state, coordinates.reverse)
        end
      end
    end
    promotion_status = promotion?(@board.state, coordinates)
  end
  
  def checkmate?
    status = false
    opponent = @current_player == @player_1 ? @player_2 : @player_1
    danger_zones = find_danger_zones(opponent.king, @board.state)
    puts "Check!" if danger_zones.include?(opponent.king.position)
    king_escape_options = opponent.king.danger_zones(@board.state)
    possible_moves = 0
    king_escape_options.each { |square| possible_moves += 1 if !danger_zones.include?(square) }
    countermeasures = false
    # check possible opponent moves in next turn and 'danger zones' for each of them
    # if king no longer is in at risk, don't call checkmate and stop searching
    row = 0
    col = 0
    while (0..7).include?(row)
      while (0..7).include?(col)
        position = @board.state[row][col]
        if !position.nil?
          if position.color == opponent.king.color
            next_possible_moves = position.danger_zones(@board.state)
            next_possible_moves.each do |move|
              # mock piece movement for checkmate / checkmate countering testing
              move_selected_piece_mock(@board.state, [[col, row], move.reverse])
              new_danger_zones = find_danger_zones(opponent.king, @board.state)
              if !new_danger_zones.include?(opponent.king.position)
                countermeasures = true
                # revert mock move, stop searching - found at least 1 move
                move_selected_piece_mock(@board.state, [move.reverse, [col, row]])
                break
              end
              # revert mock move
              move_selected_piece_mock(@board.state, [move.reverse, [col, row]])
            end
          end
        end
        col += 1
      end
      col = 0
      row += 1
    end
    if possible_moves == 0 && danger_zones.include?(opponent.king.position) && !countermeasures
      puts "Checkmate!"
      status = game_over(@current_player)
    end
    # return true on checkmate, otherwise return false
    return status
  end
  
  protected
  
  def begin_game
    puts "#{@current_player.color.to_s.capitalize} player's turn."
    loop do
      draw_board
      move
      if checkmate?
        draw_board
        break
      end
      switch_players
    end
  end
  
  private
  
  def draw_title
    puts "--==*=*=*==--".center(50, " ")
    puts "-=*=- Chess -=*=-".center(50, " ")
    puts "--==*=*=*==--".center(50, " ")
  end
  
  def draw_board
    print @board.draw_board(@board.state)
  end
  
  # converts strings to arrays of coordinates, e.g. "a1" and "a2" => [[0, 0], [0, 1]]
  # arguments must be validated and properly formatted beforehand
  def input_to_coords (source, target)
    coord_map = {
      'a' => 0, '1' => 0,
      'b' => 1, '2' => 1,
      'c' => 2, '3' => 2,
      'd' => 3, '4' => 3,
      'e' => 4, '5' => 4,
      'f' => 5, '6' => 5,
      'g' => 6, '7' => 6,
      'h' => 7, '8' => 7
    }
    source_in = source.split(//)
    source_out = [coord_map[source_in[0]], coord_map[source_in[1]]]
    target_in = target.split(//)
    target_out = [coord_map[target_in[0]], coord_map[target_in[1]]]
    return [source_out, target_out]
  end
  
  def input_valid? (input)
    # correct format: e.g. 'a1, a6'
    result = input =~ /^[a-h][1-8], [a-h][1-8]$/ ? true : false
  end
  
  def validate_move (board, coordinates)
    # coordinates: [[initial_position], [target_position]]
    # find initial position and check if nil
    initial_position = board[coordinates[0][1]][coordinates[0][0]]
    if initial_position.nil?
      puts "Invalid initial position. Selected empty square."
      return false
    elsif initial_position.color != @current_player.color
      puts "Invalid initial position. Selected opponent's piece."
      return false
    end
    # find target position and check if nil or opposite color
    target_position = board[coordinates[1][1]][coordinates[1][0]]
    if initial_position.movement_valid?(board, coordinates)
      if target_position.nil?
        return true
      elsif target_position.color != @current_player.color
        return true
      else
        puts "Position taken by your own piece. Movement invalid, enter new coordinates:"
        return false
      end
    else
      puts "Invalid target position."
      return false
    end
  end
  
  def move_selected_piece (board, coordinates)
    # move piece from initial to target position, then change initial position to nil
    board[coordinates[1][1]][coordinates[1][0]] = board[coordinates[0][1]][coordinates[0][0]]
    board[coordinates[1][1]][coordinates[1][0]].position = [coordinates[1][1], coordinates[1][0]]
    board[coordinates[0][1]][coordinates[0][0]] = nil
  end
  
  def move_selected_piece_mock (board, coordinates)
    # move piece from initial to target position, then change initial position to nil
    board[coordinates[1][1]][coordinates[1][0]], board[coordinates[0][1]][coordinates[0][0]]  = board[coordinates[0][1]][coordinates[0][0]], board[coordinates[1][1]][coordinates[1][0]]
    board[coordinates[1][1]][coordinates[1][0]].position = [coordinates[1][1], coordinates[1][0]]
    # board[coordinates[0][1]][coordinates[0][0]] = nil
  end
  
  def find_danger_zones (king, board)
    danger_zones = []
    row = 0
    while row < 8
      column = 0
      while column < 8
        position = board[row][column]
        unless position.nil?
          danger_zones = danger_zones.concat(position.danger_zones(board)).uniq if position.color != king.color
        end
        column += 1
      end
      row += 1
    end
    return danger_zones
  end
  
  def promotion? (board, coordinates)
    reached_square = [coordinates[1][1], coordinates[1][0]]
    moved_piece = board[reached_square[0]][reached_square[1]]
    p reached_square
    if moved_piece.class == Pawn
      board[reached_square[0]][reached_square[1]] = promote(moved_piece, reached_square) if moved_piece.promotion_zone.include?(reached_square)
    end
  end
  
  def promote (square, coordinates)
    puts "Promotion! Choose desired piece: 'R'ook, k'N'ight, 'B'ishop or 'Q'ueen?"
    selection = gets.chomp.downcase
    while selection !~ /^[rnbq]$/
      puts "Invalid input. R/N/B/Q:"
      selection = gets.chomp.downcase
    end
    case selection
    when 'r'
      square = Rook.new(square.color, coordinates)
    when 'n'
      square = Knight.new(square.color, coordinates)
    when 'b'
      square = Bishop.new(square.color, coordinates)
    when 'q'
      square = Queen.new(square.color, coordinates)
    end
    return square
  end
  
  def switch_players
    if @current_player == @player_1
      @current_player = @player_2
    else
      @current_player = @player_1
    end
    puts "#{@current_player.color.to_s.capitalize} player's turn."
  end
  
  def save_state
    File.open(@save_file, "w") do |file|
      save_state = YAML::dump(self)
      file.write(save_state)
    end
  end
  
  def load_game
    puts "Loading..."
    if File.exist?(@save_file)
      saved_state = File.open(@save_file, "r")
      game = saved_state.read
      YAML::load(game).begin_game
    else
      puts "No saved state found. Starting new game."
      self.begin_game
    end
  end
  
  def game_over (winner)
    puts "#{winner.color.to_s.capitalize} player has won!"
    return true
  end
end
