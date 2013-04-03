class ReplPlayer
	attr_accessor :proxy

	def initialize(game)
		self.proxy = Proxy.new(game, self)
	end

	def tell(*args)
		print *args
	end

	private
	class Proxy
		def initialize(game, player)
			self.game = game
			self.player = player
		end

		attr_accessor :game, :player

		def method_missing(name, *args)
			# print "#{name}(#{args})"

			# rewrite name
			game_name = "player_#{name}"
			# pass it to game
			self.game.public_send(game_name, self.player, *args)
		end

	end
end