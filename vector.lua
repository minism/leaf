-- ++++++++++++++++++++++++++++++
-- + Leaf Vector Library        +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'
require 'math'

leaf.Vector = leaf.Object:extend('Vector')
local Vector = leaf.Vector

function Vector:init(x, y)
    self.x = x or 0.0
    self.y = y or 0.0
end

function Vector.__add(v1, v2)
	local result = Leaf.Vector:new()
	result.x = v1.x + v2.x
	result.y = v1.y + v2.y
	return result
end

function Vector.__mul(vec, scalar)
	local result = Leaf.Vector:new()
	result.x = vec.x * scalar
	result.y = vec.y * scalar
	return result
end

function Vector:len(self)
	return sqrt(self.x * self.x, self.y * self.y)
end

function Vector:moveTo(x, y)
	self.x = x
	self.y = y
end

function Vector:clear()
	self.x = 0
	self.y = 0
end