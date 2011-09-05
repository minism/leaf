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
        self.right = v1 or 0
        self.bottom = v2 or 0
    else
	    self.left = v1 or 0
	    self.top = v2 or 0
	    self.right = v3 or 0
	    self.bottom = v4 or 0
    end
end

function Rect:w()	return self.right - self.left 	end
function Rect:h()	return self.bottom - self.top	end
Rect.getWidth, Rect.getHeight = Rect.w, Rect.h

function Rect:center()
    return self.left + self:w() / 2, self.top + self:h() / 2
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

function Rect:translate(x, y)
    return Rect(self.left + x,
                self.top + y,
                self.right + x,
                self.bottom + y)
end

function Rect:moveTo(x, y)
    return Rect(x, y, x + self:w(), y + self:h())
end

function Rect:scale(s, type_)
    local type_ = type_ or 'corner'
    if type_ == 'corner' then
        return Rect(self.left,
                    self.top,
                    self.left + self:w() * s,
                    self.top  + self:h() * s)
    elseif type_ == 'center' then
        return Rect(self.left + self:w() * (1 - s) / 2,
                    self.top  + self:h() * (1 - s) / 2,
                    self.left + self:w() * (1 + s) / 2,
                    self.top  + self:h() * (1 + s) / 2)
    else
        return Rect()
    end
end

function Rect:unpack(type_)
    type_ = type_ or 'corner'
    if type_ == 'corner' then
        return self.left, self.top, self:w(), self:h()
    elseif type_ == 'corners' then
        return self.left, self.top, self.right, self.bottom
    else
        return Rect()
    end
end
