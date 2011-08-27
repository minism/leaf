-- ++++++++++++++++++++++++++++++
-- + Leaf Object Class          +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

leaf.Object = {}
local Object = leaf.Object

Object._class = 'Object'
Object.__index = Object
Object.__call = function(c, ...) return c:new(...) end

--- Creates, initializes, and returns a new object
function Object:new(...)
	local obj = {}
	setmetatable(obj, self)
	obj._type = self._class 
	obj:init(...)
	return obj
end

--- Creates and returns a new class
function Object:extend(classname)
    local class = {}
    setmetatable(class, self)
    class.__index = class
    class.__call = function(c, ...) return c:new(...) end
    class._type = '<CLASS> ' .. classname
    class._class = classname or '<UNNAMED>'
    return class
end

--- Returns the type name of the object
function Object:type()
    if type(self) == 'table' and self._type then
        return self._type
    else
        return type(obj)
    end
end
    
----[[ Abstract methods ]]----

function Object:init(...) end
