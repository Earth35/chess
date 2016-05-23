class Chess
  attr_reader :player_1, :player_2
  attr_accessor :board, :current_player
  
  def initialize
    @player_1 = Player.new(:white)
    @player_2 = Player.new(:black)
    @board = Board.new
    @player_1.king = @board.state[0][4]
    @player_2.king = @board.state[7][4]
    @current_player = @player_1
  end
  
  ###########
  #TEMPORARY#
  ###########
  def switch_players
    if @current_player == @player_1
      @current_player = @player_2
    else
      @current_player = @player_1
    end
    puts "Switched players."
  end
  ###########
  #TEMPORARY#
  ###########
  
  def move
    move_valid = false
    while !move_valid
      puts "Make a move or type 'save' to save the game:"
      user_input = gets.chomp.downcase # e.g. a0, a1
      if user_input == 'save'
        save_state # under construction!
        puts "Please make a move:"
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
        danger_zones = find_danger_zones(@current_player.king, @board.state, coordinates)
        p danger_zones
        move_valid = danger_zones.include?(king_position) ? false : true
        if !move_valid
          puts "Invalid move, your King would be at risk"
          move_selected_piece(@board.state, coordinates.reverse)
        end
      end
    end
  end
  
  private
  
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
  
  def find_danger_zones (king, board, coordinates)
    danger_zones = []
    row = 0
    while row < 8
      column = 0
      while column < 8
        position = board[row][column]
        unless position.nil?
          p "Current position: #{row}, #{column} (#{position})"
          danger_zones = danger_zones.concat(position.danger_zones(board)).uniq if position.color != king.color
        end
        column += 1
      end
      row += 1
    end
    return danger_zones
  end
  
  def save_state
    # to be done
  end
  
end
