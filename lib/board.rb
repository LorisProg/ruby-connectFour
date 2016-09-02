require 'pry'

class Board

	attr_reader :current_grid, :last_move, :winner
	attr_writer :player_1, :player_2

	def initialize
		@current_grid = self.empty_grid
		@player_1 = nil
		@player_2 = nil
		@last_move = nil
		@winner = nil
	end

	def empty_grid
		Array.new(6) { Array.new(7) }
	end

	def convert_color(color)
		return "\u26aa" if color == "white"
		return "\u26ab" if color == "black"
		nil	
	end

	def to_disc(player)
		if !player.nil?
			return convert_color(@player_1.disc_color) if player == 1
			return convert_color(@player_2.disc_color) if player == 2
		else
				return " "
		end
	end

	def draw_grid(grid)
		rows = grid.size
		columns = grid[0].size
		draw = ""

		rows.times do |i|
			columns.times do |j|
				draw += "|#{to_disc(grid[i][j])}"
			end
			draw += "|\n"
		end
		columns.times do |x|
			draw += " #{x + 1}"
		end
		draw += "\n"
		draw
	end

	def update_grid(column, player_id)
		row = next_empty_row(column)
		@current_grid[row][column] = player_id
		@last_move = [row, column, player_id]
	end

	def next_empty_row(column)
		row = 5
		empty_row = nil
		until empty_row || row < 0
			if @current_grid[row][column].nil?
				empty_row = row
			else
				row -= 1
			end
		end
		empty_row
	end

	def check_vertical_win
		return nil if last_move.nil?
		return nil if last_move[0] > 2
		row = last_move[0]
		column = last_move[1]
		player_id = last_move[2]
		connect = 1
		until row == 5 || connect == 4
			return nil if current_grid[row+1][column] != player_id
			connect += 1
			row += 1
		end
		return player_id if connect == 4
		nil
	end

	def check_diagonal_win(way)
		return nil if last_move.nil?
		row = last_move[0]
		column = last_move[1]
		player_id = last_move[2]
		connect = 1
		until row == 5 || connect == 4 || column+way > 5
			break if current_grid[row+1][column+way] != player_id
			column += way
			row += 1
			connect += 1
		end

		return player_id if connect == 4
		row = last_move[0]
		column = last_move[1]

		until row == 0 || connect == 4 || column-way < 0
			return nil if current_grid[row-1][column-way] != player_id
			column -= way
			row -= 1
			connect += 1
		end
		return player_id if connect == 4
		nil
	end

	def check_horizontal_win
		return nil if last_move.nil?
		row = last_move[0]
		column = last_move[1]
		player_id = last_move[2]
		connect = 1
		until column == 6 || connect == 4
			break if current_grid[row][column+1] != player_id
			connect += 1
			column += 1
		end
		return player_id if connect == 4

		column = last_move[1]
		until column == 0 || connect == 4
			return nil if current_grid[row][column-1] != player_id
			connect += 1
			column -= 1
		end

		return player_id if connect == 4
		nil
	end

	def winner?
		return true if @winner

		if check_vertical_win
			@winner = check_vertical_win
			return true
		elsif check_horizontal_win
			@winner = check_horizontal_win
			return true
		elsif check_diagonal_win(-1)
			@winner = check_diagonal_win(-1)
			return true
		elsif check_diagonal_win(1)
			@winner = check_diagonal_win(1)
			return true
		end
		false	
	end

	def draw?
		return false if current_grid[0].include?(nil)
		true
	end

end