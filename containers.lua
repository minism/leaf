--[[

#########################################################################
#                                                                       #
# containers.lua                                                        #
#                                                                       #
# Various container classes                                             #
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


-- Linked List --
local _ListNode = leaf.Object:extend()

function _ListNode:init(value)
    self.value = value
    self.prev = nil
    self.next = nil
end

leaf.List = leaf.Object:extend()
local List = leaf.List

function List:init()
    self.head = nil
    self.tail = nil
end

function List:clear()
    self.head = nil
    self.tail = nil
end

-- Insert an object into the list 
function List:insert(obj)
    local node = _ListNode(obj)
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

-- Remove an object from the list by table pointer comparison
function List:remove(obj)
    for item in self:_iterNodes() do
        if obj == item.value then
            -- Check for edge cases first
            if item == self.head then
                if self.head.next then
                    self.head = self.head.next
                    self.head.prev = nil
                else
                    self.head = nil
                end
            elseif item == self.tail then
                if self.tail.prev then
                    self.tail = self.tail.prev
                    self.tail.next = nil
                else
                    self.tail = nil
                end
            else
                item.prev.next = item.next
                item.next.prev = item.prev
                item = nil
            end
        end
    end
    return false
end

-- Iterator function for list objects
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

-- Iterator function for list node objects, used internally
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
function List:len()
    local count = 0
    for _ in self:iter() do
        count = count + 1
    end
    return count
end


-- Set --
leaf.Set = leaf.Object:extend()
local Set = leaf.Set

function Set:init(...)
    self.set = {}
    local items = arg
    if type(arg[1]) == 'table' then
        items = arg[1]
    end
    for i, val in ipairs(items) do
        self.set[val] = true
    end
end

function Set:insert(obj)
    self.set[obj] = true
end

function Set:remove(obj)
    self.set[obj] = nil
end

function Set:contains(obj)
    if self.set[obj] then return true else return false end
end

function Set:iter()
    return pairs(self.set)
end


-- Stack --

-- No iter required, as we can use ipairs() effectively
leaf.Stack = leaf.Object:extend()
local Stack = leaf.Stack

function Stack:init(max)
    self.max = max or -1
end

function Stack:clear()
    local n = #self
    for i = 1, n do
        table.remove(self)
    end
end

function Stack:push(obj)
    if self.max >= 0 and #self < self.max then
       table.insert(self, obj)
    end
end

function Stack:pop()
    return table.remove(self)
end

function Stack:peek()
    return self[#self]
end

function Stack:isEmpty()
    return #self == 0
end
    

-- Queue --
leaf.Queue = leaf.Object:extend('Queue')
local Queue = leaf.Queue

function Queue:init(max)
    self.max = max or -1
    self.front = 0
    self.back = 0
end

-- Clear queue by pointer movement -- references may still exist in table
function Queue:clear()
    self.front = 0 
    self.back = 0
end

-- Array addressing
function Queue:get(i)
    return self[self.front + i - 1]
end

function Queue:len()
    return self.back - self.front
end

function Queue:push(val)
    self[self.back] = val
    self.back = self.back + 1
    -- Adjust front pointer if we overflowed
    if self.max >= 0 and self:len() > self.max then
        self.front = self.front + 1
    end
end

function Queue:pop()
    if self:isEmpty() then return nil end
    local val = self[self.front]
    self[self.front] = nil
    self.front = self.front + 1
    return val
end

function Queue:peekFront()
    return self[self.front]
end

function Queue:peekBack()
    return self[self.back]
end

function Queue:iter()
    local i = self.front
    local count = 0
    return function()
        if self[i] then
            local val = self[i]
            i = i + 1
            count = count + 1
            return count, val
        else
            return nil
        end
    end
end

function Queue:isEmpty()
    return self.back <= self.front
end
