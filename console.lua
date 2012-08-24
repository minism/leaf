--[[

#########################################################################
#                                                                       #
# console.lua                                                           #
#                                                                       #
# Love2D in-game console                                                #
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
require 'leaf.containers'
require 'leaf.context'

-- Default settings --
local HISTORY = 2000
local PADDING = 10


-- Console message --
local Message = leaf.Object:extend()

function Message:init(data, err)
    self.data = data
    self.err = err and true or false
end


-- Console -- 
local Console = leaf.Context:extend()

function Console:init()
    self.font = love.graphics.newFont(10)
    self.queue = leaf.Queue(HISTORY)
end

function Console:write(data)
    local message = Message(data)
    self.queue:push(message)
end

function Console:error(data)
    local message = Message(data, true)
    self.queue:push(message)
end

function Console:draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle('fill', 0, 0, width, height)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(self.font)
    for i, message in self.queue:iter_reverse() do
        love.graphics.printf(message.data, PADDING, 
                             height - PADDING - i * self.font:getHeight(), 
                             width, 'left')
    end
end

-- Namespace exports
leaf.Console = Console
