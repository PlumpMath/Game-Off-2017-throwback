local VW, VW2, VH, VH2
local carZ, carX, speed
local curves, hills, curvesLength, hillsLength, levelLength
local dx
local roadSize = 500
local roadSegments = 40
local laneMarkerSize = 25

function love.load(p)
	VW = love.graphics.getWidth()
	VH = love.graphics.getHeight()
	VW2 = 0.5 * VW
	VH2 = 0.5 * VH
	carX = 0
	carZ = 1
	speed = 0
	dx = 0
	loadLevel('level1')
end

function love.keypressed(key, scancode, isRepeat)
	if isRepeat == false then
		if key == 'kp0' then
			carZ = 1
			speed = 0
		elseif key == 'kp+' then
			carZ = carZ + 1
		elseif key == 'kp-' then
			carZ = carZ - 1
		end
	end
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
		acc = accFunc(speed)
	elseif love.keyboard.isDown('down') then
		acc = -2
	end
	if love.keyboard.isDown('left') then
		steer = -steerMax
	end
	if love.keyboard.isDown('right') then
		steer = steerMax
	end
	if math.abs(carX) >= roadSize then
		local f = math.max(0, speed / speedMax + 0.1)
		acc = acc - pow3out(f) * 2
	end
	if math.abs(carX) > roadSize * 1.5 then
		carX = roadSize * 1.5 * sign(carX)
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
	love.graphics.setColor(102, 153, 255)
	love.graphics.rectangle('fill', -VW2, 0, VW, VH)
	local di = math.floor(carZ)
	local ibegin = di
	local iend = roadSegments + di
	local sx0 = getSegment(di)
	local sx1 = getSegment(di + 1)
	local _, f = math.modf(carZ)
	dx = mix(sx0, sx1, smooth(f))
	for n = iend, ibegin, -1 do
		drawSegment(n)
	end
end

function sign(x)
	if x < 0 then
		return -1
	elseif x > 0 then
		return 1
	else 
		return 0
	end
end

function accFunc(speed)
	return -1.352002 + (2.838528 + 1.352002) / (1 + math.pow(speed / 11.35162, 1.495932))
end

function smooth(a)
	return a * a * (3 - 2 * a)
end

function pow3out(a)
	return math.pow(a - 1, 3) + 1
end

function mix(a, b, f)
	return a * (1 - f) + b * f
end

function clamp(x, a, b)
	return math.min(math.max(x, a), b)
end

function loadLevel(name)
	curves, hills = require(name)()
	curvesLength = table.getn(curves)
	hillsLength = table.getn(hills)
	levelLength = math.max(curvesLength, hillsLength)
end

function mapCoord(x, y, z)
	return x / (z + 1), (VH2 + y) * z / (z + 1)
end

function roadColor(n)
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

function laneMarkerColor(n)
	return 210, 210, 210
end

function fogColor(n)
	local r, g, b = 38, 77, 0
	local a = (n - carZ) / roadSegments * 255
	return r, g, b, a
end

function getSegment(n)
	local x, y, z
	if n < curvesLength then
		x = curves[n]
	else
		x = curves[curvesLength]
	end
	if n < hillsLength then
		y = hills[n]
	else
		y = hills[hillsLength]
	end
	z = n - carZ
	return x, y, z
end

function drawSegment(n)
	local sx, sy, sz = getSegment(n)
	local zx, zy, zz = getSegment(n + 1)
	local dsx = (n - carZ) * dx
	local dzx = (n + 1 - carZ) * dx
	local x1, y1 = mapCoord(sx - roadSize - carX, sy, sz)
	local x2, y2 = mapCoord(zx - roadSize - carX, zy, zz)
	local x3, y3 = mapCoord(zx + roadSize - carX, zy, zz)
	local x4, y4 = mapCoord(sx + roadSize - carX, sy, sz)
	local lx1, ly1 = mapCoord(sx - roadSize - carX + laneMarkerSize, sy, sz)
	local lx2, ly2 = mapCoord(zx - roadSize - carX + laneMarkerSize, zy, zz)
	local lx3, ly3 = mapCoord(zx + roadSize - carX - laneMarkerSize, zy, zz)
	local lx4, ly4 = mapCoord(sx + roadSize - carX - laneMarkerSize, sy, sz)
	love.graphics.setColor(roadColor(n))
	love.graphics.polygon('fill',
		x1 + dsx, y1,
		x2 + dzx, y2,
		x3 + dzx, y3,
		x4 + dsx, y4
	)
	if n % 2 == 1 then
		love.graphics.setColor(laneMarkerColor(n))
		love.graphics.polygon('fill',
			x1 + dsx, y1,
			x2 + dzx, y2,
			lx2 + dzx, ly2,
			lx1 + dsx, ly1
		)
		love.graphics.polygon('fill',
			x4 + dsx, y4,
			x3 + dzx, y3,
			lx3 + dzx, ly3,
			lx4 + dsx, ly4
		)
		love.graphics.polygon('fill',
			(x1 + lx4) / 2.0 + dsx, (y1 + ly4) / 2.0,
			(x2 + lx3) / 2.0 + dzx, (y2 + ly3) / 2.0,
			(x3 + lx2) / 2.0 + dzx, (y3 + ly2) / 2.0,
			(x4 + lx1) / 2.0 + dsx, (y4 + ly1) / 2.0
		)
	end
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
	love.graphics.setColor(fogColor(n))
	love.graphics.polygon('fill',
		-VW2, y1,
		-VW2, y2,
		 VW2, y3,
		 VW2, y4
	)
end
