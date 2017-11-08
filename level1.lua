function straight(r, n)
	for i = 1, n do
		table.insert(r, 0)
		table.insert(r, 0)
	end
end

function curve(r, n, dx)
	for i = 1, n do
		table.insert(r, dx)
		table.insert(r, 0)
	end
end

local r = {
}

straight(r, 10)
curve(r, 10, 10)
straight(r, 10)

return r
