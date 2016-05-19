class Board
  attr_accessor :state
  
  def initialize
    @state = make_chessboard
    populate_chessboard
  end
  
  private
  
  def make_chessboard
    initial_board = []
    r = 0
    c = 0
    while r < 8
      row = []
      while c < 8
        row << nil
        c += 1
      end
      initial_board << row
      c = 0
      r += 1
    end
    return initial_board
  end
  
  def populate_chessboard
    @state.each_with_index do |row, index|
      case index
      when 0
        populate_with_figures(row, :white)
      when 1
        populate_with_pawns(row, :white)
      when 6
        populate_with_pawns(row, :black)
      when 7
        populate_with_figures(row, :black)
      end
    end
  end
  
  def populate_with_pawns (row, color)
    i = 0
    while i < row.length
      piece = Pawn.new(color)
      row[i] = piece
      i += 1
    end
  end
  
  def populate_with_figures (row, color)
    row[0] = Rook.new(color)
    row[1] = Knight.new(color)
    row[2] = Bishop.new(color)
    row[3] = Queen.new(color)
    row[4] = King.new(color)
    row[5] = Bishop.new(color)
    row[6] = Knight.new(color)
    row[7] = Rook.new(color)
  end
  
end
