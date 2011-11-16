require 'leaf.object'
require 'leaf.containers'

-- Console message --
local Message = leaf.Object:extend()

function Message:init(data, err)
    self.data = data
    self.err = err and true or false
end


-- Console -- 
leaf.Console = leaf.Object:extend()
local Console = leaf.Console

function Console:init(max)
    local max = max or 500
    self.font = love.graphics.newFont(10)
    self.queue = leaf.Queue(max)
end

function Console:write(data)
    local message = Message(data)
    self.queue:push(message)
end

function Console:err(data)
    local message = Message(data, true)
    self.queue:push(message)
end

function Console:draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    local padding = 10
    love.graphics.setFont(self.font)
    for i, message in self.queue:iter() do
        love.graphics.printf(message.data, padding, 
                             height - padding - i * self.font:getHeight(), 
                             width, 'left')
    end
end

