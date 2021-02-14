require 'json'

$dictionary = File.open('5desk.txt', 'r')

class Game
  attr_accessor :max_failures

  def initialize(save_game = false)
    #TODO: Ask the user if they want to load a save game
    @secret_word = File.readlines($dictionary).sample
    while @secret_word.length < 5 || @secret_word.length > 12
      @secret_word = File.readlines($dictionary).sample
    end
    @false_guesses = 0
    @won = false
    @max_failures = 6
    @save_path = 'saves/save.txt'
    game(@secret_word, @false_guesses, @won)
  end

  def get_guess
    puts 'Guess a letter: '
    letter_guess = ''
    letter_guess = gets.chomp.strip.downcase until (letter_guess.is_a? String) && (letter_guess.length == 1)
    letter_guess
  end

  def round(s_arr)
    guess = get_guess
    [s_arr.include?(guess), guess]
  end

  def save_game_prompt(s_arr, f_guesses, w_chars, y_guess)
    puts 'Save game? (y/n)'
    input = gets.chomp.strip.downcase until (input.is_a? String) && (input.length == 1)
    if input == 'y'
      save_data = {:s_arr => s_arr, :f_guesses => f_guesses, :w_chars => w_chars, :y_guess => y_guess}.to_json
      existance_of_save = File.file?(@save_path)
      if existance_of_save
        File.open(@save_path, 'w') {} # overwrite the file
        File.write(@save_path, save_data)
      else
        # create file then save data
      end
    end
  end

  def game(s_word, f_guesses, won)
    secret_word_array = s_word.downcase.strip.split('')
    your_guess = []
    your_guess.fill('_', 0, secret_word_array.length)
    wrong_chars = []
    while f_guesses < @max_failures && !won
      save_game_prompt(secret_word_array, f_guesses, wrong_chars, your_guess)
      puts "#{your_guess} is your guess"
      puts "You have guessed incorrectly #{f_guesses} times. You can guess for a max of #{@max_failures} guesses"
      puts "The letters you have guessed incorrectly so far are #{wrong_chars}" unless wrong_chars.empty?
      result = round(secret_word_array)
      puts "You have already guessed the letter #{result[1]}" if your_guess.include?(result[1]) || wrong_chars.include?(result[1])
      if result[0]
        secret_word_array.each_with_index do |char, idx|
          your_guess[idx] = char if char == result[1]
        end
      else
        f_guesses += 1 unless wrong_chars.include?(result[1])
        wrong_chars.push(result[1])
      end
      wrong_chars.uniq!
      won = true if your_guess == secret_word_array
    end
    puts "The secret word was #{s_word}"
    puts 'You lost' unless won
    puts 'You won' if won
  end
end

a = Game.new
