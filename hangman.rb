require "pry"
require "./db/setup"
require "./lib/all"
require 'json'

def player_wants_to_quit?
  puts "Do you want to keep playing (y/n)?"
  input = gets.chomp
  if input == "n"
    true
  else
    system "clear"
    false
  end
end

def game_over? board, attempts, username, word
  user_id = User.where(username: username).first.id.to_s
  user_record = Record.where(user_id: user_id).first
  if (board.include? "_") && (attempts > 0)
    false
  elsif attempts == 0
    puts "You ran out of attempts!"
    user_record.losses += 1
    user_record.save!

    if SavedGame.where(user_id: user_id, word: word, in_progress: true) != []
      saved = SavedGame.where(user_id: user_id, word: word, in_progress: true)
      saved.first.in_progress = false
      saved.first.save!
    end

    show_record username
    true
  else
    puts "You win!"
    user_record.wins += 1
    user_record.save!

    if SavedGame.where(user_id: user_id, word: word, in_progress: true) != []
      saved = SavedGame.where(user_id: user_id, word: word, in_progress: true)
      saved.first.in_progress = false
      saved.first.save!
    end

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
    tries -= 1
  end

  return tries
end

def get_username
  puts "What name do you want to go by?"
  username = gets.chomp
  system "clear"
  username
end

def show_record username
  user = User.where(username: username).first_or_create!
  user_record = Record.where(user_id: user.id.to_s).first_or_create!
  wins = user_record.wins
  losses = user_record.losses
  puts "#{username}'s record: #{wins} - wins and #{losses} - losses"
end

def quit_and_save? username, board, attempts, word
  puts "Do you want to quit and save (y/n)?"
  input = gets.chomp
  if input == "y"
    user_id = User.where(username: username).first.id.to_s
    if SavedGame.where(user_id: user_id, word: word, in_progress: true) != []
      update = SavedGame.where(user_id: user_id, word: word, in_progress: true)
      update.first.board = board.to_json
      update.first.attempts = attempts
      update.first.save!
    else
      SavedGame.create(user_id: user_id, board: board.to_json, attempts: attempts, in_progress: true, word: word)
    end
    exit
  end
end

def check_for_saved_game username
  user = User.where(username: username).first
  if SavedGame.where(user_id: user.id.to_s, in_progress: true) != []
    puts "You have a saved game, would you like to continue it?"
    input = gets.chomp
    if input == "y"
      user_game = SavedGame.where(user_id: user.id.to_s, in_progress: true).first
    else
      user_game = nil
    end
  else
    user_game = nil
  end
  user_game
end

system "clear"
puts "Welcome to Hangman!"
username = get_username
show_record username
user_game = check_for_saved_game username
loop do
  if user_game.nil?
    word = get_a_word
    warn "The word is: #{word}"
    b = ["_"] * word.length
    attempts = 6
  else
    word = user_game.word
    b = JSON.parse(user_game.board)
    attempts = user_game.attempts
  end

  # Play game one time
  until game_over? b, attempts, username, word
    display_board b
    letter = choose_letter
    system "clear"
    attempts = record_move letter, word, b, attempts
    display_board b
    puts "You have #{attempts} attemps left"
    quit_and_save? username, b, attempts, word
  end
  break if player_wants_to_quit?
end
