-- ++++++++++++++++++++++++++++++
-- + Leaf Object Class          +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

leaf.Object = {}
local Object = leaf.Object

Object.__index = Object
Object.__call = function(c, ...) return c:new(...) end

--- Creates, initializes, and returns a new object
function Object:new(...)
	local obj = {}
	setmetatable(obj, self)
    if obj.init then obj:init(...) end
	return obj
end

--- Creates and returns a new class
function Object:extend(classname)
    local class = {}
    setmetatable(class, self)
    -- Inherit metamethods
    for k, v in pairs(self) do
        if k:match('^__') then
            class[k] = v
        end
    end
    class.__index = class
    class.__call = function(c, ...) return c:new(...) end -- Constructor shortcut
    return class
end

--- Returns the type name of the object
function Object:type()
    if type(self) == 'table' and self._type then
        return self._type
    else
        return type(self)
    end
end

----[[ Abstract methods ]]----

function Object:init(...) end
