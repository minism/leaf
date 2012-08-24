--[[

#########################################################################
#                                                                       #
# color.lua                                                             #
#                                                                       #
# Love2D color functions                                                #
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

local ColorPalette = leaf.Object:extend()

function ColorPalette:init(colors)
    local colors = colors or {}
    for k, v in pairs(colors) do
        self:set(k, v)
    end
end

function ColorPalette:set(key, r, g, b)
    if type(r) == 'table' then
        r, g, b = unpack(r)
    end
    self[key] = function(alpha)
        love.graphics.setColor(r, g, b, alpha or 255)
    end
end

-- Exports
leaf.ColorPalette = ColorPalette
