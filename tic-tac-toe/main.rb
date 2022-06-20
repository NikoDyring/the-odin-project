# frozen_string_literal: true

require_relative 'lib/board'
require_relative 'lib/player'
require_relative 'lib/game'
require_relative 'lib/display'

def start_game
  game = Game.new
  game.play
  repeat_game
end

def repeat_game
  puts "Would you like to challenge your foe again? Press 'y' for yes, or 'n' for no."
  input = gets.chomp.downcase
  if input == 'y'
    start_game
  else
    puts 'Thanks for playing!'
  end
end

start_game
