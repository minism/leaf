--[[

#########################################################################
#                                                                       #
# rect.lua                                                              #
#                                                                       #
# 2D Rectangle class                                                    #
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

local Rect = leaf.Object:extend()

function Rect:init(v1, v2, v3, v4)
    -- If only two values passed, assume right and bottom
    if v3 == nil or v4 == nil then
        self.left = 0
        self.top = 0
        self.right = v1 or 0
        self.bottom = v2 or 0
    else
        self.left = v1 or 0
        self.top = v2 or 0
        self.right = v3 or 0
        self.bottom = v4 or 0
    end
end

-- Member alias behavior

local aliases =
{
    x1 = 'left',
    y1 = 'top',
    x2 = 'right',
    y2 = 'bottom',
}

function Rect:__index(key)
    if aliases[key] ~= nil then
        return self[aliases[key]]
    else
        return Rect[key]
    end
end

local function assert_rects(a, b)
    assert(isinstance(a, Rect) and isinstance(b, Rect), "Operands must be Rects.")
end

function Rect.__mul(a, b)
    if type(a) == 'number' then
        assert(isinstance(b, Rect), "Operands must be numbers or Rects.")
        return Rect(b.left, b.top, b.left + b:w() * a, b.top + b:h() * a)
    else
        assert(isinstance(a, Rect) and type(b) == 'number', "Operands must be numbers or Rects.")
        return Rect(a.left, a.top, a.left + a:w() * b, a.top + a:h() * b)
    end
end

function Rect.__div(a, b)
    assert(isinstance(a, Rect) and type(b) == 'number', "Can only divide a Rect by a number.")
    return Rect(a.left / b, a.top / b, a.right / b, a.bottom / b)
end

function Rect.__eq(a, b)
    assert_rects(a, b)
    return a.left == b.left and a.top == b.top and a.right == b.right and a.bottom == b.bottom
end

function Rect.__lt(a, b)
    assert_rects(a, b)
    return a:area() < b:area()
end

function Rect.__lte(a, b)
    assert_rects(a, b)
    return a:area() <= b:area()
end

function Rect.__gt(a, b)
    assert_rects(a, b)
    return a:area() > b:area()
end

function Rect.__gte(a, b)
    assert_rects(a, b)
    return a:area() >= b:area()
end

function Rect:__tostring()
    return "(" .. self.left .. "," .. self.top ..
           "," .. self.right .. "," .. self.bottom .. ")"
end

function Rect:reset()
    self.left, self.top, self.right, self.bottom = 0, 0, 0, 0
    return self
end

function Rect:copy()
    return Rect(self.left, self.top, self.right, self.bottom)
end

function Rect:unpack()
    return self.left, self.top, self:w(), self:h()
end

function Rect:w()   return self.right - self.left   end
function Rect:h()   return self.bottom - self.top   end
Rect.width, Rect.height = Rect.w, Rect.h

function Rect:area()
    return self:w() * self:h()
end

function Rect:center()
    return self.left + self:w() / 2, self.top + self:h() / 2
end

-- Check if rect contains an object or a point
function Rect:contains(arg1, arg2)
    if arg2 == nil then
        -- Assume arg1 is an object with x and y fields
        assert(arg1.x ~= nil and arg1.y ~= nil, "Object being queried must contain 'x' and 'y' fields.")
        return self:contains(arg1.x, arg1.y)
    elseif  arg1 >= self.left and
            arg1 <= self.right and
            arg2 >= self.top and
            arg2 <= self.bottom then 
                return true     
    end
    return false
end

-- Check if rect intersects with another rect
function Rect:intersects(rect)
    assert_rects(self, rect)
    if rect.left >= self.left and rect.left <= self.right then
        if rect.top >= self.top and rect.top <= self.bottom then
            return true
        elseif rect.bottom >= self.top and rect.bottom <= self.bottom then
            return true
        end
    elseif rect.right >= self.left and rect.right >= self.right then
        if rect.top >= self.top and rect.top <= self.bottom then
            return true
        elseif rect.bottom >= self.top and rect.bottom <= self.bottom then
            return true
        end
    end
    return false
end

function Rect:translate(x, y)
    self.left = self.left + x
    self.top = self.top + y
    self.right = self.right + x
    self.bottom = self.bottom + y
    return self
end

function Rect:translated(x, y)
    return self:copy():translate(x, y)
end

function Rect:moveTo(x, y)
    local w = self:w()
    local h = self:h()
    self.left = x
    self.top = y
    self.right = x + w
    self.bottom = y + h
    return self
end

-- Set the coordinates of the rect to another rect, or to a list of coordinates
function Rect:set(left, top, bottom, right)
    if (isinstance(left, Rect)) then
        local r = left
        self.left = r.left
        self.top = r.top
        self.bottom = r.bottom
        self.right = r.right
    else
        self.left = left
        self.top = top
        self.bottom = bottom
        self.right = right
    end
end

-- Scale the rectangle from its center instead of the corner
function Rect:centerScale(amt)
    local w = self:w()
    local h = self:h()
    local l = self.left
    local t = self.top
    self.left   = l + self:w() * (1 - amt) / 2
    self.top    = t + self:h() * (1 - amt) / 2
    self.right  = l + self:w() * (1 + amt) / 2
    self.bottom = t + self:h() * (1 + amt) / 2
    return self
end


-- Namespace exports
leaf.Rect = Rect
