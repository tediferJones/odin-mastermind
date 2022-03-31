# frozen_string_literal: true

class Game
  @@old_code_breaker = nil
  def initialize(player1, player2)
    @secret_code = []
    @total_points = 0
    code_breaker_picker(player1, player2)
    case @code_breaker
    when player1
      @code_maker = player2
    when player2
      @code_maker = player1
    end
    # if the computer is a code_breaker, this gives them a list of their options
    if @code_breaker.instance_of?(ComputerPlayer)
      @all_possibilities = %w[Red Purple Blue Green Yellow Orange].repeated_permutation(4).to_a
    end
  end

  # Runs one round of the game
  def start_game
    winner = false
    @current_round = 0
    max_round = 12
    total_guesses = []
    @total_check_guess_output = []

    puts "\nThe codemaker is #{@code_maker.name} and the codebreaker is #{@code_breaker.name}!"
    puts "\n#{@code_breaker.name} look away! #{@code_maker.name} please input your secret code!"
    input_dialog
    set_player(@code_maker, @secret_code)

    while @current_round < max_round && winner == false
      puts "\nTHIS IS ROUND #{@current_round + 1}"
      puts "\n#{@code_breaker.name} Please Enter Your Guess"
      input_dialog
      guess = set_player(@code_breaker)

      total_guesses << guess
      @total_check_guess_output << check_guess(guess)
      puts "\n" * 100 
      printer(total_guesses, @total_check_guess_output)

      # checks for winner
      winner = true if @total_check_guess_output.include?([true, true, true, true])
      @current_round += 1
    end
    @code_maker.points += @current_round
    @code_maker.points += 1 if winner == false
    puts "\nThat it for this game, the codemaker #{@code_maker.name} has #{@code_maker.points}"
  end

  def code_breaker_picker(player1, player2)
    # puts player1
    # puts player2
    case @@old_code_breaker
    when nil
      puts 'Who wants to be the codebreaker? Please enter your name'
      puts "Your options are #{player1.name} or #{player2.name}, if your response isnt recognized, we'll randomly choose for you"
      if player1.instance_of?(ComputerPlayer) && player2.instance_of?(ComputerPlayer)
        @code_breaker = [player1, player2].sample
      else
        code_breaker_name = gets.chomp.capitalize
        case code_breaker_name
        when player1.name
          @code_breaker = player1
        when player2.name
          @code_breaker = player2
        when ""
          @code_breaker = [player1, player2].sample
        end
      end
    when player1
      @code_breaker = player2
    when player2
      @code_breaker = player1
    end
    @@old_code_breaker = @code_breaker
  end

  def set_player(player, thing_to_set = 'guess')
    if thing_to_set == @secret_code
      @secret_code = if player.instance_of?(ComputerPlayer)
                       sanitized_input(' ')
                     else
                       sanitized_input(gets.chomp)
                     end
                     puts "\n"*100
    elsif player.instance_of?(ComputerPlayer)
      generate_computer_guess(@total_check_guess_output)
    else
      sanitized_input(gets.chomp)
    end
  end

  def check_guess(guess_array)
    # take the guess code, check if first digit of guess code is anywhere in secret code, if it is, status = nil (color is correct, location is not)
    # if the color is correct, check to see if its position is correct, if colors and position are correct, status = true
    answer_array = @secret_code
    status = []
    guess_array.each_index do |index|
      status << if answer_array.include?(guess_array[index])
                  true if answer_array[index] == guess_array[index]
                else
                  false
                end
    end
    status.shuffle
  end

  def sanitized_input(input)
    options = %w[Red Purple Blue Green Yellow Orange]
    return_array = []
    input_arr = input.split(' ')[0, 4]
    input_arr << nil while input_arr.length < 4
    input_arr.each do |item|
      if options.include?(item.to_s.capitalize)
        return_array << item.capitalize
      else
        puts 'One of your inputs was not recognized, so we randomly chose for you'
        return_array << options.sample
      end
    end
    return_array
  end

  def input_dialog
    puts "\nYour options are Red, Purple, Blue, Green, Yellow, Orange"
    puts 'Only pick 4, seperate with spaces'
  end

  def printer(array_of_guesses, array_of_checker_outputs)
    puts '                         Your Guesses                           Response'
    array_of_guesses.each_index do |i|
      puts "ROUND #{i + 1}        #{array_of_guesses[i]}          #{array_of_checker_outputs[i]}"
    end
  end

  def generate_computer_guess(array_of_checker_outputs)
    if @current_round.zero?
      %w[Red Red Red Red] # Purple Purple]
    else
      # Removes all arrays that are less truthy than current guess
      latest_response = array_of_checker_outputs[-1]
      @all_possibilities.select! do |possibility|
        possibility_check_result = check_guess(possibility)
        score_guess(possibility_check_result) > score_guess(latest_response)
      end
      @all_possibilities.sample
    end
  end

  # should be able to tune strength of the AI by changing score values
  def score_guess(array)
    score = 0
    array.each do |item|
      if item == true
        score += 2
      elsif item.nil?
        score += 1
      end
    end
    score
  end
end

# Creates a human player
class Player
  attr_reader :name
  attr_accessor :points

  @@id = 0
  def initialize
    @points = 0
    puts 'Welcome to Mastermind, what is your name?'
    temp = gets.chomp.capitalize
    if temp == ''
      @name = "HumanPlayer#{@@id + 1}"
      @@id += 1
    else
      @name = temp
    end
  end
end

# Creates a computer player
class ComputerPlayer
  attr_reader :name
  attr_accessor :points

  @@id = 1
  def initialize
    @points = 0
    @name = "Computer#{@@id}"
    @@id += 1
  end
end

def play
  puts 'How many computer players would you like to have? (Integer betweeen 0 and 2)'
  number_of_computers = gets.chomp.to_i
  case number_of_computers
  when 2
    p1 = ComputerPlayer.new
    p2 = ComputerPlayer.new
  when 1
    p1 = Player.new
    p2 = ComputerPlayer.new
  when 0 || ""
    p1 = Player.new
    p2 = Player.new
  end
  puts 'How many games would you like to play? (Even Number)'
  max_number_of_games = gets.chomp.to_i
  current_number_of_games = 0
  while current_number_of_games < max_number_of_games
    new_game = if current_number_of_games.even?
                 Game.new(p1, p2)
               else
                 Game.new(p2, p1)
               end
    new_game.start_game

    current_number_of_games += 1
    puts "\nYou have #{max_number_of_games - current_number_of_games} game(s) left!"
  end

  puts "\nYou have played all #{max_number_of_games} games"
  puts "\n#{p1.name} has #{p1.points} points"
  puts "\n#{p2.name} has #{p2.points} points"

  if p1.points > p2.points
    puts "\nCongrats #{p1.name}, you're the winner\n\n"
  elsif p1.points < p2.points
    puts "\nCongrats #{p2.name}, you're the winner\n\n"
  else
    puts "\nIT WAS A TIE, BOTH OF YOU ARE SUCKERS"
  end
end

play
