require './connect_four'

describe Board do

	let(:board) { Board.new }
	let(:player1) { Player.new("Loris", board, "white") }
	let(:player2) { Player.new("Jon", board, "black") }
	before do
		board.player_1 = player1
		board.player_2 = player2
	end

	context "#new" do

		let(:initial_grid) { Array.new(6) { Array.new(7) } }

		describe ".current_grid" do
			context "no moves played yet" do
				it { expect(board.current_grid).to eql(initial_grid) }				
			end
		end

		describe ".convert_color" do
			context "white" do
				it { expect(board.convert_color("white")).to eql("\u26aa") }
			end

			context "black" do
				it { expect(board.convert_color("black")).to eql("\u26ab") }
			end
		end

		describe ".to_disc" do
			context "player 1 is 'white'" do
				it { expect(board.to_disc(1)).to eql("\u26aa")}
			end

			context "player 2 is 'black'" do
				it { expect(board.to_disc(2)).to eql("\u26ab")}
			end

			context "empty space" do
				it { expect(board.to_disc(nil)).to eql(" ")}
			end
		end

		
		let(:empty_grid_draw)  {"| | | | | | | |\n" \
														"| | | | | | | |\n" \
														"| | | | | | | |\n" \
														"| | | | | | | |\n" \
														"| | | | | | | |\n" \
														"| | | | | | | |\n"}

		let(:played_grid_draw)   {"| | | | | | | |\n" \
							 								"| | | | | | | |\n" \
															"| | | | | | | |\n" \
															"| | | | | | | |\n" \
															'| | |"\u26ab"|"\u26aa"| | | |\n' \
															'|"\u26aa"|"\u26ab"|"\u26aa"|"\u26aa"| | | |\n'}

		describe ".draw_grid" do
			context "given .current_grid" do
				context "empty grid (full of nil)" do
					it { expect(board.draw_grid(board.current_grid)).to eql(empty_grid_draw) }
				end

				context "grid with already some moves played" do
					before do
						board.update_grid(0, 1)
						board.update_grid(1, 2)
						board.update_grid(2, 1)
						board.update_grid(2, 2)
						board.update_grid(3, 1)
						board.update_grid(3, 1)
					end
					skip { expect(board.draw_grid(board.current_grid)).to eql(played_grid_draw) }
				end
			end
		end
	end

	context ".next_empty_row" do
		context "empty grid" do
			it { expect(board.next_empty_row(4)).to eql(5) }
		end

		context "when already 3 disc in the column" do
			before do
				board.update_grid(2, 1)
				board.update_grid(2, 2)
				board.update_grid(2, 2)
			end
			it { expect(board.next_empty_row(2)).to eql(2) }
		end

		context "when the column is full" do
			before do
				board.update_grid(3, 1)
				board.update_grid(3, 2)
				board.update_grid(3, 2)
				board.update_grid(3, 1)
				board.update_grid(3, 2)
				board.update_grid(3, 2)
			end
			it { expect(board.next_empty_row(3)).to eql(nil) }
		end
	end

	context ".update_grid" do
		before do
			board.update_grid(1, 1)
			board.update_grid(1, 1)
		end
		context "player 1 put 2 disc in" do
			context "last row" do
				it {expect(board.current_grid[5][1]).to eql(1)}
			end
			context "second last row" do
				it {expect(board.current_grid[4][1]).to eql(1)}
			end
			context "the row after" do
				it {expect(board.current_grid[3][1]).to eql(nil)}
			end
		end
	end

	context ".last_move" do
		context "player 2 row 3 column 4" do
			before do
				board.update_grid(4, 2)
				board.update_grid(4, 2)
				board.update_grid(4, 2)
			end
			it { expect(board.last_move).to eql([3,4,2])}
		end

		context "last played is player 2 row 3 column 3" do 
			before do
				board.update_grid(0, 2)
				board.update_grid(1, 1)
				board.update_grid(1, 2)
				board.update_grid(2, 1)
				board.update_grid(2, 1)
				board.update_grid(2, 2)
				board.update_grid(3, 1)
				board.update_grid(3, 1)
				board.update_grid(3, 1)
				board.update_grid(3, 2)
			end
			it { expect(board.last_move).to eql([2,3,2])}
		end
	end

	context ".check_vertical_win" do
		context "player 2 got 4 aligned in column 3" do
			before do
				board.update_grid(3, 2)
				board.update_grid(3, 2)
				board.update_grid(3, 2)
				board.update_grid(3, 2)
			end
			it { expect(board.check_vertical_win).to eql(2) }
		end

		context "player 2 got 3 aligned in column 0" do
			before do
				board.update_grid(0, 2)
				board.update_grid(0, 2)
				board.update_grid(0, 2)
			end
			it { expect(board.check_vertical_win).to eql(nil) }
		end

		context "player 1 got 2 aligned in column 5" do
			before do
				board.update_grid(5, 1)
				board.update_grid(3, 2)
				board.update_grid(5, 1)
			end
			it { expect(board.check_vertical_win).to eql(nil) }
		end

		context "player 1 got 4 aligned in column 5" do
			before do
				board.update_grid(5, 1)
				board.update_grid(0, 2)
				board.update_grid(5, 1)
				board.update_grid(0, 2)
				board.update_grid(5, 1)
				board.update_grid(0, 2)
				board.update_grid(5, 1)
			end
			it { expect(board.check_vertical_win).to eql(1) }
		end

		context "player 1 got 4 in column 5 but player 2 in the middle of it" do
			before do
				board.update_grid(5, 1)
				board.update_grid(0, 2)
				board.update_grid(5, 1)
				board.update_grid(5, 2)
				board.update_grid(5, 1)
				board.update_grid(0, 2)
				board.update_grid(5, 1)
			end
			it { expect(board.check_vertical_win).to eql(nil) }
		end
	end

	context ".check_diagonal_win(way)" do
		context "player 2 got only 3 in right diagonal" do
			before do
				board.update_grid(0, 2)
				board.update_grid(1, 1)
				board.update_grid(1, 2)
				board.update_grid(2, 1)
				board.update_grid(2, 1)
				board.update_grid(2, 2)
			end
			it { expect(board.check_diagonal_win(-1)).to eql(nil) }
			it { expect(board.check_diagonal_win(1)).to eql(nil) }
		end

		context "no diagonal win but played higher than row 2" do
			before do
				board.update_grid(0, 2)
				board.update_grid(1, 1)
				board.update_grid(1, 2)
				board.update_grid(2, 1)
				board.update_grid(2, 1)
				board.update_grid(2, 2)
				board.update_grid(3, 1)
				board.update_grid(3, 1)
				board.update_grid(3, 2)
				board.update_grid(3, 1)
			end
			it { expect(board.check_diagonal_win(-1)).to eql(nil) }
			it { expect(board.check_diagonal_win(1)).to eql(nil) }
		end

		context "player 1 has a right diagonal (from down)" do
			before do
				board.update_grid(0, 2)
				board.update_grid(0, 2)
				board.update_grid(0, 2)
				board.update_grid(0, 1)
				board.update_grid(1, 2)
				board.update_grid(1, 2)
				board.update_grid(1, 1)
				board.update_grid(2, 2)
				board.update_grid(2, 1)
				board.update_grid(3, 1)
			end
			it "left is nil" do
				expect(board.check_diagonal_win(-1)).to eql(nil)
			end
			it "right is 2" do
				expect(board.check_diagonal_win(1)).to eql(1)
			end
		end

		context "player 2 has a left diagonal" do
			let(:grid) { [[0, 0, 0, 0, 0, 0, 0],
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 0, 0, 2, 0, 0, 0], 
										[0, 0, 2, 1, 0, 0, 0], 
										[0, 2, 1, 1, 0, 0, 0], 
										[2, 1, 1, 1, 0, 0, 0]] }

			let(:last_move) {[2,3,2]}
			before do
			   allow(board).to receive(:current_grid).and_return(grid)
			   allow(board).to receive(:last_move).and_return(last_move)
			end

			it "left is 2" do
				expect(board.check_diagonal_win(-1)).to eql(2)
			end
			it "right is nil" do
				expect(board.check_diagonal_win(1)).to eql(nil)
			end
		end

		context "player 2 has a left diagonal (last move in the middle)" do
			let(:grid) { [[0, 0, 0, 0, 0, 0, 0],
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 0, 0, 2, 0, 0, 0], 
										[0, 0, 2, 1, 0, 0, 0], 
										[0, 2, 1, 1, 0, 0, 0], 
										[2, 1, 1, 1, 0, 0, 0]] }

			let(:last_move) {[3,2,2]}
			before do
			   allow(board).to receive(:current_grid).and_return(grid)
			   allow(board).to receive(:last_move).and_return(last_move)
			end

			it "left is 2" do
				expect(board.check_diagonal_win(-1)).to eql(2)
			end
			it "right is nil" do
				expect(board.check_diagonal_win(1)).to eql(nil)
			end
		end

		context "player 1 has a right diagonal (last move in the middle)" do
			let(:grid) { [[0, 0, 0, 0, 0, 0, 0],
										[0, 0, 1, 0, 0, 0, 0], 
										[0, 0, 2, 1, 2, 0, 0], 
										[0, 0, 1, 2, 1, 0, 0], 
										[0, 2, 1, 2, 1, 1, 0], 
										[2, 1, 2, 2, 1, 2, 2]] }

			let(:last_move) {[3,4,1]}
			before do
			   allow(board).to receive(:current_grid).and_return(grid)
			   allow(board).to receive(:last_move).and_return(last_move)
			end

			it "left is nil" do
				expect(board.check_diagonal_win(-1)).to eql(nil)
			end
			it "right is 1" do
				expect(board.check_diagonal_win(1)).to eql(1)
			end
		end
	end


	context "check_horizontal_win" do

		context "player 1 has a horizontal row 5" do
			let(:grid) { [[0, 0, 0, 0, 0, 0, 0],
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 0, 0, 1, 1, 1, 1]] }

			let(:last_move) {[5,4,1]}
			before do
			   allow(board).to receive(:current_grid).and_return(grid)
			   allow(board).to receive(:last_move).and_return(last_move)
			end

			it { expect(board.check_horizontal_win).to eql(1) }
		end

		context "player 2 has a horizontal row 2" do
			let(:grid) { [[0, 0, 0, 0, 0, 0, 0],
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 2, 2, 2, 2, 0, 0], 
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 0, 0, 0, 0, 0, 0]] }

			let(:last_move) {[2,3,2]}
			before do
			   allow(board).to receive(:current_grid).and_return(grid)
			   allow(board).to receive(:last_move).and_return(last_move)
			end

			it { expect(board.check_horizontal_win).to eql(2) }
		end		

	end

	context ".winner?" do
		context "player 1 has a right diagonal (last move in the middle)" do
			let(:grid) { [[0, 0, 0, 0, 0, 0, 0],
										[0, 0, 1, 0, 0, 0, 0], 
										[0, 0, 2, 1, 2, 0, 0], 
										[0, 0, 1, 2, 1, 0, 0], 
										[0, 2, 1, 2, 1, 1, 0], 
										[2, 1, 2, 2, 1, 2, 2]] }

			let(:last_move) {[3,4,1]}
			before do
			   allow(board).to receive(:current_grid).and_return(grid)
			   allow(board).to receive(:last_move).and_return(last_move)
			end

			it { expect(board.winner?).to be true }
		end

	end


	context ".draw?" do

		context "the grid is full with no winner" do
			let(:grid) { [[1, 2, 1, 2, 2, 1, 1],
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 0, 2, 2, 0, 0, 0], 
										[0, 0, 1, 2, 0, 0, 0], 
										[0, 2, 1, 1, 0, 0, 0], 
										[2, 1, 1, 1, 0, 0, 0]] }

			let(:last_move) {[0,0,1]}
			before do
			   allow(board).to receive(:current_grid).and_return(grid)
			   allow(board).to receive(:last_move).and_return(last_move)
			end

			it { expect(board.draw?).to be true }

		end

		context "no draw" do
			let(:grid) { [[nil, 2, 1, 2, 2, 1, 1],
										[0, 0, 0, 0, 0, 0, 0], 
										[0, 0, 2, 2, 0, 0, 0], 
										[0, 0, 1, 2, 0, 0, 0], 
										[0, 2, 1, 1, 0, 0, 0], 
										[2, 1, 1, 1, 0, 0, 0]] }

			let(:last_move) {[0,0,1]}
			before do
			   allow(board).to receive(:current_grid).and_return(grid)
			   allow(board).to receive(:last_move).and_return(last_move)
			end

			it { expect(board.draw?).to be false }

		end

	end

