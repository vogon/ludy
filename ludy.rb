require 'pry'
require './replplayer'

load './guess.ld'

g = GuessANumber.new

p = ReplPlayer.new(g)
p.extend GuessANumberPlayer

g.players[0] = p

p.setup

g.start

repl = Pry.new({ quiet: true,
				 prompt: Pry::SIMPLE_PROMPT })

# read-eval loop, for the discreet REPList
# (stuck together out of Pry documentation code)
def rel(pry, target=TOPLEVEL_BINDING)
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

Thread.new do
	result = rel(repl, p.proxy)
end

while !g.end? do
	sleep 1
end