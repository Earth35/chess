class Pawn < Piece
  attr_reader :symbol, :attack_vectors
  attr_accessor :first_move
  def initialize (color, position)
    super(color, position)
    @symbol = Piece.set_symbol(color, "P", "p")
    @first_move = true
    @attack_vectors = @color == :white ? [[-1, 1], [1, 1]] : [[-1, -1], [1, -1]]
  end
  
  def movement_valid? (board, coordinates)
    # possible vectors: [0,1] (movement), [0,2] (first move and clear path), [-1,1], [1,1] (atk)
    myself = board[coordinates[0][1]][coordinates[0][0]]  # initial position, selected pawn
    vector = [coordinates[1][0] - coordinates[0][0], coordinates[1][1] - coordinates[0][1]] # desired movement vector
    if myself.color == :white
      result = pawn_movement([[0,1], [0,2], [-1,1], [1,1]], myself, vector, board, coordinates) # check for white pawns
    else
      result = pawn_movement([[0,-1], [0,-2], [1,-1], [-1, -1]], myself, vector, board, coordinates) # check for black pawns
    end
    
  end
  
  def danger_zones (board)
    danger_zones = []
    @attack_vectors.each do |vector|
      new_row = @position[0] + vector[1]
      new_col = @position[1] + vector[0]
      if (0..7).include?(new_row) && (0..7).include?(new_col)
        potential_pos = [new_row, new_col]
        potential_danger_zone = board[potential_pos[0]][potential_pos[1]]
        if potential_danger_zone.nil?
          danger_zones << potential_pos
        elsif potential_danger_zone.color != @color
          danger_zones << potential_pos
        end
      end
    end
    return danger_zones
  end
  
  private
  
  def pawn_movement (movement_vectors, myself, vector, board, coordinates)
    case vector
    when movement_vectors[0]
      if board[coordinates[1][1]][coordinates[1][0]].nil?
        myself.first_move = false
        return true
      else
        return false  # target position must be empty
      end
    when movement_vectors[1]
      if board[coordinates[0][1] + movement_vectors[0][1]][coordinates[0][0]].nil? && board[coordinates[1][1]][coordinates[1][0]].nil? && myself.first_move
        myself.first_move = false
        return true
      else
        return false # both target position and square before it must be empty; must be first move
      end
    when movement_vectors[2]
      target = board[coordinates[0][1] + movement_vectors[2][1]][coordinates[0][0] + movement_vectors[2][0]] # reverse order - coordinates = [column, row]
      if target.nil?
        return false # diagonal movement not allowed
      elsif target.color == myself.color
        return false # diagonal position taken by player's piece
      else
        myself.first_move = false
        return true # attacking diagonal position taken by opponent's piece
      end
    when movement_vectors[3]
      # as above
      target = board[coordinates[0][1] + movement_vectors[3][1]][coordinates[0][0] + movement_vectors[3][0]]
      if target.nil?
        return false
      elsif target.color == myself.color
        return false
      else
        myself.first_move = false
        return true
      end
    else
      return false
    end
  end
end
