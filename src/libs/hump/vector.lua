--[[
Copyright (c) 2010-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local assert = assert
local sqrt, cos, sin, atan2 = math.sqrt, math.cos, math.sin, math.atan2

local Vector = {}
Vector.__index = Vector

local function new(x,y)
	return setmetatable({x = x or 0, y = y or 0}, Vector)
end
local zero = new(0,0)

local function fromPolar(angle, radius)
	radius = radius or 1
	return new(cos(angle) * radius, sin(angle) * radius)
end

local function randomDirection(len_min, len_max)
	len_min = len_min or 1
	len_max = len_max or len_min

	assert(len_max > 0, "len_max must be greater than zero")
	assert(len_max >= len_min, "len_max must be greater than or equal to len_min")
	
	return fromPolar(math.random() * 2*math.pi,
	                 math.random() * (len_max-len_min) + len_min)
end

local function isVector(v)
	return type(v) == 'table' and type(v.x) == 'number' and type(v.y) == 'number'
end

function Vector:clone()
	return new(self.x, self.y)
end

function Vector:unpack()
	return self.x, self.y
end

function Vector:__tostring()
	return "("..tonumber(self.x)..","..tonumber(self.y)..")"
end

function Vector.__unm(a)
	return new(-a.x, -a.y)
end

function Vector.__add(a,b)
	assert(isVector(a) and isVector(b), "Add: wrong argument types (<Vector> expected)")
	return new(a.x+b.x, a.y+b.y)
end

function Vector.__sub(a,b)
	assert(isVector(a) and isVector(b), "Sub: wrong argument types (<Vector> expected): ")
	return new(a.x-b.x, a.y-b.y)
end

function Vector.__mul(a,b)
	if type(a) == "number" then
		return new(a*b.x, a*b.y)
	elseif type(b) == "number" then
		return new(b*a.x, b*a.y)
	else
		assert(isVector(a) and isVector(b), "Mul: wrong argument types (<Vector> or <number> expected)")
		return a.x*b.x + a.y*b.y
	end
end

function Vector.__div(a,b)
	assert(isVector(a) and type(b) == "number", "wrong argument types (expected <Vector> / <number>)")
	return new(a.x / b, a.y / b)
end

function Vector.__eq(a,b)
	return a.x == b.x and a.y == b.y
end

function Vector.__lt(a,b)
	return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function Vector.__le(a,b)
	return a.x <= b.x and a.y <= b.y
end

function Vector.permul(a,b)
	assert(isVector(a) and isVector(b), "permul: wrong argument types (<Vector> expected)")
	return new(a.x*b.x, a.y*b.y)
end

function Vector:toPolar()
	return new(atan2(self.x, self.y), self:len())
end

function Vector:len2()
	return self.x * self.x + self.y * self.y
end

function Vector:len()
	return sqrt(self.x * self.x + self.y * self.y)
end

function Vector.dist(a, b)
	assert(isVector(a) and isVector(b), "dist: wrong argument types (<Vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return sqrt(dx * dx + dy * dy)
end

function Vector.dist2(a, b)
	assert(isVector(a) and isVector(b), "dist: wrong argument types (<Vector> expected)")
	local dx = a.x - b.x
	local dy = a.y - b.y
	return (dx * dx + dy * dy)
end

function Vector:normalizeInplace()
	local l = self:len()
	if l > 0 then
		self.x, self.y = self.x / l, self.y / l
	end
	return self
end

function Vector:normalized()
	return self:clone():normalizeInplace()
end

function Vector:rotateInplace(phi)
	local c, s = cos(phi), sin(phi)
	self.x, self.y = c * self.x - s * self.y, s * self.x + c * self.y
	return self
end

function Vector:rotated(phi)
	local c, s = cos(phi), sin(phi)
	return new(c * self.x - s * self.y, s * self.x + c * self.y)
end

function Vector:perpendicular()
	return new(-self.y, self.x)
end

function Vector:projectOn(v)
	assert(isVector(v), "invalid argument: cannot project Vector on " .. type(v))
	-- (self * v) * v / v:len2()
	local s = (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return new(s * v.x, s * v.y)
end

function Vector:mirrorOn(v)
	assert(isVector(v), "invalid argument: cannot mirror Vector on " .. type(v))
	-- 2 * self:projectOn(v) - self
	local s = 2 * (self.x * v.x + self.y * v.y) / (v.x * v.x + v.y * v.y)
	return new(s * v.x - self.x, s * v.y - self.y)
end

function Vector:cross(v)
	assert(isVector(v), "cross: wrong argument types (<Vector> expected)")
	return self.x * v.y - self.y * v.x
end

-- ref.: http://blog.signalsondisplay.com/?p=336
function Vector:trimInplace(maxLen)
	local s = maxLen * maxLen / self:len2()
	s = (s > 1 and 1) or math.sqrt(s)
	self.x, self.y = self.x * s, self.y * s
	return self
end

function Vector:angleTo(other)
	if other then
		return atan2(self.y, self.x) - atan2(other.y, other.x)
	end
	return atan2(self.y, self.x)
end

function Vector:trimmed(maxLen)
	return self:clone():trimInplace(maxLen)
end


-- the module
return setmetatable({
	new             = new,
	fromPolar       = fromPolar,
	randomDirection = randomDirection,
	isVector        = isVector,
	zero            = zero
}, {
	__call = function(_, ...) return new(...) end
})
