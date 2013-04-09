# a wholly unauthorized reproduction of "Cthulhu Dice" by Steve Jackson Games
# as a proof-of-concept

# TODO: allow 2-6 players
require './game'

module CthulhuDicePlayer
	def setup
		self.sanity = 3
	end

	attr_accessor :sanity
end

class CthulhuDice < Game
	n_players 2

	def setup
		self.cthulhu_sanity = 0
		self.turn = 0
		self.game_over = false
		self.winner = nil
	end

	attr_accessor :turn
	attr_accessor :cthulhu_sanity

	attr_accessor :game_over, :winner

	CTHULHU_DIE = [:yellow, :yellow, :tentacle, :tentacle, :eye, :yellow, :tentacle, :yellow, :cthulhu, :tentacle, :yellow, :elder]

	def tell_all(*args)
		players.each do |player|
			player.tell *args
		end
	end

	def player_victimize(caster, victim_index)
		if self.players[turn] != caster then
			caster.tell "it's not your turn!"
			return
		elsif victim_index < 0 || victim_index > self.players.length then
			caster.tell "that's not a player that exists"
			return
		elsif self.players[victim_index] == caster then
			caster.tell "you probably don't want to do that"
			return
		else
			victim = self.players[victim_index]
			caster_insane = (caster.sanity == 0)

			do_roll(caster, victim, caster, victim)
			# victim doesn't get to respond if the caster is insane
			do_roll(victim, caster, caster, victim) if !caster_insane

			next_turn!
		end
	end

	def do_roll(roller, roll_target, caster, victim)
		face = CTHULHU_DIE[rand(12)]

		case face
		when :yellow
			tell_all "the yellow sign - #{roll_target} loses 1 sanity to cthulhu"

			if (roll_target.sanity > 0) then
				roll_target.sanity -= 1
				self.cthulhu_sanity += 1
			end
		when :tentacle
			tell_all "the tentacle - #{caster} takes 1 sanity from #{victim}"

			if (victim.sanity > 0) then
				victim.sanity -= 1

				# if the caster is mad, the sanity goes to cthulhu
				if (caster.sanity > 0) then
					caster.sanity += 1
				else
					self.cthulhu_sanity += 1
				end
			end
		when :cthulhu
			tell_all "cthulhu - everyone loses 1 sanity to cthulhu"

			self.players.each do |player|
				if (player.sanity > 0) then
					player.sanity -= 1
					self.cthulhu_sanity += 1
				end
			end
		when :eye
			tell_all "the eye - choose a result"
			# TODO: add choice; right now always choose the elder sign

			if (self.cthulhu_sanity > 0) then
				roller.sanity += 1
				self.cthulhu_sanity -= 1
			end
		when :elder
			tell_all "the elder sign - #{roller} gains 1 sanity from cthulhu"

			if (self.cthulhu_sanity > 0) then
				roller.sanity += 1
				self.cthulhu_sanity -= 1
			end
		end
	end

	def next_turn!
		# end of turn!  check for madness.
		sane_players = self.players.select { |player| player.sanity > 0 }

		if sane_players.length == 0 then
			# everyone loses
			tell_all "everyone is insane; everyone loses"
			self.game_over = true
		elsif sane_players.length == 1 then
			# last sane player wins
			tell_all "#{sane_players[0]} is the last sane player"
			self.game_over = true
			self.winner = sane_players[0]
		else
			# still multiple sane players.  keep going.
		end

		self.turn = (self.turn + 1) % self.players.length
	end

	def player_status(player)
		self.players.each_index do |i|
			player.tell "player #{i}'s sanity is #{self.players[i].sanity}"
		end

		player.tell "cthulhu has stolen #{self.cthulhu_sanity}"
		player.tell "it's player #{self.turn}'s turn"
	end

	def end?
		self.game_over
	end
end