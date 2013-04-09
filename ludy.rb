require './remotereplplayer'

load './cthulhu_dice.ld'

g = CthulhuDice.new

p0 = RemoteReplPlayer.new(g, 3569)
p0.extend CthulhuDicePlayer

p1 = RemoteReplPlayer.new(g, 3570)
p1.extend CthulhuDicePlayer

g.players = [p0, p1]

p0.setup
p1.setup

g.start

Thread.new do
	begin
		result = p0.run
	rescue Exception => e
		puts e
	end
end

Thread.new do
	begin
		result = p1.run
	rescue Exception => e
		puts e
	end
end

while !g.end? do
	sleep 1
end