--[[

#########################################################################
#                                                                       #
# polygon.lua                                                           #
#                                                                       #
# Generic 2D polygon class                                              #
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

require 'math'

require 'leaf.object'
require 'leaf.vector'

local vector = leaf.vector

local Polygon = leaf.Object:extend()

-- Convex polygon --
function Polygon:init(...)
    if type(arg[1]) == 'table' then
        return self:init(unpack(arg[1]))
    end

    -- Add initial points from args
    for i=1, math.max(#arg, 6), 2 do
        local x, y = arg[i], arg[i+1]
        self:addPoint(x or 0, y or 0)
        table.insert(self, point)
    end
end

-- Add a new point to the polygon
function Polygon:addPoint(x, y)
    table.insert(self, x)
    table.insert(self, y)
end

-- Remove a point from the polygon, defaults to last point
function Polygon:removePoint(i)
    local npoints = self:numPoints()
    if npoints <= 3 then
        return nil
    end
    local i = i or npoints
    local x = table.remove(self, i * 2 - 1)
    local y = table.remove(self, i * 2 - 1)
    return x, y
end

function Polygon:numPoints()
    return math.floor(#self / 2)
end


-- Namespace exports
leaf.Polygon = Polygon
