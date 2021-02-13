$dictionary = File.open('5desk.txt', 'r')

class Game
  
  attr_accessor :max_failures

  
  def initialize(save_game = false)
    # check for save game later, if true load it and set the parameters. else use default values.
    @secret_word = File.readlines($dictionary).sample
    @false_guesses = 0
    @won = false
    @max_failures = 6
    game(@secret_word, @false_guesses, @won)
  end



  def round(s_word, f_guesses, won)
    
  end

  def game(s_word, f_guesses, won)
    secret_word_array = s_word.split('')
    your_guess = []
    your_guess.fill('_', 0, secret_word_array.length)
    while f_guesses < @max_failures && !won
      puts "#{your_guess} is your guess"
      puts "You have guessed incorrectly #{f_guesses} times. You can guess for a max of #{@max_failures} guesses"
      won = round(s_word, f_guesses, won)
    end
  end
  

end

a = Game.new
