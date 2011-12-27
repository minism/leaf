--[[

#########################################################################
#                                                                       #
# camera.lua                                                            #
#                                                                       #
# Simple Love2D camera class                                            #
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

leaf.Camera = leaf.Object:extend()
local Camera = leaf.Camera

function Camera:init(target_func)
    if target_func then self:track(target_func) end
    self.pos = Point()
end

function Camera:track(target_func)
    assert(type(target_func) == 'function')
    self.target_func = target_func
end

function Camera:update(dt)
    self.pos.x, self.pos.y = self.target_func()
end

-- Sets up matrix to center the active target
-- If a Z parameter is specified, it is considered a depth factor relative to the target
-- e.g., if z = 2.0, objects will appear 2x as close as the target
function Camera:push(z)
    -- Default to 1, which is the plane of the target
    local z = z or 1

    -- Push stack
    love.graphics.push()

    -- Center on target, offset depth by Z
    love.graphics.translate(z * (-self.pos.x + love.graphics.getWidth() / 2), 
                            z * (-self.pos.y + love.graphics.getHeight() / 2))
end

function Camera:pop()
    love.graphics.pop()
end
