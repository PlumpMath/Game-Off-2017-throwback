local VW, VW2, VH, VH2
local roadWidthNear, roadWidthFar

function love.load()
	VW = love.graphics.getWidth()
	VH = love.graphics.getHeight()
	VW2 = 0.5 * VW
	VH2 = 0.5 * VH
	roadWidthNear = VW * 0.96
	roadWidthFar = roadWidthNear * 0.2
end

function love.draw()
	love.graphics.scale(1, -1)
	love.graphics.translate(VW2, -VH)
	love.graphics.setColor(102, 153, 255)
	love.graphics.rectangle('fill', -VW2, VH2, VW, VH2)
	love.graphics.setColor(0, 153, 51)
	love.graphics.rectangle('fill', -VW2, 0, VW, VH2)
	drawSegment(0)
end

function drawSegment(z)
	love.graphics.setColor(96, 96, 96)
	love.graphics.polygon('fill',
		-0.5 * roadWidthNear, 0,
		-0.5 * roadWidthFar, VH2,
		 0.5 * roadWidthFar, VH2,
		 0.5 * roadWidthNear, 0
	)
end
