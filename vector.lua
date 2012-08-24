--[[

#########################################################################
#                                                                       #
# vector.lua                                                            #
#                                                                       #
# 2D vector pure function                                               #
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

local sin, cos, sqrt = math.sin, math.cos, math.sqrt

local vector = {}


-- Convenience function, not for OO operations
function vector.new(x, y)
    local x = x or 0
    local y = y or 0
    return {x=x, y=y}
end

vector.__call = vector.new

function vector.translate(x, y, dx, dy)
    return x + dx, y + dy
end

function vector.rotate(x, y, theta)
    local rx = x * math.cos(theta) - y * math.sin(theta)
    local ry = x * math.sin(theta) + y * math.cos(theta)
    return rx, ry
end

function vector.scale(x, y, s)
    return x * s, y * s
end

function vector.length(x, y)
    return math.sqrt(x * x + y * y)
end

function vector.normalize(x, y)
    local len = vector.length(x, y)
    if len > 0 then
        return x / len, y / len
    end
    return x, y
end

function vector.perpendicular(x, y, right)
    if not right then
        return -y, x
    else
        return y, -x
    end
end


-- Namespace exports
leaf.vector = vector
