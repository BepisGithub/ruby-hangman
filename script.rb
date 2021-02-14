require 'json'

$dictionary = File.open('5desk.txt', 'r')

class Game
  attr_accessor :max_failures

  def initialize()
    @save_path = 'saves/save.JSON'
    @won = false
    @max_failures = 6
    saved_game = File.file?(@save_path)
    input = ''
    if saved_game
      puts 'Load game? (y/n)'
      input = gets.chomp.strip.downcase until (input.is_a? String) && (input.length == 1)
    end
    if saved_game && input == 'y'
      save_data = File.read(@save_path)
      save_data = JSON.parse(save_data)
      # The data in the text file is in a json format
      # Take the data, convert it from a json into usable values
      # Join the s_arr into the secret word
      word = save_data['s_arr'].join('')
      # Assign the false guesses value the one in the saved data
      game(word, save_data['f_guesses'], @won, save_data['y_guess'], save_data['w_chars'])
    else
      @secret_word = File.readlines($dictionary).sample
      while @secret_word.length < 5 || @secret_word.length > 12
        @secret_word = File.readlines($dictionary).sample
      end
      @false_guesses = 0
      game(@secret_word, @false_guesses, @won)
    end
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
      save_data = JSON.generate({'s_arr': s_arr, 'f_guesses': f_guesses, 'w_chars': w_chars, 'y_guess': y_guess})
      File.open(@save_path, 'w') {} # overwrite the file
      File.write(@save_path, save_data)
    end
  end

  def game(s_word, f_guesses, won, y_guess = [], w_chars = [])
    secret_word_array = s_word.downcase.strip.split('')
    your_guess = y_guess
    your_guess.fill('_', 0, secret_word_array.length)
    wrong_chars = w_chars
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
