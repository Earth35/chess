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
game.start
