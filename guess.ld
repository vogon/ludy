require './game'

module GuessANumberPlayer
	def setup
		self.guesses = 0
		self.winner = false
	end

	attr_accessor :guesses
	attr_accessor :winner
end

class GuessANumber < Game
	n_players 1

	def setup
		self.number = rand(10) + 1
	end

	attr_accessor :number

	def player_guess(player, n)
		if n == self.number then
			player.tell "you win!"
			player.winner = true
		elsif n < self.number then # lower than correct
			player.tell "higher"
		else # higher than correct
			player.tell "lower"
		end

		player.guesses += 1
	end

	def end?
		self.players.any? { |player| player && player.winner } or
			self.players.all? { |player| player && player.guesses >= 4 }
	end

	def winner
		self.players.find { |player| player && player.winner }
	end
end