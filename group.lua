-- ++++++++++++++++++++++++++++++
-- + Leaf Group Class           +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'
require 'leaf.containers'

leaf.Group = leaf.Object:extend('Group')
local Group = leaf.Group

function Group:init()
	-- Internal list to hold arbitrary objects
	self.list = leaf.List:new()
	
	-- Override metatable
	self._mt = {}
	setmetatable(self, self._mt)
	
	-- Override index metamethod to call list children instead if super class
	self._mt.__index = function (table, key)
		-- Return a function which calls `key` on all children
		local f = function(...)
			for obj in self.list:iter() do
				obj[key](unpack(arg))
			end
		end
		return f
	end
end

-- Wrapper methods around internal list
function Group:insert(obj)
	self.list:insert(obj)
end

function Group:remove(obj)
	self.list:remove(obj)
end

