local intro = require("intro")
intro:init()

local shader = love.graphics.newShader(love.filesystem.read("vs.glsl"), love.filesystem.read("fs.glsl"))
local vertices = require("vertices")
local format = {
	{"VertexPosition", "float", 3},
	{"VertexTexCoord", "float", 2},
	{"VertexColor", "byte", 4}
}
local texture = love.graphics.newImage("dot.png")
local mesh = love.graphics.newMesh(format, vertices, "triangles", "static")
mesh:setTexture(texture)
local canvas = love.graphics.newCanvas()

local rotation = 0.0
local rotationV = 0
local zoom = 400.0
local zoomV = 0

function love.draw()
	love.graphics.setCanvas({canvas, depth=true})
	love.graphics.setShader(shader)
	love.graphics.setDepthMode("less", true)
	love.graphics.clear()	
	
	shader:send("rotation", rotation)
	shader:send("screenSize", {love.graphics.getWidth()*love.graphics.getDPIScale(), love.graphics.getHeight()*love.graphics.getDPIScale()})
	shader:send("zoom", zoom)
	love.graphics.draw(mesh)

	love.graphics.setShader()
	love.graphics.setCanvas()

	love.graphics.draw(canvas)
	intro:draw()
end

function love.update(dt)
	-- rotation = rotation + dt
	zoom = zoom + zoomV
	zoomV = zoomV * 0.5

	rotation = rotation + rotationV
	rotationV = rotationV * 0.5

	intro:update()
end

function love.resize(w, h)
	canvas = love.graphics.newCanvas()
end

function love.wheelmoved(x, y)
	zoomV = zoomV + y*3
	rotationV = rotationV - x/math.pi*0.15
end