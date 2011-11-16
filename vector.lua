--[[

#########################################################################
#                                                                       #
# vector.lua                                                            #
#                                                                       #
# 2D vector class                                                       #
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
require 'math'

leaf.Vector = leaf.Object:extend()
local Vector = leaf.Vector

function Vector:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

local function assert_vecs(a, b)
	assert(isinstance(a, Vector) and isinstance(b, Vector), "Operands must be Vectors.")
end

function Vector.__add(a, b)
	assert_vecs(a, b)
	return Vector(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
	assert_vecs(a, b)
	return Vector(a.x - b.x, a.y - b.y)
end

function Vector.__mul(a, b)
	if type(a) == 'number' then
		assert(isinstance(b, Vector), "Operands must be numbers or vectors.")
		return Vector(b.x * a, b.y * a)
	elseif type(b) == 'number' then
		assert(isinstance(a, Vector), "Operands must be numbers or vectors.")
		return Vector(a.x * b, a.y * b)
	else
		assert_vecs(a, b)
		return Vector(a.x * b.x, a.y * b.y)
	end
end

function Vector.__div(a, b)
	assert(isinstance(a, Vector) and type(b) == 'number', "Can only divide a Vector by a number.")
	return Vector(a.x / b, a.y / b)
end

function Vector.__eq(a, b)
	assert_vecs(a, b)
	return a.x == b.x and a.y == b.y
end

function Vector.__lt(a, b)
	assert_vecs(a, b)
	return a:len() < b:len()
end

function Vector.__lte(a, b)
	assert_vecs(a, b)
	return a:len() <= b:len()
end

function Vector.__gt(a, b)
	assert_vecs(a, b)
	return a:len() > b:len()
end

function Vector.__gte(a, b)
	assert_vecs(a, b)
	return a:len() >= b:len()
end

function Vector:__tostring()
	return "(" .. self.x .. "," .. self.y .. ")"
end

function Vector:copy()
	return Vector(self.x, self.y)
end

function Vector:unpack()
	return self.x, self.y
end

function Vector:len()
	return math.sqrt(self.x * self.x, self.y * self.y)
end

function Vector:normalize()
	local len = self:len()
	self.x = self.x / len
	self.y = self.y / len
	return self
end

function Vector:normalized()
	return self:copy():normalize()
end

function Vector:translate(x, y)
	self.x = self.x + x
	self.y = self.y + y
	return self
end

function Vector:translated(x, y)
	return self:copy():translate(x, y)
end

function Vector:rotate(theta)
	self.x = self.x * math.cos(theta) - self.y * math.sin(theta)
	self.y = self.x * math.sin(theta) + self.y * math.cos(theta)
	return self
end

function Vector:rotated(theta)
	return self:copy():rotate(theta)
end

function Vector:set(a, b)
	if isinstance(a, Vector) then
		self.x = a.x
		self.y = a.y
	else
		self.x = a
		self.y = b
	end
	return self
end

function Vector:reset()
	self.x = 0
	self.y = 0
	return self
end

-- Convenience naming
leaf.Point = leaf.Vector
