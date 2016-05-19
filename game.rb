require_relative './lib/chess'
require_relative './lib/board'
require_relative './lib/player'
require_relative './lib/piece'
require_relative './lib/pawn'
require_relative './lib/rook'
require_relative './lib/knight'
require_relative './lib/bishop'
require_relative './lib/queen'
require_relative './lib/king'
require 'yaml'

game = Chess.new
game.board.state.each do |row|
p row
end