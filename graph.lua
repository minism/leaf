-- ++++++++++++++++++++++++++++++
-- + Leaf Scene Graph Class     +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

-- Each node has a local x coordinate, y coordinate, rotation, and scale
-- NOTE: Rotation not yet supported for queries!!!  Use at your own risk

require 'leaf.object'
require 'leaf.group'

leaf.SceneNode = leaf.Object:extend('SceneNode')
local SceneNode = leaf.SceneNode

function SceneNode:init(parent, x, y, r, s)
    self.x = x or 0
    self.y = y or 0
    self.r = r or 0
    self.s = s or 1

    -- Tree structure: no parent means root, no child means leaf
    self.parent = parent or nil
    self.children = leaf.Group:new()
end

--- Create a child node
function SceneNode:addChild(x, y, r, s)
    return self.children.insert(SceneNode(self, x, y, r, s))
end

--- Graphics transformation methods
--- Note these are SHALLOW and not DEEP, you need to push for each level
function SceneNode:push()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.r)
    love.graphics.scale(self.s, self.s)
end

function SceneNode:pop()
    love.graphics.pop()
end

--- Query methods
--- Note these are DEEP and not SHALLOW
function SceneNode:toGlobal(x, y)
    local gx, gy = x, y
    local parent = self.parent
    while parent ~= nil do
        gx = gx + parent.x
        gy = gy + parent.y
        parent = parent.parent
    end
    return gx + self.x, gy + self.y
end

function SceneNode:toLocal(x, y)
    local lx, ly = x, y
    local parent = self.parent
    while parent ~= nil do
        lx = lx - parent.x
        ly = ly - parent.y
        parent = parent.parent
    end
    return lx - self.x, ly - self.y
end

--- Transformation
function SceneNode:translate(x, y)
    self.x = self.x + x
    self.y = self.y + y
end

function SceneNode:rotate(r)
    self.r = self.r + r
end

function SceneNode:scale(s)
    self.s = self.s * s
end