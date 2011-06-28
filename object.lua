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

--- Creates, initializes, and returns a new object
function Object:new(...)
	local obj = {}
	setmetatable(obj, self)
	obj._type = self._class 
	obj:init(unpack(arg))
	return obj
end

--- Creates and returns a new class
function Object:extend(classname)
    local class = {}
    setmetatable(class, self)
    self.__index = self
    class._type = '<CLASS> ' .. classname
    class._class = classname or '<UNNAMED>'
    return class
end

--- Returns the class name of the object
function Object:type()
    if type(self) == 'table' then
        return self._type
    else
        return type(obj)
    end
end
    
----[[ Abstract methods ]]----

function Object:init(...) end
