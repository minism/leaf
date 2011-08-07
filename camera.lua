-- ++++++++++++++++++++++++++++++
-- + Leaf Camera Class          +
-- + Copyright 2011 Josh Bothun +
-- + joshbothun@gmail.com       +
-- + minornine.com              +
-- ++++++++++++++++++++++++++++++

require 'leaf.object'
require 'leaf.vector'
require 'leaf.time'

leaf.camera = leaf.Object:new()
local camera = leaf.camera

camera.zoom 		= 1.0
camera.zoom_speed 	= 1.15
camera.zoom_min 	= 0.2
camera.zoom_max 	= 5.0

camera.pos			= leaf.Vector:new()

-- This must be overrided to the tracking target vector object you want!
camera.target		= leaf.Vector:new()

--- Pass a vector table, or any table with 'x' and 'y' fields, for the camera to track
function camera.track(target)
	camera.target = target
end

--- Apply the cameras settings to the transformation stack
function camera.apply()
	love.graphics.translate(-camera.pos.x / camera.zoom, -camera.pos.y / camera.zoom)
	love.graphics.scale(1.0 / camera.zoom,1.0 / camera.zoom)
end

--- Must be called in main loop
function camera.update(dt)
	-- Center camera position on target table's x and y fields
	camera.pos.x = camera.target.x - love.graphics.getWidth() * camera.zoom / 2.0
	camera.pos.y = camera.target.y - love.graphics.getHeight() * camera.zoom / 2.0
end

function camera.zoomIn()
	time.interp(camera.zoom_speed, {
                    table=camera,
                    key='zoom',
                    startval=camera.zoom,
                    endval=camera.zoom / camera.zoom_speed
                })
end

function camera.zoomOut()
	time.interp(camera.zoom_speed, {
                    table=camera,
                    key='zoom',
                    startval=camera.zoom,
                    endval=camera.zoom * camera.zoom_speed
                })
end
