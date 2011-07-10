-- ++++++++++++++++++++++++++++++
-- + Leaf Camera Class          +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'
require 'leaf.vector'

leaf.camera = leaf.Object:new()
local camera = leaf.camera

camera.zoom 		= 1.0
camera.zoom_target	= 1.0
camera.zoom_speed 	= 1.15
camera.zoom_min 	= 0.2
camera.zoom_max 	= 5.0
camera.interp_alpha = 1.0

camera.position		= leaf.Vector:new()

-- This must be overrided to the tracking target vector object you want!
camera.target		= leaf.Vector:new()

function camera.update(dt)
	-- Linearly interpolate towards target zoom level
	if camera.interp_alpha < 1.0 then
		camera.interp_alpha = camera.interp_alpha + dt
		camera.zoom = camera.zoom + (camera.zoom_target - camera.zoom) * camera.interp_alpha
	else
		camera.zoom = camera.zoom_target
	end
	
	-- Center on target vector object
	camera.position.x = target.x - love.graphics.getWidth() * camera.zoom / 2.0
	camera.position.y = target.y - love.graphics.getHeight() * camera.zoom / 2.0
end

function camera.zoomin()
	-- Begin interpolating
	camera.interp_alpha = 0.0
	camera.zoom_target = camera.zoom_target / camera.zoom_speed
	if camera.zoom_target < camera.zoom_min then
		camera.zoom_target = camera.zoom_min
	end
end

function camera.zoomout()
	-- Begin interpolating
	camera.interp_alpha = 0.0
	camera.zoom_target = camera.zoom_target * camera.zoom_speed
	if camera.zoom_target > camera.zoom_max then
		camera.zoom_target = camera.zoom_max
	end
end