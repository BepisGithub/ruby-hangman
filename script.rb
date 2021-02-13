$dictionary = File.open('5desk.txt', 'r')

class Game
  

  
  def initialize(save_game = false)
    # check for save game later, if true load it and set the parameters. else use default values.
    @secret_word = File.readlines($dictionary).sample
    @false_guesses = 0
    @guessed = false
    game(@secret_word, @false_guesses, @guessed)
  end

  def round(word, f_guesses, guessed)
    
  end

  def game(word, f_guesses, guessed)
    secret_array = word.split('')
    while f_guesses < 6 && !guessed
      guessed = round(word, f_guesses, guessed)
    end
  end
  

end

a = Game.new
