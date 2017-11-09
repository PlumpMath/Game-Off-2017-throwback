local VW, VW2, VH, VH2
local carZ, carX, speed
local level, levelLength
local dx

function love.load(p)
	VW = love.graphics.getWidth()
	VH = love.graphics.getHeight()
	VW2 = 0.5 * VW
	VH2 = 0.5 * VH
	carX = 0
	carZ = 1
	speed = 0
	dx = 0
	level = loadLevel('level1')
	levelLength = table.getn(level) / 2
end

function love.update(dt)
	if carZ >= levelLength then
		return
	end
	local acc = 0
	local steer = 0
	local speedMax = 15
	local steerMax = 1000
	if love.keyboard.isDown('up') then
		acc = 1
	elseif love.keyboard.isDown('down') then
		acc = -1
	end
	if love.keyboard.isDown('left') then
		steer = -steerMax
	end
	if love.keyboard.isDown('right') then
		steer = steerMax
	end
	speed = clamp(speed + acc * dt, 0, speedMax)
	local speedPercent = speed / speedMax
	local offset = dt * speed * dx * dx
	carX = carX + steer * speedPercent * dt - offset
	carZ = carZ + speed * dt
end

function love.draw()
	love.graphics.scale(1, -1)
	love.graphics.translate(VW2, -VH)
	local di = math.floor(carZ)
	local ibegin = di
	local iend = 40 + di
	local y1, y2
	local sx0 = getSegment(di)
	local sx1 = getSegment(di + 1)
	local _, f = math.modf(carZ)
	dx = mix(sx0, sx1, smooth(f))
	for n = ibegin, iend, 1 do
		y1, y2 = drawSegment(n)
	end
	love.graphics.setColor(102, 153, 255)
	love.graphics.rectangle('fill', -VW2, y1, VW, VH - y2)
end

function smooth(a)
	return a * a * (3 - 2 * a)
end

function mix(a, b, f)
	return a * (1 - f) + b * f
end

function clamp(x, a, b)
	return math.min(math.max(x, a), b)
end

function loadLevel(name)
	return require(name)
end

function mapCoord(x, y, z)
	return x * 1 / (z + 1), (VH2 - y) * z / (z + 1)
end

function segmentColor(n)
	if n % 2 == 0 then
		return 96, 96, 96
	else
		return 105, 105, 105
	end
end

function grassColor(n)
	if n % 2 == 0 then
		return 0, 102, 34
	else
		return 0, 153, 51
	end
end

function getSegment(n)
	local x, y, z
	if n < levelLength then
		x = level[2 * n - 1]
		y = level[2 * n]
	else
		x = level[2 * levelLength - 1]
		y = level[2 * levelLength]
	end
	z = n - carZ
	return x, y, z
end

function drawSegment(n)
	local W = 500
	local sx, sy, sz = getSegment(n)
	local zx, zy, zz = getSegment(n + 1)
	local dsx = (n - carZ) * dx
	local dzx = (n + 1 - carZ) * dx
	local x1, y1 = mapCoord(sx - W - carX, sy, sz)
	local x2, y2 = mapCoord(zx - W - carX, zy, zz)
	local x3, y3 = mapCoord(zx + W - carX, zy, zz)
	local x4, y4 = mapCoord(sx + W - carX, sy, sz)
	love.graphics.setColor(segmentColor(n))
	love.graphics.polygon('fill',
		x1 + dsx, y1,
		x2 + dzx, y2,
		x3 + dzx, y3,
		x4 + dsx, y4
	)
	love.graphics.setColor(grassColor(n))
	love.graphics.polygon('fill',
		 x1 + dsx, y1,
		 x2 + dzx, y2,
		-VW2, y2,
		-VW2, y1
	)
	love.graphics.polygon('fill',
		x4 + dsx, y4,
		x3 + dzx, y3,
		VW2, y3,
		VW2, y4
	)
	return y3, y4
end
