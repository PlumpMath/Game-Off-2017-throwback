local VW, VH, VH2

function love.load()
	VW = love.graphics.getWidth()
	VH = love.graphics.getHeight()
	VH2 = 0.5 * VH
end

function love.draw()
	love.graphics.setColor(102, 153, 255)
	love.graphics.rectangle('fill', 0, 0, VW, VH2)
	love.graphics.setColor(0, 153, 51)
	love.graphics.rectangle('fill', 0, VH2, VW, VH2)
end
