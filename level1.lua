function straight(r, n)
	for i = 1, n do
		table.insert(r, 0)
	end
end

function uncurve(r, n)
	local dx = r[table.getn(r) - 1]
	local ddx = (0 - dx) / n
	for i = 1, n do
		dx = dx + ddx
		table.insert(r, dx)
	end
end

function curve(r, n, mdx)
	local dx = r[table.getn(r) - 1]
	local ddx = (mdx - dx) / n
	for i = 1, n do
		dx = dx + ddx
		table.insert(r, dx)
	end
end

local flat = straight
local hill = curve
local flatten = uncurve

local c = {
	0, 0,
}
local h = {
	0, 0,
}

straight(c, 12)  flat(h, 12)

curve(c, 10, 2) hill(h, 10, 64)
curve(c, 29, 8)  flatten(h, 20)
uncurve(c, 15)  hill(h, 15, -64)
straight(c, 16)  flatten(h, 20)

curve(c, 10, -4) flat(h, 10)
curve(c, 20, -12) hill(h, 20, 29)
uncurve(c, 12) flatten(h, 12)
curve(c, 10, 8) flatten(h, 10)
uncurve(c, 10) hill(h, 10, 30)
straight(c, 12) flatten(h, 12)
curve(c, 8, 10) hill(h, 8, -30)
uncurve(c, 8) hill(h, 8, -50)
straight(c, 6) flatten(h, 6)
curve(c, 5, 2) flat(h, 5)
curve(c, 21, 7) flat(h, 21)
uncurve(c, 8) hill(h, 8, -20)
straight(c, 6) flatten(h, 6)
curve(c, 22, 9) flat(h, 22)
uncurve(c, 10) flat(h, 10)

curve(c, 10, -1) hill(h, 10, 10)
curve(c, 10, -2) hill(h, 10, 20)
curve(c, 10, -4) hill(h, 10, 30)
curve(c, 10, -6) hill(h, 10, 40)
curve(c, 10, -8) hill(h, 10, 50)
curve(c, 10, -10) hill(h, 10, 60)
uncurve(c, 15) flatten(h, 15)
straight(c, 16) hill(h, 16, -20)
curve(c, 10, 4) hill(h, 10, -30)
curve(c, 10, 6) hill(h, 10, -45)
curve(c, 9, 8) flatten(h, 9)
curve(c, 7, 10) flat(h, 7)
curve(c, 5, 12) hill(h, 5, 20)
curve(c, 7, 10) hill(h, 7, 45)
curve(c, 9, 8) flatten(h, 9)
uncurve(c, 10) flat(h, 10)
straight(c, 20) hill(h, 20, 25)
straight(c, 5) flatten(h, 5)

curve(c, 29, -8) flat(h, 29)
uncurve(c, 10) hill(h, 10, 30)
curve(c, 29, 8) hill(h, 29, 50)
uncurve(c, 10) flatten(h, 10)
curve(c, 29, -8) flat(h, 29)
uncurve(c, 10) hill(h, 10, -25)
curve(c, 29, 8) hill(h, 29, -36)
uncurve(c, 10) flatten(h, 10)
straight(c, 11) flat(h, 11)

straight(c, 10) hill(h, 10, 60)
straight(c, 20) flatten(h, 20)
curve(c, 10, 4) hill(h, 10, -60)
curve(c, 20, 6) flatten(h, 20)
curve(c, 10, 4) hill(h, 10, 75)
curve(c, 20, 5) flatten(h, 20)
uncurve(c, 10) hill(h, 10, -75)
straight(c, 20) flatten(h, 20)

straight(c, 21) flat(h, 21)

return function()
	return c, h
end
