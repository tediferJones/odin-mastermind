# use numbers instead of colors for code configuration
# example secret code [1, 2, 3, 4]
# 6 optional colors

# each game should consist of 2 rounds so each player gets to play as the codebreaker and code maker
class Game
  def initialize(code_breaker, code_maker)
    @code_breaker = code_breaker
    @code_maker = code_maker
    @secret_code = [1, 2, 3, 4] # try gets.chomp.to_a? later
    @total_points = 0
  end

  def start_game
    # this would be a good place to let the codemaker set the secret code
    # DONT ALLOW DUPLICATES IN SECRET CODE
    puts "\nwelcome to the game, the codemaker is #{@code_maker.name} and the codebreaker is #{@code_breaker.name}"
    winner = false
    current_round = 0
    max_round = 12
    total_check_guess_output = []
    while current_round < max_round && winner == false
      puts "\nTHIS IS ROUND #{current_round + 1}"
      puts "\nenter your guess"
      guess = santized(gets.chomp)
      total_check_guess_output << check_guess(guess, @secret_code)
      p total_check_guess_output # make a nicer print statement

      # checks for winner
      winner = true if total_check_guess_output.include?([true, true, true, true])
      # p winner
      current_round += 1
      # puts "THATS ROUND #{current_round}"
    end
    @code_maker.points += current_round
    @code_maker.points += 1 if winner == false

    puts "\nThat it for this game, the codemaker #{@code_maker.name} has #{@code_maker.points}"
    
  end

  def santized(input)
    input.split(" ").map { |item| item.to_i }
  end

  def check_guess(guess_array, answer_array)
    # initial value of status should be false
    # take the secret code and the guess code.  See if first digit of guess code is anywhere in secret code, if it is, status = nil (color is correct, location is not)
    # if the color is correct, check to see if its position is correct, if colors and position are correct, status = true
    # at the end of each iteration, append status to return_array
    # last, randomize the series of values in return_array
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
end

class Player
  attr_reader :name
  attr_accessor :points

  def initialize()
    @points = 0
    puts "Welcome to Mastermind, what is your name?"
    @name = gets.chomp.capitalize
  end
end

def play()
  p1 = Player.new
  p2 = Player.new
  # new_game = Game.new
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
    # new_game.code_maker.points += new_game.total_points
    current_number_of_games += 1
  end

  puts "\nYou have played all #{max_number_of_games} games"

  if p1.points > p2.points
    puts "\nCongrats #{p1.name}, you're the winner"
  elsif p1.points < p2.points
    puts "\nCongrats #{p2.name}, you're the winner and p1 sucks\n\n"
  end
end

play()

# game = Game.new


# puts p1.points = 10