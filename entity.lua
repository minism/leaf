-- ++++++++++++++++++++++++++++++
-- + Leaf Entity Class          +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'
require 'leaf.vector'
require 'leaf.containers'
require 'leaf.console'

leaf.Entity = leaf.Object:extend('Entity')
local Entity = leaf.Entity

function Entity:init()
    self.position = leaf.Vector:new()
    self.children = leaf.List:new()
end

function Entity:addChild(entity)
    self.children:insert(entity)
end