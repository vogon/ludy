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

		self.game_thread = Thread.new do
			while !self.end? do
				sleep 1
			end
			puts "game over"
		end
	end

	def wait_for_end
		self.game_thread.join
	end

	private
	attr_accessor :game_thread
end