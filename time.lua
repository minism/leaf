-- ++++++++++++++++++++++++++++++
-- + Leaf Time Library          +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'

----[[ Timer class ]]----

leaf.Timer = leaf.Object:extend('Timer')
local Timer = leaf.Timer

function Timer:init(duration, callback, loops, start)
	self.duration = duration
	self.callback = callback
	self.loops = loops
	self.timeleft = self.duration
	self.running = false
	-- Optionally start the timer if we passed start=true
	if start then self:start() end
end

function Timer:start()
	self.running = true
	self.timeleft = self.duration
end

function Timer:stop()
	self.running = false
	self.timeleft = 0
end

function Timer:pause()
	self.running = false
end

function Timer:resume()
	self.running = true
end

--- Update the timer
function Timer:update(dt)
	if self.running then
		self.timeleft = self.timeleft - dt
		if self.timeleft < 0.0 then
			self.timeleft = self.duration
			if self.callback then
				self.callback()
			end
			-- Check how many loops remaining, loop infinitely if set to < 0
            self.loops = self.loops - 1
			if self.loops == 0 then self.stop() end
			return true
		end
		return false
	end
	return false
end

----[[ Time singleton ]]----

leaf.time = leaf.Object:new()
local time = leaf.time

time.timers = {}

--- Update all timers, this must be called from main loop!
function time.update(dt)
	for _, timer in ipairs(time.timers) do
		timer:update(dt)
	end
end

--- Create and return generic timer with all constructor arguments required
function time.timer(duration, callback, loops, start)
	start = start or true
	local timer = Timer:new(duration, callback, loops, start)
	table.insert(time.timers, timer)
	return timer
end

--- Shortcut: schedule `callback` after `duration` milliseconds
function time.after(duration, callback)
	return time.timer(duration, callback, 1, true)
end

--- Shortcut: schedule `callback` every `duration` milliseconds
function time.every(duration, callback)
	return time.timer(duration, callback, 0, true)
end