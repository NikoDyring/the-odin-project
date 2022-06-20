# frozen_string_literal: true

# All the UI strings for the application
module Display
  def intro
    "Welcome to the ultimate Tic-Tac-Toe game in the console! \n\n"
  end

  def name_prompt(number)
    "What is your name player #{number}?"
  end

  def character_prompt
    'What 1 character (or letter) would you like to represent you as your game marker?'
  end

  def check_for_duplicate(character)
    "It can not be '#{character}'"
  end

  def input_warning
    "\e[31m SORRY! That is an invalid answer. Please try again \e[0m"
  end

  def player_turn(name)
    "#{name}, please enter a number (1-9) that is available to place a marker at."
  end

  def winner(name)
    "GAME OVER! #{name} is the winner!"
  end

  def tie
    "It's a draw!"
  end
end
