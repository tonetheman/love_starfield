
local width = 800
local height = 600


local V3 = {}
function V3.new(x,y,z)
    local o = { x=x,y=y,z=z}
    
    function o:add(other)
        return V3.new(self.x+other.x,self.y+other.y,self.z+other.z)
    end

    return o
end

local Star = {}
function Star.new(x,y)
    local o = {
        origx = x, origy = y,
        pos = V3.new(x,y,0),
        prevPos = V3.new(x,y,0),
        vel = V3.new(0,0,0),
        ang = math.atan2(y - (height/2), x - (width/2))
    }

    function o:update(dt)
        self.vel.x = self.vel.x + (math.cos(self.ang)*dt)*0.8
        self.vel.y = self.vel.y + (math.sin(self.ang)*dt)*0.8
        
        self.prevPos.x = self.pos.x
        self.prevPos.y = self.pos.y

        self.pos.x = self.pos.x + self.vel.x
        self.pos.y = self.pos.y + self.vel.y
    end

    function o:draw()
        love.graphics.line(self.pos.x, self.pos.y,
            self.prevPos.x, self.prevPos.y)
    end

    function o:onScreen(x,y)
        return x>=0 and x <=width and y>=0 and y<=height
    end
    
    function o:isActive()
        return self:onScreen(self.prevPos.x, self.prevPos.y)
    end

    return o
end


local numStars = 500
local cc = 500
local stars = {}

function love.load()
    for i=1,numStars do
        table.insert(stars, Star.new(love.math.random(width), love.math.random(height)))
    end
end


function love.update(dt)
    for i,v in ipairs(stars) do
        stars[i]:update(dt)
    end

    for i,v in ipairs(stars) do
        if not v:isActive() then
            table.remove(stars,i)
            cc = cc  -1
        end
    end

    -- we are short a few
    if cc ~= numStars then
        while true do
            table.insert(stars, Star.new(love.math.random(width), love.math.random(height)))
            cc = cc + 1
            if cc == numStars then
                break
            end
        end
    end

end

function love.draw()
    for i,v in ipairs(stars) do
        v:draw()
    end
end
