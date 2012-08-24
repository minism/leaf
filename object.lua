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

-- Constructor shortcut to allocate and initialize an object
local function constructor(class, ...)
    local obj = class:new()
    if obj.init then obj:init(...) end
    return obj
end

-- Setup base object
local Object = { __call = constructor }
Object.__index = Object

-- Allocate a new object
function Object:new(...)
    local obj = {}
    setmetatable(obj, self)
    return obj
end

-- Creates and returns a new class
function Object:extend(t)
    local class = t or {}
    setmetatable(class, self)
    -- Inherit metamethods
    for k, v in pairs(self) do
        if k:match('^__') then
            class[k] = v
        end
    end
    class.__call = constructor
    class.__index = class
    return class
end

-- Namespace exports
leaf.Object = Object
