class Board
  attr_accessor :state
  
  def initialize
    @state = make_chessboard
    populate_chessboard
  end
  
  def draw_board (state)
    visual_board = "\n"
    i = 8
    state.each do |row|
      visual_row = " #{i}|"
      row.each do |contents|
        if contents.is_a?(Piece)
          visual_row << "#{contents.symbol}|"
        else
          visual_row << " |"
        end
      end
      visual_row << "\n"
      visual_board << visual_row.center(30)
      visual_board << draw_separator
      i -= 1
    end
    visual_board << draw_letters
    return visual_board
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
        populate_with_figures(index, row, :white)
      when 1
        populate_with_pawns(index, row, :white)
      when 6
        populate_with_pawns(index, row, :black)
      when 7
        populate_with_figures(index, row, :black)
      end
    end
  end
  
  def populate_with_pawns (row_number, row, color)
    i = 0
    while i < row.length
      piece = Pawn.new(color, [row_number, i])
      row[i] = piece
      i += 1
    end
  end
  
  def populate_with_figures (row_number, row, color)
    row[0] = Rook.new(color, [row_number, 0])
    row[1] = Knight.new(color, [row_number, 1])
    row[2] = Bishop.new(color, [row_number, 2])
    row[3] = Queen.new(color, [row_number, 3])
    row[4] = King.new(color, [row_number, 4])
    row[5] = Bishop.new(color, [row_number, 5])
    row[6] = Knight.new(color, [row_number, 6])
    row[7] = Rook.new(color, [row_number, 7])
  end
  
  def draw_separator
    "  " + "-" * 17 + "\n"
  end
  
  def draw_letters
    line = " " * 3
    ('A'..'H').to_a.each do |letter|
      line << "#{letter} "
    end
    line << "\n"
    return line.center(30)
  end
  
end
