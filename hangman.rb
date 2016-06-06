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

def game_over? board, attempts, username
  user_id = User.where(username: username).ids.first.to_s
  if (board.include? "_") && (attempts > 0)
    false
  elsif attempts == 0
    puts "You ran out of attempts!"
    loss = Record.where(user_id: user_id).first_or_create!
    loss.losses += 1
    loss.save!
    show_record username
    true
  else
    puts "You win!"
    win = Record.where(user_id: user_id).first_or_create!
    win.wins += 1
    win.save!
    show_record username
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

def get_username
  puts "What name do you want to go by?"
  username = gets.chomp
end

def show_record username
  user = User.where(username: username).first_or_create!
  wins = Record.where(user_id: user.id.to_s).first_or_create!.wins
  losses = Record.where(user_id: user.id.to_s).first_or_create!.losses
  puts "#{username}'s record: #{wins} - wins and #{losses} - losses"
end

puts "Welcome to Hangman!"
username = get_username
show_record username
loop do
  word = get_a_word
  warn "The word is: #{word}"
  b = ["_"] * word.length
  attempts = 6

  # Play game one time
  until game_over? b, attempts, username
    display_board b
    letter = choose_letter
    attempts = record_move letter, word, b, attempts
    puts "You have #{attempts} attemps left"
  end
  break if player_wants_to_quit?
end
