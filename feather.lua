local Feather = {}
Feather.__index = Feather
local ActiveFeathers = {}
local Player = require("player")
local Audio = require("audio")

function Feather.new(x,y)
    local instance = setmetatable({}, Feather)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("assets/feather.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scaleX = 1
    instance.toBeRemoved = false
    
    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width / 2, instance.height / 2)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveFeathers, instance)
end

function Feather:update(dt)
    self:checkRemove()
end

function Feather:remove()
    for i,instance in ipairs(ActiveFeathers) do
        if instance == self then
            if Player.alive then
                self.physics.body:destroy()
                table.remove(ActiveFeathers, i)
            end
        end
    end
end

function Feather:removeAll()
    for i,v in ipairs(ActiveFeathers) do
        v.physics.body:destroy()
    end
    
    ActiveFeathers = {}
end

function Feather:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end


function Feather:draw()
    love.graphics.draw(self.img, self.x, self.y, 0,1,1, self.width / 2, self.height / 2)
end

function Feather.updateAll(dt)
    for i,instance in ipairs(ActiveFeathers) do
        instance:update(dt)
    end
end

function Feather.drawAll()
   for i,instance in ipairs(ActiveFeathers) do
      instance:draw()
    end
end

function Feather.beginContact(a, b, collision)
    for i,instance in ipairs(ActiveFeathers) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                instance.toBeRemoved = true
                Player.hasFeather = true
                Audio.feather()
                return true
            end
        end
    end
end

return Feather