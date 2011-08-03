-- ++++++++++++++++++++++++++++++
-- + Leaf Camera Class          +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'
require 'leaf.vector'
require 'leaf.timer'

leaf.camera = leaf.Object:new()
local camera = leaf.camera

camera.zoom 		= 1.0
camera.zoom_speed 	= 1.15
camera.zoom_min 	= 0.2
camera.zoom_max 	= 5.0

camera.position		= leaf.Vector:new()

-- This must be overrided to the tracking target vector object you want!
camera.target		= leaf.Vector:new()

--- Pass a vector table, or any table with 'x' and 'y' fields, for the camera to track
function camera.track(target)
	camera.target = target
end

--- Must be called in main loop
function camera.update(dt)
	-- Center camera position on target table's x and y fields
	camera.position.x = target.x - love.graphics.getWidth() * camera.zoom / 2.0
	camera.position.y = target.y - love.graphics.getHeight() * camera.zoom / 2.0
end

function camera.zoomIn()
	-- Create an interpolator to zoom in
	local startval = camera.zoom
	local endval = camera.zoom / camera.zoom_speed
	time.interp(camera.zoom_speed, 
				function (alpha)
					camera.zoom = startval + alpha * (endval - startval)
				end)
end

function camera.zoomOut()
	-- Create an interpolator to zoom out
	local startval = camera.zoom
	local endval = camera.zoom * camera.zoom_speed
	time.interp(camera.zoom_speed, 
				function (alpha)
					camera.zoom = startval + alpha * (endval - startval)
				end)
end