end

describe Player do

	context "#new" do

		it "requires 3 arguments" do
			expect { Player.new }.to raise_error(ArgumentError)
			expect { Player.new "abc" }.to raise_error(ArgumentError)
			expect { Player.new 1, "abc", 13, "tt" }.to raise_error(ArgumentError)
		end
	end

end

describe Game do

	describe "#new" do

		let(:game) { Game.new }

		context ".user_input(regexp, error_msg, input = gets.chomp)" do
			context "name : regex = /^[a-z]+$/i and error_msg = 'Please enter one word composed only of letters.' input = 'Loris'" do
				it { expect(game.user_input(/^[a-z]+$/i, 'Please enter one word composed only of letters.', "Loris")).to eql('Loris')}
			end

			context "name : regex = /^[a-z]+$/i and error_msg = 'Please enter one word composed only of letters.' input = 'Loris Aranda'" do
				it { expect(game.user_input(/^[a-z]+$/i, 'Please enter one word composed only of letters.', "Loris Aranda")).to eql('Please enter one word composed only of letters.')}
			end

			context "name : regex = /^[a-z]+$/i and error_msg = 'Please enter one word composed only of letters.' input = '123 Lolo'" do
				it { expect(game.user_input(/^[a-z]+$/i, 'Please enter one word composed only of letters.', "123 Lolo")).to eql('Please enter one word composed only of letters.')}
			end

			context "name : regex = /^[a-z]+$/i and error_msg = 'Please enter one word composed only of letters.' input = '%% dspld'" do
				it { expect(game.user_input(/^[a-z]+$/i, 'Please enter one word composed only of letters.', "%% dspld")).to eql('Please enter one word composed only of letters.')}
			end

			context "name : regex = /^[a-z]+$/i and error_msg = 'Please enter one word composed only of letters.' input = ''" do
				it { expect(game.user_input(/^[a-z]+$/i, 'Please enter one word composed only of letters.', "")).to eql('Please enter one word composed only of letters.')}
			end
		end

		context ".user_input(regexp, error_msg, input = gets.chomp)" do
			context "play : regex = /^[1-7]$/ and error_msg = 'Please enter a digit between 1 and 7' input = '5'" do
				it { expect(game.user_input(/^[1-7]$/, 'Please enter a digit between 1 and 7', "5")).to eql('5')}
			end

			context "play : regex = /^[1-7]$/ and error_msg = 'Please enter a digit between 1 and 7' input = '456'" do
				it { expect(game.user_input(/^[1-7]$/, 'Please enter a digit between 1 and 7', "456")).to eql('Please enter a digit between 1 and 7')}
			end

			context "play : regex = /^[1-7]$/ and error_msg = 'Please enter a digit between 1 and 7' input = 'a'" do
				it { expect(game.user_input(/^[1-7]$/, 'Please enter a digit between 1 and 7', "a")).to eql('Please enter a digit between 1 and 7')}
			end

			context "play : regex = /^[1-7]$/ and error_msg = 'Please enter a digit between 1 and 7' input = '$'" do
				it { expect(game.user_input(/^[1-7]$/, 'Please enter a digit between 1 and 7', "$")).to eql('Please enter a digit between 1 and 7')}
			end

			context "play : regex = /^[1-7]$/ and error_msg = 'Please enter a digit between 1 and 7' input = ''" do
				it { expect(game.user_input(/^[1-7]$/, 'Please enter a digit between 1 and 7', "")).to eql('Please enter a digit between 1 and 7')}
			end
		end

		context ".user_input(regexp, error_msg, input = gets.chomp)" do
			context "disc : regex = /^(black|white)$/ and error_msg = 'Please select black or white' input = 'white'" do
				it { expect(game.user_input(/^(black|white)$/, 'Please select black or white', "white")).to eql('white')}
			end

			context "disc : regex = /^(black|white)$/ and error_msg = 'Please select black or white' input = 'black'" do
				it { expect(game.user_input(/^(black|white)$/, 'Please select black or white', "black")).to eql('black')}
			end

			context "disc : regex = /^(black|white)$/ and error_msg = 'Please select black or white' input = 'carrot'" do
				it { expect(game.user_input(/^(black|white)$/, 'Please select black or white', "carrot")).to eql('Please select black or white')}
			end
		end


	end

end