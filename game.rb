class Game
	def self.n_players(n)
		@@n_players = n
	end

	def initialize
		self.players = [nil] * @@n_players
	end

	attr_accessor :players

	def start
		self.setup
	end

	# default "game over?" predicate; implementations should override it
	def end?
		false
	end

	private
	attr_accessor :game_thread
end