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
	self.loops = loops or 1
	self.timeleft = self.duration
	self.running = false
	start = start or true
	if start then self:start() end
end

function Timer:start()
	self.running = true
	self.timeleft = self.duration
end

--- Stops timer and flags it for deletion it from the master list
function Timer:stop()
	self.running = false
	self.stopped = true
end

function Timer:pause()
	self.running = false
end

function Timer:resume()
	self.running = true
end

function Timer:trigger()
	-- Execute the callback
	self.callback()
end

--- Update the timer
function Timer:update(dt)
	if self.running then
		self.timeleft = self.timeleft - dt
		if self.timeleft < 0.0 then
			self.timeleft = self.duration
			if self.callback then
				self:trigger()
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


----[[ Interpolator classes ]]----

-- Abstract Interpolators which execute every tick, passing
-- an ALPHA argument to its bound callback, which may
-- vary depending on its curve function

leaf.AbsInterp = Timer:extend('AbsInterp')
local AbsInterp = leaf.AbsInterp

function AbsInterp:update(dt)
	if self.running then
		self.timeleft = self.timeleft - dt
		if self.timeleft < 0.0 then
			-- Call callback with maximum (1.0)
			self:trigger(1.0)
			-- Check how many loops remaining, loop infinitely if set to < 0
            self.loops = self.loops - 1
			if self.loops == 0 then self.stop() end
			return true
		else
			local alpha = 1.0 - self.timeleft / self.duration
			-- Call callback with alpha
			self:trigger(alpha)
		end
		return false
	end
	return false
end

function AbsInterp:trigger(alpha)
    self.callback(alpha)
end

-- Standard interpolator will directly change a specific table value

leaf.Interp = AbsInterp:extend('Interp')
local Interp = leaf.Interp

function Interp:init(duration, args, loops, start)
    AbsInterp.init(self, duration, nil, loops, start)
    self.table = args.table
    self.key = args.key
    self.startval = args.startval
    self.endval = args.endval
end

function Interp:trigger(alpha)
    self.table[self.key] = self.startval + (self.endval - self.startval) * alpha
end
	
----[[ Time singleton ]]----

leaf.time = leaf.Object:new()
local time = leaf.time

time.timers = leaf.List:new()

--- Update all timers, this MUST be called from main loop!
function time.update(dt)
	for timer in time.timers:iter() do
		timer:update(dt)
		if timer.stopped then
			-- Remove timer from list
			time.timers:remove(timer)
		end
	end
end

--- Create, register and return a new timer
function time.timer(duration, callback, loops, start)
	local timer = Timer:new(duration, callback, loops, start)
	time.timers:insert(timer)
	return timer
end


--- Create, register and return a new abstract interpolator
function time.absinterp(duration, callback, loops, start)
    local absinterp = AbsInterp:new(duration, callback, loops, start)
    time.timers:insert(absinterp)
    return absinterp
end

--- Create, register and return a new interpolator
function time.interp(duration, args, loops, start)
	local interp = Interp:new(duration, args, loops, start)
	time.timers:insert(interp)
	return interp
end

----[[ Shortcut/utility functions ]]----

--- Schedule `callback` after `duration` milliseconds
function time.after(duration, callback)
	return time.timer(duration, callback, 1, true)
end

--- Schedule `callback` every `duration` milliseconds
function time.every(duration, callback)
	return time.timer(duration, callback, 0, true)
end
