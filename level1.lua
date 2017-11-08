function straight(r, n)
	for i = 1, n do
		table.insert(r, 0)
		table.insert(r, 0)
	end
end

function uncurve(r, n)
	local dx = r[table.getn(r) - 1]
	local ddx = (0 - dx) / n
	for i = 1, n do
		dx = dx + ddx
		table.insert(r, dx)
		table.insert(r, 0)
	end
end

function curve(r, n, mdx)
	local dx = r[table.getn(r) - 1]
	local ddx = (mdx - dx) / n
	for i = 1, n do
		dx = dx + ddx
		table.insert(r, dx)
		table.insert(r, 0)
	end
end

local r = {
	0, 0,
}

straight(r, 9)
curve(r, 10, 2)
curve(r, 29, 8)
uncurve(r, 15)
straight(r, 16)

return r
