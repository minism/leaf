-- ++++++++++++++++++++++++++++++
-- + Leaf Console Module        +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'
require 'leaf.containers'
require 'leaf.time'

local Message = leaf.Object:extend('Message')

function Message:init(str, err)
	self.alpha	= 255
	self.str 	= str or ''
end

----[[ Console singleton ]]----

leaf.console = {}
local console = leaf.console

console.queue = leaf.Queue:new()
console.color = {255, 255, 255}
console.queue.max = 35
console.lifetime = 3
console.fadetime = 0.5

function console.setMax(n)
    console.queue.max = n
end

function console.pop()
	console.queue:pop()
end

function console.makeFader(msg)
	return function()
		leaf.time.interp(console.fadetime, 	function(a)
												msg.alpha = (1.0 - a) * 255
											end)
		leaf.time.after(console.fadetime, console.pop)
	end
end

function console.write(...)
	str = ''
	for _, v in ipairs(arg) do
		str = str .. v .. ' '
	end
	local msg = Message:new(str)
	console.queue:push(msg)
	-- Timer to fadeout and delete this message from queue
	leaf.time.after(console.lifetime, console.makeFader(msg))
end

function console.draw()
	local spacing = 15
	local r, g, b = unpack(console.color)
	local num = 0
	for i = console.queue.front, console.queue.back do
		num = num + 1
		local msg = console.queue[i]
		love.graphics.setColor(r, g, b, msg.alpha)
		love.graphics.print(msg.str, 5, (num - 1) * spacing)
	end
end
