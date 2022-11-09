local Enemy = {}
Enemy.__index = Enemy
local Player = require("player")
local Coin = require("coin")

local ActiveEnemys = {}

function Enemy.new(x,y)
    local instance = setmetatable({}, Enemy)
    instance.x = x
    instance.y = y
    instance.r = 0
    
    instance.damage = 1
    instance.speed = 50
    instance.xVel = instance.speed
    instance.speedMod = 1
    
    instance.rageCounter = 0
    instance.rageTrigger = 3
    
    instance.state = "walk"
    
    instance.animation = {timer = 0, rate = 0.1}
    instance.animation.run = {total = 4, current = 1, img = Enemy.runAnimation}
    instance.animation.walk = {total = 8, current = 1, img = Enemy.walkAnimation}
    instance.animation.draw = instance.animation.walk.img[1]
    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width / 2, instance.height / 2)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(10)
    table.insert(ActiveEnemys, instance)
end

function Enemy.loadAssets()
    Enemy.runAnimation = {}
    for i=1,4 do
        Enemy.runAnimation[i] = love.graphics.newImage("assets/enemy/run/"..i..".png")
    end
    
    Enemy.walkAnimation = {}
    for i=1,8 do
        Enemy.walkAnimation[i] = love.graphics.newImage("assets/enemy/walk/"..i..".png")
    end
    
    Enemy.width = Enemy.runAnimation[1]:getWidth()
    Enemy.height = Enemy.runAnimation[1]:getHeight()
end

function Enemy:update(dt)
    self:syncPhysics()
    self:animate(dt)
end

function Enemy:incrementRage()
    self.rageCounter = self.rageCounter + 1
    if self.rageCounter > self.rageTrigger then
        self.state = "run"
        self.speedMod = 3
        self.rageCounter = 0
    else
        self.state = "walk"
        self.speedMod = 1
    end
end

function Enemy:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Enemy:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim. current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Enemy:flipDirection()
    self.xVel = -self.xVel
end

function Enemy:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel * self.speedMod, 100)
end

function Enemy:draw()
    local scaleX = 0.5
    if self.xVel < 0 then
        scaleX = -0.5
    end
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX,0.5, self.width / 2, self.height / 2)
end

function Enemy.updateAll(dt)
    for i,instance in ipairs(ActiveEnemys) do
        instance:update(dt)
    end
end

function Enemy.drawAll()
   for i,instance in ipairs(ActiveEnemys) do
      instance:draw()
    end
end

function Enemy.beginContact(a, b, collision)
    for i,instance in ipairs(ActiveEnemys) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
            end
            for i,instance in ipairs(ActiveCoins) do
                if a == instance.physics.fixture or b == instance.physics.fixture then return end
            end
        instance:incrementRage()
        instance:flipDirection()
        end
    end
end

function Enemy:removeAll()
    for i,v in ipairs(ActiveEnemys) do
        v.physics.body:destroy()
    end
    
    ActiveEnemys = {}
end

return Enemy