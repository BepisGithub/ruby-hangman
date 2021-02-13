dictionary = File.open('5desk.txt', 'r')

class Game
  
  def round

  end
  
  def initialize(save_game = false)
    # check for save game later, if true load it and set the parameters. else use default values.
    secret_word = File.readlines(dictionary).sample
    false_guesses = 0
    guessed = false
    while false_guesses < 6 || !(guessed)
      round
    end
  end
  

end