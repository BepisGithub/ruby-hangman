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

  def get_guess
    puts 'Guess a letter: '
    letter_guess = ''
    letter_guess = gets.chomp.strip until (letter_guess.is_a? String) && (letter_guess.length == 1)
    letter_guess
  end

  def round(s_arr)
    guess = get_guess
    [s_arr.include?(guess), guess]
  end

  def game(s_word, f_guesses, won)
    puts s_word
    secret_word_array = s_word.downcase.strip.split('')
    your_guess = []
    your_guess.fill('_', 0, secret_word_array.length)
    while f_guesses < @max_failures && !won
      puts "#{your_guess} is your guess"
      puts "You have guessed incorrectly #{f_guesses} times. You can guess for a max of #{@max_failures} guesses"
      result = round(secret_word_array)
      puts "You have already guessed the letter #{result[1]}" if your_guess.include?(result[1])
      if result[0]
        secret_word_array.each_with_index do |char, idx|
          your_guess[idx] = char if char == result[1]
        end
      else
        f_guesses += 1
      end
      won = true if your_guess == secret_word_array
    end
    #after you won or lost
  end
  

end

a = Game.new
