--[[

#########################################################################
#                                                                       #
# context.lua                                                           #
#                                                                       #
# Top-level gamestate object helper.                                    #
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

-- Context class, represents a running state with input/update/draw
local Context = leaf.Object:extend()


-- Global app object, for usage in main.lua
local app = { cstack = leaf.Stack() }

-- Push a context to the front of the screen
function app.pushContext(context)
    app.cstack:push(context)
end

-- Pop the outermost context
function app.popContext()
    app.cstack:pop()
end

-- Swaps the outermost context for a new one, or pushes if the stack is empty
function app.swapContext(context)
    if app.cstack:isEmpty() then
        app.cstack:push(context)
    else
        app.cstack[#app.cstack] = context
    end
end

-- Bind all love callbacks to context stack
function app.bindLove()
    for i, func in ipairs{'update', 'keypressed', 'mousepressed', 'mousereleased', 'quit'} do
        love[func] = function (...)
            for i, context in ipairs(app.cstack) do
                if context[func] and type(context[func] == 'function') then context[func](...) end
            end
        end
    end
    -- Draw callback is ran in reverse order
    love.draw = function (...)
        for i = #app.cstack, 1 do
            local context = app.cstack[i]
            if context.draw and type(context.draw == 'function') then context.draw(...) end
        end
    end
end


-- Namespace exports
leaf.Context = Context
leaf.app = app