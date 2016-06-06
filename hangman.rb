require "pry"
require "./db/setup"
require "./lib/all"

def player_wants_to_quit?
  puts "Do you want to keep playing (y/n)?"
  input = gets.chomp
  # input == "n"
  if input == "n"
    true
  else
    false
  end
end

def game_over? board
  # !board.include?("_")
  if board.include? "_"
    false
  else
    true
  end
end

def get_a_word
  [
    "aardwolf",
    "banana",
    "rails",
    "fizzbuzz"
  ].sample
end

def display_board board
  puts "The board is: #{board.join(' ')}"
end

def choose_letter
  print "Your move > "
  input = gets.chomp
end

def record_move l, answer, grid, tries
  letters = answer.split ""
  i = 0
  letters.each do |c|
    if l == c
      grid[i] = c
    end
    i += 1
  end

  unless answer.include? l
    # tries -= 1
    tries = tries - 1
  end

  return tries
end

loop do
  word = get_a_word
  warn "The word is: #{word}"
  b = ["_"] * word.length
  attempts = 6

  # Play game one time
  until game_over? b
    display_board b
    letter = choose_letter
    attempts = record_move letter, word, b, attempts
    puts "You have #{attempts} attemps left"
  end
  break if player_wants_to_quit?
end
