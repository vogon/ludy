require 'pry'
require './replplayer'

load './guess.ld'

g = GuessANumber.new

p = ReplPlayer.new(g)
p.extend GuessANumberPlayer

g.players[0] = p

p.setup

g.start

p.proxy.pry({ quiet: true })