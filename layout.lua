-- ++++++++++++++++++++++++++++++
-- + Leaf Layout Module         +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'math'

------------------------------------------------------------------
-- These utility functions act like iterators, providing a lazy
-- list of x, y positions for layout items, given some parameters

-- The general format of layout function parameters is the following:
-- container:Rect, item:Rect, spacing: number, padding?:number, padding-top?: number
------------------------------------------------------------------

leaf.layout = {}
local layout = leaf.layout

function layout.gridLayout(container, item, spacing, padding, padding_vert)
	-- Initialize
	spacing = spacing or 0
	local padding_horz = padding or spacing
	if not padding_vert then
		padding_vert = padding_horz
	end
	local cw = container:getWidth()
	local ch = container:getHeight()
	local iw = item:getWidth()
	local ih = item:getHeight()
	
	-- Determine number of columns in grid
	local cols = math.floor((cw - padding_horz) / (iw + spacing))

	-- Create lazy iterator that returns x, y for each item
	local count = 0
	return function()
		local x = padding_horz + (spacing + iw) * count
		local y = padding_vert + (spacing * ih) * math.floor(count / cols)
		count = count + 1
		return x, y, count
	end
end
