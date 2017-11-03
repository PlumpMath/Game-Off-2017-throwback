local VW, VW2, VH, VH2

function love.load()
	VW = love.graphics.getWidth()
	VH = love.graphics.getHeight()
	VW2 = 0.5 * VW
	VH2 = 0.5 * VH
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

function mapCoord(x, y, z)
	return x * 1 / (z + 1), (VH2 - y) * z / (z + 1)
end

function drawSegment(z)
	for n = 0, 100, 2 do
		love.graphics.setColor(96, 96, 96)
		local x1, y1 = mapCoord(-400, 0, n)
		local x2, y2 = mapCoord(-400, 0, n + 1)
		local x3, y3 = mapCoord( 400, 0, n + 1)
		local x4, y4 = mapCoord( 400, 0, n)
		love.graphics.polygon('fill',
			x1, y1,
			x2, y2,
			x3, y3,
			x4, y4
		)
		love.graphics.setColor(105, 105, 105)
		local x1, y1 = mapCoord(-400, 0, n + 1)
		local x2, y2 = mapCoord(-400, 0, n + 2)
		local x3, y3 = mapCoord( 400, 0, n + 2)
		local x4, y4 = mapCoord( 400, 0, n + 1)
		love.graphics.polygon('fill',
			x1, y1,
			x2, y2,
			x3, y3,
			x4, y4
		)
	end
end
