# Runs one round of the game
class Game
  @@old_code_breaker = nil
  def initialize(player1, player2)
    # ASK WHO WOULD LIKE TO BE THE CODE BREAKER, USE @@VARIABLE TO REMEMBER BETWEEN CALLING CLASS GAME
    # could probably move all these case statements to their own method, call method decide_code_breaker
    case @@old_code_breaker
    when nil
      puts "Who wants to be the codebreaker? Please enter your name"
      code_breaker_name = gets.chomp.capitalize
      case code_breaker_name
      when player1.name
        @code_breaker = player1
        @@old_code_breaker = player1
      when player2.name
        @code_breaker = player2
        @@old_code_breaker = player2
      end
    when player1
      @code_breaker = player2
      @@old_code_breaker = player2
    when player2
      @code_breaker = player1
      @@old_code_breaker = player1
    end
    case @code_breaker
    when player1
      @code_maker = player2
    when player2
      @code_maker = player1
    end
    #@code_breaker = player1
    #@code_maker = player2
    @secret_code = []
    @total_points = 0
  end

  def start_game
    winner = false
    current_round = 0
    max_round = 12
    total_guesses = []
    total_check_guess_output = []

    puts "\nWelcome to the game! The codemaker is #{@code_maker.name} and the codebreaker is #{@code_breaker.name}!"
    puts "\n#{@code_breaker.name} look away! #{@code_maker.name} please input your secret code!"
    input_dialog
    # determines if program needs to set secret code automatically (i.e. codemaker is a computer)
    if @code_maker.class == ComputerPlayer
      @secret_code = sanitized_input(" ")
    else
      @secret_code = sanitized_input(gets.chomp)
    end

    while current_round < max_round && winner == false
      puts "\nTHIS IS ROUND #{current_round + 1}"
      puts "\n#{@code_breaker.name} Please Enter Your Guess"
      input_dialog
      # determines if program needs to make random guess (i.e. codebreaker is a computer)
      if @code_breaker.class == ComputerPlayer
        guess = sanitized_input(" ") # sanitized_input(@code_breaker.generate_computer_guess())
      else
        guess = sanitized_input(gets.chomp)
      end  
      total_guesses << guess
      total_check_guess_output << check_guess(guess, @secret_code)
      puts "\n" * 50
      printer(total_guesses, total_check_guess_output)

      # checks for winner
      winner = true if total_check_guess_output.include?([true, true, true, true])
      current_round += 1
    end
    @code_maker.points += current_round
    @code_maker.points += 1 if winner == false
    puts "\nThat it for this game, the codemaker #{@code_maker.name} has #{@code_maker.points}"
  end

  def sanitized_input(input)
    options = %w[Red Purple Blue Green Yellow Orange]
    return_array = []
    input_arr = input.split(" ")[0, 4]
    input_arr << nil while input_arr.length < 4
    input_arr.each do |item|
      if options.include?(item.to_s.capitalize)
        return_array << item.capitalize
      else
        puts "One of your inputs was not recognized, so we randomly chose for you"
        return_array << options.sample
      end
    end
    p return_array
  end

  def input_dialog
    puts "\nYour options are Red, Purple, Blue, Green, Yellow, Orange"
    puts "Only pick 4, seperate with spaces"
  end

  def check_guess(guess_array, answer_array)
    # take the secret code and the guess code.  See if first digit of guess code is anywhere in secret code, if it is, status = nil (color is correct, location is not)
    # if the color is correct, check to see if its position is correct, if colors and position are correct, status = true
    status = []
    guess_array.each_index do |index|
      if answer_array.include?(guess_array[index])
        if answer_array[index] == guess_array[index]
          status << true
        else
          status << nil
        end
      else
        status << false
      end
    end
    status.shuffle
  end

  # WE NEED A REAL PRINT FUNCTION FOR THE CURRENT BOARD AND THE ALL THE GUESS_CHECK_OUTPUTS
  def printer(array_of_guesses, array_of_checker_outputs)
    puts 'Round             Your Guesses              Response'
    array_of_guesses.each_index do |i|
      puts "ROUND #{i + 1}        #{array_of_guesses[i]}          #{array_of_checker_outputs[i]}"
    end
  end
end

# Creates a human player
class Player
  attr_reader :name
  attr_accessor :points

  def initialize()
    @points = 0
    puts "Welcome to Mastermind, what is your name?"
    @name = gets.chomp.capitalize
  end
end

# Creates a computer player
class ComputerPlayer
  attr_reader :name
  attr_accessor :points

  @@id = 1
  def initialize
    @used_guesses = []
    @points = 0
    @name = "Computer#{@@id}"
    @@id += 1
  end

  def generate_computer_guess(array_of_guesses, array_of_checker_outputs)
    # should output a string of 4 colors, seperated by spaces
    # should probably take total_guesses and total_check_guess_output as inputs, and use that info to determine if guess is "good"
    # guess is bad if...
    #    - guess already exists in total_guesses (trying the same guess twice is pointless)
    #    - 
    # if guess passes all tests, return guess to sanitized_input functions or just have this function return a correctly formatted array
    #if
      # reasign guess
    #else
      # return guess
    #end
  end
end

def play()
  puts "How many computer players would you like to have? (Integer betweeen 0 and 2)"
  number_of_computers = gets.chomp.to_i
  # could make this its own method that takes number_of_computers as input
  case number_of_computers
  when 2
    p1 = ComputerPlayer.new
    p2 = ComputerPlayer.new
  when 1
    p1 = Player.new
    p2 = ComputerPlayer.new
  when 0
    p1 = Player.new
    p2 = Player.new
  end
  puts 'How many games would you like to play? (Even Number)'
  max_number_of_games = gets.chomp.to_i
  current_number_of_games = 0
  while current_number_of_games < max_number_of_games
    if current_number_of_games.even?
      new_game = Game.new(p1, p2)
    else
      new_game = Game.new(p2, p1)
    end
    new_game.start_game
    current_number_of_games += 1
  end

  puts "\nYou have played all #{max_number_of_games} games"
  puts "\n#{p1.name} has #{p1.points} points"
  puts "\n#{p2.name} has #{p2.points} points"

  if p1.points > p2.points
    puts "\nCongrats #{p1.name}, you're the winner\n\n"
  elsif p1.points < p2.points
    puts "\nCongrats #{p2.name}, you're the winner and p1 sucks\n\n"
  else
    puts "\nIT WAS A TIE, BOTH OF YOU ARE SUCKERS"
  end
end

play

# fix capitalizition and grammer of dialog options
# make code_breaker guesses more efficient for Class ComputerPlayer