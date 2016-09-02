require './lib/board'

class Player

	attr_reader :disc_color, :name

	def initialize name, board, disc_color
			@name = name
			@board = board
			@disc_color = disc_color
	end


end