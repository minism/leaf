-- ++++++++++++++++++++++++++++++
-- + Leaf Container Classes     +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'

local _Node = leaf.Object:extend('_Node')

----[[ Linked List ]]----

function _Node:init(value)
    self.value = value
    self.prev = nil
    self.next = nil
end

leaf.List = leaf.Object:extend('List')
local List = leaf.List

function List:init()
    self.head = nil
    self.tail = nil
end

--- Insert an arbitrary object into the list 
function List:insert(obj)
    local node = _Node:new(obj)
    if not self.tail then
        self.head = node
        self.tail = node
    else
        node.prev = self.tail
        self.tail.next = node
        self.tail = node
    end
    return true
end


--- Remove an object from the list by table pointer comparison
function List:remove(obj)
    for item in self:_iterNodes() do
        if obj == item.value then
            -- Check for edge cases first
            if item == self.head then
                self.head = self.head.next
                self.head.prev = nil
            elseif item == self.tail then
                self.tail = self.tail.prev
                self.tail.next = nil
            else
                item.prev.next = item.next
                item.next.prev = item.prev
                item = nil
            end
        end
    end
    return false
end

--- Iterator function for list objects
function List:iter()
    local curr = self.head
    return function()
        if curr then
            temp = curr
            curr = curr.next
            return temp.value
        else
            return nil
        end
    end
end

--- Iterator function for list node objects, used internally
function List:_iterNodes()
    local curr = self.head
    return function()
        if curr then
            temp = curr
            curr = curr.next
            return temp
        else
            return nil
        end
    end
end

--- Return size of list
function List:size()
	local count = 0
	for _ in self:iter() do
		count = count + 1
	end
	return count
end

----[[ Queue ]]----

leaf.Queue = leaf.Object:extend('Queue')
local Queue = leaf.Queue

function Queue:init()
    self.front = 0
    self.back = -1
	self.max = -1
end

function Queue:push(val)
    self.back = self.back + 1
    self[self.back] = val
	if self.max > 0 and self.back - self.front > self.max then
		self:pop()
	end
end

function Queue:pop()
    if self.back < self.front then error('Error: Queue empty') end
    local val = self[self.front]
    self[self.front] = nil
    self.front = self.front + 1
    return val
end

function Queue:isEmpty()
	return self.back > self.front
end
