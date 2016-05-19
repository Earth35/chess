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
    
  end
  
end
