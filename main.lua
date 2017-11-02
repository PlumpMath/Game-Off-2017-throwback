local VW, VH, VH2
local roadWidthNear, roadWidthFar

function love.load()
	VW = love.graphics.getWidth()
	VH = love.graphics.getHeight()
	VH2 = 0.5 * VH
	roadWidthNear = VW * 0.96
	roadWidthFar = roadWidthNear * 0.2
end

function love.draw()
	love.graphics.setColor(102, 153, 255)
	love.graphics.rectangle('fill', 0, 0, VW, VH2)
	love.graphics.setColor(0, 153, 51)
	love.graphics.rectangle('fill', 0, VH2, VW, VH2)
	drawSegment(0)
end

function drawSegment(z)
	love.graphics.setColor(96, 96, 96)
	love.graphics.polygon('fill',
		0.5 * (VW - roadWidthNear), VH,
		0.5 * (VW - roadWidthFar), VH2,
		0.5 * (VW - roadWidthFar) + roadWidthFar, VH2,
		0.5 * (VW - roadWidthNear) + roadWidthNear, VH
	)
end
