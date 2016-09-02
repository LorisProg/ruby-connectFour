require './lib/board'
require './lib/player'


class Game

	attr_accessor :player1, :player2

	def initialize
		@board = nil
		@name_input = /^[a-z]+$/i
		@play_input = /^[1-7]$/
		@disc_input = /^(black|white)$/
		@yes_no_input = /^(yes|no|y|n)$/
		@disc_color_taken = nil
		@player1 = nil
		@player2 = nil
	end

	def user_input(regexp, error_msg, input = gets.chomp)
		until regexp.match(input)
				puts error_msg
				input = gets.chomp
		end
		input
	end

	def logo
		puts " -------------------------------"
		puts "|                               |"
		puts "|           CONNECT 4           |"
		puts "|                               |"
		puts " -------------------------------"
			puts ""
	end

	def create_player(id)
		name = get_player_name(id)
		disc_color = get_player_disc_color
		Player.new(name, @board, disc_color)
	end

	def get_player_name(id)
		puts "Player #{id} enter your name :"
		name = user_input(@name_input, 'Your name must be one word composed only of letters.')
		name
	end

	def get_player_disc_color
		if !@disc_color_taken
			puts "What disc color do you prefer ? (black or white)"
			disc_color = user_input(@disc_input, 'Please select black or white only.')
			@disc_color_taken = disc_color
		else
			if @disc_color_taken == 'white'
				disc_color = 'black'
			else
				disc_color = 'white'
			end
		end
		disc_color
	end

	def player_move
		system('clear')
		print @board.draw_grid(@board.current_grid)

		if @board.last_move.nil? || @board.last_move[2] == 2
			puts "#{@player1.name}, what column do you want to play next ?"
			until @board.next_empty_row(column = user_input(@play_input, "Enter a digit between 1 and 7").to_i - 1) != nil
				puts "This column is full please choose another one"
				column = user_input(@play_input, "Enter a digit between 1 and 7").to_i - 1
			end
			@board.update_grid(column, 1)
		else
			puts "#{@player2.name}, what column do you want to play next ?"
			until @board.next_empty_row(column = user_input(@play_input, "Enter a digit between 1 and 7").to_i - 1) != nil
				puts "This column is full please choose another one"
				column = user_input(@play_input, "Enter a digit between 1 and 7").to_i - 1
			end
			@board.update_grid(column, 2)
		end
	end

	def start_game
		system('clear')
		logo
		@board = Board.new
		set_players
		until @board.winner? || @board.draw?
			player_move
		end
		game_end
		replay?
	end

	def set_players
		if @player1 && @player2
			puts "Would you like to keep the same player ?"
			answer = user_input(@yes_no_input, 'Please answer with yes or no')
			if answer == 'yes' || answer == 'y'
				@board.player_1 = @player1
				@board.player_2 = @player2
				return nil
			else
				@player1 = create_player(1)
				@player2 = create_player(2)
				@board.player_1 = @player1
				@board.player_2 = @player2
			end
		else
			@player1 = create_player(1)
			@player2 = create_player(2)
			@board.player_1 = @player1
			@board.player_2 = @player2
		end
	end

	def game_end
		system('clear')
		print @board.draw_grid(@board.current_grid)

		puts "Congratulations #{@player1.name} you won" if @board.winner == 1
		puts "Congratulations #{@player2.name} you won" if @board.winner == 2
		puts "It's a draw" if @board.draw?
	end

	def replay?
		puts "Would you like to play again ?"
		replay = user_input(@yes_no_input, 'Please answer with yes or no')
		if replay == 'yes' || replay == 'y'
			start_game
		else
			puts "Thanks for playing"
		end
	end

end

Game.new.start_game