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

straight(c, 9)  flat(h, 9)
curve(c, 10, 2) hill(h, 10, 12)
curve(c, 29, 8)  hill(h, 20, -10)
uncurve(c, 15)  flatten(h, 15)
straight(c, 16)

return function()
	return c, h
end
