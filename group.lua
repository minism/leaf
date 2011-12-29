--[[

#########################################################################
#                                                                       #
# group.lua                                                             #
#                                                                       #
# Container of objects that lets you run arbitrarily methods in a batch #
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

require 'leaf.containers'

local Group = {}

function Group.new()
    -- Allocate
    local grp = {}
    
    -- Initialize
    grp.list = leaf.List:new()
    grp.insert = function(obj) grp.list:insert(obj) return obj end
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

setmetatable(Group, {
    __call = Group.new
})


-- Namespace exports
leaf.Group = Group
