require 'socket'
require 'pry'

class RemoteReplPlayer
	attr_accessor :proxy
	attr_accessor :repl

	attr_accessor :server
	attr_accessor :client

	def initialize(game, port)
		self.proxy = Proxy.new(game, self)

		self.server = TCPServer.new(port)
	end

	def run
		self.client = self.server.accept
		self.repl = Pry.new({ quiet: true, input: self.client, output: self.client, prompt: Pry::SIMPLE_PROMPT })

		rel(self.repl, self.proxy)
	end

	def rel(pry, target)
		target = Pry.binding_for(target)

		pry.repl_prologue(target)

		break_data = nil
		exception = catch(:raise_up) do
		    break_data = catch(:breakout) do
			    loop do
		    	    pry.re(pry.binding_stack.last)
		      	end
		    end
		    exception = false
		end

		raise exception if exception

		break_data
		
	ensure
		pry.repl_epilogue(target)
	end

	def tell(*args)
		self.client.puts *args
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
			# suppress return
			nil
		end
	end
end