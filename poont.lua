local Poont = {img = love.graphics.newImage("assets/poont.png")}
Poont.__index = Poont

Poont.width = Poont.img:getWidth()
Poont.height = Poont.img:getHeight() 

local ActivePoonts = {}
local Player = require("player")

function Poont.new(x,y)
    local instance = setmetatable({}, Poont)
    instance.x = x
    instance.y = y
    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActivePoonts, instance)
end

function Poont:update(dt)
  
end

function Poont:draw()
    love.graphics.draw(self.img, self.x, self.y, 0,1,1, self.width / 2, self.height / 2)
end

function Poont.updateAll(dt)
    for i,instance in ipairs(ActivePoonts) do
        instance:update(dt)
    end
end

function Poont.drawAll()
   for i,instance in ipairs(ActivePoonts) do
      instance:draw()
    end
end

function Poont:removeAll()
    for i,v in ipairs(ActivePoonts) do
        v.physics.body:destroy()
    end
    
    ActivePoonts = {}
end

function Poont.beginContact(a, b, collision)
    for i,instance in ipairs(ActivePoonts) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:checkHam()
                return true
            end
        end
    end
end

return Poont