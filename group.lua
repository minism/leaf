-- ++++++++++++++++++++++++++++++
-- + Leaf Group Class           +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.containers'

leaf.Group = {}
local Group = leaf.Group

Group.mt = {}

function Group.new()
	-- Allocate
	local grp = {}
	
	-- Initialize
	grp.list = leaf.List:new()
	grp.insert = function(obj) grp.list:insert(obj) end
	grp.remove = function(obj) grp.list:remove(obj) end
	
	-- Setup an index metamethod that calls methods on children
	local mt = {}
	mt.__index = function (table, key)
		-- Return a function which calls `key` on all children
		local f = function(...)
			for obj in table.list:iter() do
				obj[key](obj, unpack(arg))
			end
		end
		return f
	end
	
	setmetatable(grp, mt)

	return grp
end