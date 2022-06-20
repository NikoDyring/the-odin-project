# frozen_string_literal: true

require_relative 'display'

# The game logic
class Game
  include Display
  attr_reader :player_one, :player_two, :board, :current_player

  def initialize
    @board = Board.new
    @player_one = nil
    @player_two = nil
    @current_player = nil
  end

  def play
    set_up
    board.show
    player_turns
    conclusion
  end

  def create_player(number, duplicate_character = nil)
    puts name_prompt(number)
    name = gets.chomp
    character = character_input(duplicate_character)
    Player.new(name, character)
  end

  def turn(player)
    cell = turn_input(player)
    board.update(cell -  1, player.character)
    board.show
  end

  private

  def set_up
    puts intro
    @player_one = create_player(1)
    @player_two = create_player(2, player_one.character)
  end

  def character_input(duplicate)
    player_character_prompts(duplicate)
    input = gets.chomp
    return input if input.match?(/^[^0-9]$/) && input != duplicate

    puts input_warning
    character_input(duplicate)
  end

  def player_character_prompts(duplicate)
    puts character_prompt
    puts check_for_duplicate(duplicate) if duplicate
  end

  def player_turns
    @current_player = player_one
    until board.full?
      turn(current_player)
      break if board.game_over?

      @current_player = switch_current_player
    end
  end

  def turn_input(player)
    puts player_turn(player.name)
    number = gets.chomp.to_i
    return number if board.valid_move?(number)

    puts input_warning
    turn_input(player)
  end

  def switch_current_player
    if current_player == player_one
      player_two
    else
      player_one
    end
  end

  def conclusion
    if board.game_over?
      puts winner(current_player.name)
    else
      puts tie
    end
  end
end
