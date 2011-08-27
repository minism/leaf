-- +++++++++++++++++++++++++++++++++
-- + Leaf Love2D Utility Library   +
-- + Copyright 2011 Josh Bothun    +
-- + joshbothun@gmail.com          +
-- + minornine.com                 +
-- +++++++++++++++++++++++++++++++++

-- Usage: put the 'leaf' directory at the same level as your lua file and require 'leaf'

-- Namespace
leaf = {}

----[[ Modules ]]----
require 'leaf.object'
require 'leaf.containers'
require 'leaf.group'
require 'leaf.console'
require 'leaf.time'
require 'leaf.vector'
require 'leaf.polygon'
require 'leaf.layout'
require 'leaf.camera'
require 'leaf.loader'
require 'leaf.utils'

--- Imports every name into the global namespace, use with caution
function leaf.import()
    for key, val in pairs(leaf) do
        _G[key] = val
    end
end
