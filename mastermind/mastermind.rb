class Mastermind
    COLORS = ['red', 'blue', 'green', 'yellow', 'orange', 'purple']
  
    def initialize
      @code = generate_secret_code
      @attempts = 0
      @max_attempts = 12
    end
  
    def play
      puts "Welcome to Mastermind!"
      puts "Try to guess the secret code in #{@max_attempts} attempts."
      puts "Available colors: #{COLORS.join(', ')}"
  
      until @attempts >= @max_attempts
        guess = get_player_guess
        if correct_guess?(guess)
          puts "Congratulations! You guessed the secret code."
          return
        else
          feedback = provide_feedback(guess)
          display_feedback(feedback)
          @attempts += 1
          puts "Attempts left: #{@max_attempts - @attempts}"
        end
      end
  
      puts "Game over! The secret code was #{@code.join(', ')}."
    end
  
    private
  
    def generate_secret_code
      Array.new(4) { COLORS.sample }
    end
  
    def get_player_guess
      puts "Enter your guess (4 colors):"
      gets.chomp.split(' ')
    end
  
    def correct_guess?(guess)
      guess == @code
    end
  
    def provide_feedback(guess)
      guess.zip(@code).map { |g, c| g == c ? 'Correct' : 'Incorrect' }
    end
  
    def display_feedback(feedback)
      puts feedback.join(' ')
    end
  end
  
  game = Mastermind.new
  game.play
  