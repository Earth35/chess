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
loop do
  p "Game start"
  print game.board.draw_board(game.board.state)
  game.move
  game.switch_players
end
