-- ++++++++++++++++++++++++++++++
-- + Leaf Loader Module         +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

leaf.loader = {}
local loader = leaf.loader

--- This function does a shallow search through `dir` and creates new 
--- Love2D images for every image found.  Returns a table mapping filenames
--- To image objects.
function loader.loadImages(dir)
    local map = {}
	local files = love.filesystem.enumerate(dir)
	for key, val in ipairs(files) do
		basename = val
		path = dir .. '/' .. basename
		if love.filesystem.isFile(path) then
			map[basename] = love.graphics.newImage(path)
		end
	end
    return map
end

