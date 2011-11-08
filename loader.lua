--[[

#########################################################################
#                                                                       #
# loader.lua                                                            #
#                                                                       #
# Love2D filesystem loading functions                                   #
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
