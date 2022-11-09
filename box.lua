local Box = {img = love.graphics.newImage("assets/box.png")}
Box.__index = Box

Box.width = Box.img:getWidth()
Box.height = Box.img:getHeight() 

local ActiveBoxs = {}

function Box.new(x,y)
    local instance = setmetatable({}, Box)
    instance.x = x
    instance.y = y
    instance.r = 0
    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width * 2, instance.height * 2)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(25)
    table.insert(ActiveBoxs, instance)
end

function Box:update(dt)
    self:syncPhysics()
end

function Box:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function Box:draw()
    love.graphics.draw(self.img, self.x, self.y, self.r, 2,2, self.width / 2, self.height / 2)
end

function Box.updateAll(dt)
    for i,instance in ipairs(ActiveBoxs) do
        instance:update(dt)
    end
end

function Box.drawAll()
   for i,instance in ipairs(ActiveBoxs) do
      instance:draw()
    end
end

function Box:removeAll()
    for i,v in ipairs(ActiveBoxs) do
        v.physics.body:destroy()
    end
    
    ActiveBoxs = {}
end

return Box