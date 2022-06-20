# frozen_string_literal: true

# Player model
class Player
  attr_reader :name, :character

  def initialize(name, character)
    @name = name
    @character = character
  end
end
