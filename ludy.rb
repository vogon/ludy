require './remotereplplayer'

load './guess.ld'

g = GuessANumber.new

p = RemoteReplPlayer.new(g, 3569)
p.extend GuessANumberPlayer

g.players[0] = p

p.setup

g.start

Thread.new do
	result = p.run
end

while !g.end? do
	sleep 1
end