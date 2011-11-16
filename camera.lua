require 'leaf.object'

leaf.Camera = leaf.Object:extend()
local Camera = leaf.Camera

function Camera:init(target_func)
    if target_func then self:track(target_func) end
    self.pos = Point()
end

function Camera:track(target_func)
    self.target_func = target_func
end

function Camera:update(dt)
    self.pos.x, self.pos.y = self.target_func()
end

-- Sets up draw matrix to center the target given by self.target_func
-- If a Z is specified, the depth will be altered
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
