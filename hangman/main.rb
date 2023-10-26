class Hangman
  attr_accessor :secret_word, :guesses, :correct_letters, :wrong_letters, :status

  def initialize(secret_word)
    @secret_word = secret_word
    @guesses = 0
    @correct_letters = Set.new
    @wrong_letters = Set.new
    @status = :ongoing
  end

  def guess(letter)
    if @correct_letters.include?(letter) || @wrong_letters.include?(letter)
      puts "You have already guessed that letter."
      return
    end
    if @secret_word.include?(letter)
      @correct_letters << letter
    else
      @wrong_letters << letter
      @guesses += 1
    end

    if @guesses >= 6
      @status = :lost
    elsif @secret_word.chars.all? { |char| @correct_letters.include?(char) }
      @status = :won
    end
  end

  def get_user_input(prompt)
    puts prompt
    gets.chomp
  end

  def display_message(message)
    puts message
  end

  def display
    revealed_word = @secret_word.chars.map { |char| @correct_letters.include?(char) ? char : '_' }.join(' ')
    puts "Word: #{revealed_word}"
    puts "Wrong guesses: #{@wrong_letters.join(', ')}"
    puts "Remaining guesses: #{6 - @guesses}"
  end

  def self.load_game(filename)
    data = File.read(filename)
    Marshal.load(data)
  end

  def save_game(filename)
    data = Marshal.dump(self)
    File.write(filename, data)
  end

  def play_game
    input = get_user_input("Enter 'load' to load a game, or anything else to start a new game.")
    if input == 'load'
      puts "Enter the filename to load from."
      filename = gets.chomp
      game = Hangman.load_game(filename)
    else
      secret_word = generate_secret_word
      game = Hangman.new(secret_word)
    end

    while game.status == :ongoing
      game.display
      puts "Enter a letter to guess, 'save' to save the game, or 'exit' to exit the game."
      input = gets.chomp
      case input
      when 'save'
        puts "Enter a filename to save to."
        filename = gets.chomp
        game.save_game(filename)
      when 'exit'
        break
      else
        game.guess(input)
      end
    end

    if game.status == :won
      puts "Congratulations, you won!"
    elsif game.status == :lost
      puts "Sorry, you lost. The word was '#{game.secret_word}'."
    end
  end
end

def generate_secret_word
  words = File.readlines('google-10000-no-swears.txt').map(&:chomp)
  suitable_words = []
  words.each do |word|
    suitable_words << word if word.length >= 5 && word.length <= 12
  end
  suitable_words[rand(suitable_words.length)]
end

hangman = Hangman.new(generate_secret_word)
hangman.play_game
