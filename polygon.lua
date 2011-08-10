-- ++++++++++++++++++++++++++++++
-- + Leaf Polygon Classes       +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'

leaf.Rect = leaf.Object:extend('Rect')
local Rect = leaf.Rect

function Rect:init(v1, v2, v3, v4)
    -- If only two values passed, assume right and bottom
    if v3 == nil or v4 == nil then
        self.left = 0
        self.top = 0
        self.right = v1
        self.bottom = v2
    else
	    self.left = v1 or 0
	    self.top = v2 or 0
	    self.bottom = v3 or 0
	    self.right = v4 or 0
    end
end

function Rect:getWidth()	return self.right - self.left 	end
function Rect:getHeight()	return self.bottom - self.top	end

function Rect:contains(arg1, arg2)
	if arg2 == nil then
		-- Assume arg1 is an object with x and y fields
		if arg1.x and arg1.y then
			return self:contains(arg1.x, arg1.y)
		else
			return false
		end
	elseif  arg1 >= self.left and
			arg1 <= self.right and
			arg2 >= self.top and
			arg2 <= self.bottom then 
				return true		
	end
	return false
end

function Rect:intersects(rect)
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
end
