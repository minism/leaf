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
require 'leaf.vector'
require 'leaf.rect'

leaf.Camera = leaf.Object:extend()
local Camera = leaf.Camera

function Camera:init(target_func)
    if target_func then self:track(target_func) end
    -- Camera "position" represented by top left corner
    self.pos = Point()
end

function Camera:track(target_func)
    assert(type(target_func) == 'function')
    self.target_func = target_func
end

function Camera:update(dt)
    local x, y = self.target_func() 
    self.pos.x = x - love.graphics.getWidth() / 2
    self.pos.y = y - love.graphics.getHeight() / 2
end

-- Sets up matrix to center the active target
-- If a Z parameter is specified, it is considered a depth factor relative to the target
-- e.g., if z = 2.0, objects will appear 2x as close as the target
function Camera:push(z)
    -- Default to 1, which is the plane of the target
    local z = z or 1

    -- Use builtin matrix
    love.graphics.push()

    -- Center on target, offset depth by Z
    love.graphics.translate(z * -self.pos.x, z * -self.pos.y)
end

function Camera:pop()
    love.graphics.pop()
end

-- Convert a vector in screen space to world space.
-- ("World space" means the coordinate space of the camera's target)
function Camera:toWorld(x, y)
    if isinstance(x, leaf.Vector) then
        return x:translated(self.pos.x, self.pos.y)
    else
        return x + self.pos.x, y + self.pos.y
    end
end

-- Convert a vector in world space to screen space.
-- ("World space" means the coordinate space of the camera's target)
function Camera:toScreen(x, y)
    if isinstance(x, leaf.Vector) then
        return x:translated(-self.pos.x, -self.pos.y)
    else
        return x - self.pos.x, y - self.pos.y
    end
end

-- Return a leaf.Rect representing the viewable world coordinates
function Camera:getClip()
    return leaf.Rect(self.pos.x, self.pos.y, 
                self.pos.x + love.graphics.getWidth(), 
                self.pos.y + love.graphics.getHeight())
end

