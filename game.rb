require './lib/chess'
require './lib/board'
require './lib/player'
require './lib/piece'
require './lib/pawn'
require './lib/rook'
require './lib/knight'
require './lib/bishop'
require './lib/queen'
require './lib/king'
require 'yaml'

game = Chess.new

# game.board.state.each do |row|
  # p row
# end
board = game.board
visualization = board.draw_board(board.state)
puts visualization
game.move