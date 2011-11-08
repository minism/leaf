--[[

########################################################################
#                                                                      #
# object.lua                                                           #
#                                                                      #
# Base object for all modules in leaf, and simple OO implementation.   #
#                                                                      #
# Copyright 2011 Josh Bothun                                           #
# joshbothun@gmail.com                                                 #
# http://minornine.com                                                 #
#                                                                      #
# This program is free software: you can redistribute it and/or modify #
# it under the terms of the GNU General Public License as published by #
# the Free Software Foundation, either version 3 of the License, or    #
# (at your option) any later version.                                  #
#                                                                      #
# This program is distributed in the hope that it will be useful,      #
# but WITHOUT ANY WARRANTY; without even the implied warranty of       #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
# GNU General Public License <http://www.gnu.org/licenses/> for        #
# more details.                                                        #
#                                                                      #
########################################################################

--]]        

leaf.Object = {}
local Object = leaf.Object

-- Repeated in extend, but needed for base
Object.__index = Object
Object.__call = function(c, ...) return c:new(...) end

-- Creates, initializes, and returns a new object
function Object:new(...)
	local obj = {}
	setmetatable(obj, self)
    if obj.init then obj:init(...) end
	return obj
end

-- Creates and returns a new class
function Object:extend(classname)
    local class = {}
    setmetatable(class, self)
    class._super = self
    -- Inherit metamethods
    for k, v in pairs(self) do
        if k:match('^__') then
            class[k] = v
        end
    end
    class.__index = class
    class.__call = function(c, ...) return c:new(...) end -- Constructor shortcut
    return class
end

-- Abstract methods --

function Object:init(...) end

-- Global functions --

-- Check if an object is an instance of its prototype

function isinstance(obj, class)
    return getmetatable(obj) == class
end

