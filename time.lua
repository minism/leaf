--[[

#########################################################################
#                                                                       #
# time.lua                                                              #
#                                                                       #
# Timer objects for scheduled events                                    #
#                                                                       #
# Copyright 2011 Josh Bothun                                            #
# joshbothun@gmail.com                                                  #
# http://minornine.com                                                  #
#                                                                       #
# This program is free software: you can redistribute it and/or modify  #
# it under the terms of the GNU General Public License as published by  #
# the Free Software Foundation, either version 3 of the License, or     #
# (at your option) any later version.                                   #
#                                                                       #
# This program is distributed in the hope that it will be useful,       #
# but WITHOUT ANY WARRANTY; without even the implied warranty of        #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
# GNU General Public License <http://www.gnu.org/licenses/> for         #
# more details.                                                         #
#                                                                       #
#########################################################################                                             

--]]

require 'leaf.object'
require 'leaf.containers'

-- Timer class --

leaf.Timer = leaf.Object:extend()
local Timer = leaf.Timer

function Timer:init(duration, callback, loops, start)
	self.duration = duration
	self.callback = callback
	self.loops = loops or 1
	self.timeleft = self.duration
	self.running = false
	self.dead = false
	start = start or true
	if start then self:start() end
end

-- Start or restart the timer
function Timer:start()
	self.running = true
	self.timeleft = self.duration
end
Timer.restart = Timer.start

-- Stops timer and flags it for removal
function Timer:kill()
	self.running = false
	self.dead = true
end

-- Safe pause
function Timer:pause()
	self.running = false
end

-- Safe resume
function Timer:resume()
	self.running = true
end

-- Update the timer
function Timer:update(dt)
	if self.running then
		self.timeleft = self.timeleft - dt
		if self.timeleft < 0.0 then
			self.timeleft = self.timeleft + self.duration
			self.callback()
			-- Check how many loops remaining, loop infinitely if set to < 0
            self.loops = Math.max(self.loops - 1, -1) -- Prevent overflow
			if self.loops == 0 then self:kill() end
			return true
		end
		return false
	end
	return false
end


-- Interpolator class --

-- Interpolators which execute every tick, passing
-- a 0-1 alpha argument to its bound callback

leaf.Interpolator = Timer:extend()
local Interpolator = leaf.Interpolator

function Interpolator:update(dt)
	if Timer.update(self) then
		-- Finished, call with max value
		self.callback(1)
	end

	-- Calculate alpha
	local alpha = 1.0 - self.timeleft / self.duration
	self.callback(alpha)

end

	
-- Time singleton (main usage) --

leaf.time = leaf.Object()
local time = leaf.time

time.timers = leaf.List()

--- Update all timers, this MUST be called from main loop!
function time.update(dt)
	for timer in time.timers:iter() do
		timer:update(dt)
		if timer.dead then
			-- Remove timer from list
			time.timers:remove(timer)
		end
	end
end

-- Create, register and return a new timer
function time.timer(duration, callback, loops, start)
	local timer = Timer:new(duration, callback, loops, start)
	time.timers:insert(timer)
	return timer
end

-- Create, register and return a new interpolator
function time.interp(duration, callback, loops, start)
	local interp = Interpolator:new(duration, callback, loops, start)
	time.timers:insert(interp)
	return interp
end

-- Schedule `callback` after `duration` milliseconds
function time.after(duration, callback)
	return time.timer(duration, callback, 1, true)
end

-- Schedule `callback` every `duration` milliseconds
function time.every(duration, callback)
	return time.timer(duration, callback, 0, true)
end
