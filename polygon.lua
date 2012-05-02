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

require 'leaf.object'

local Polygon = leaf.Object:extend()

-- Convex polygon --
function Polygon:init(...)
    if type(arg[1]) == 'table' then
        self:init(unpack(arg[1]))
    else
        for i, point in ipairs(arg) do
            table.insert(self, point)
        end
    end
end


-- Namespace exports
leaf.Polygon = Polygon
