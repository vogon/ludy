require 'pry'
require './replplayer'

load './guess.ld'

g = GuessANumber.new

p = ReplPlayer.new(g)
p.extend GuessANumberPlayer

g.players[0] = p

p.setup

g.start

Thread.new do
	p.proxy.pry({ quiet: true })
end

while !g.end? do
	sleep 1
end