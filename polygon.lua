-- ++++++++++++++++++++++++++++++
-- + Leaf Polygon Classes       +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'

leaf.Rect = leaf.Object:extend('Rect')
local Rect = leaf.Rect

function Rect:init(left, top, bottom, right)
	self.left = left or 0
	self.top = top or 0
	self.bottom = bottom or 0
	self.right = right or 0
end

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
