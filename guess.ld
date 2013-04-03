module GuessANumberPlayer
	def start
		self.guesses = 0
		self.winner = false
	end

	attr_accessor :guesses
	attr_accessor :winner
end

class GuessANumber < Game
	n_players 1

	def start
		self.number = rand(10) + 1
	end

	attr_accessor :number

	def player_guess(player, n)
		if n == self.number then
			player.winner = true
		end

		player.guesses += 1
	end

	def end?
		self.players.any? { |player| player.winner } or
			self.players.all? { |player| player.guesses >= 3 }
	end

	def winner
		self.players.find { |player| player.winner }
	end
end