local GUI = {}
local Player = require("player")
local Map = require("map")

function GUI:load()
    self.coins = {}
    self.coins.img = love.graphics.newImage("assets/ham.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale = 1.5
    self.coins.x = love.graphics.getWidth() - 200
    self.coins.y = 30
    self.font = love.graphics.newFont("assets/dog.TTF", 60)
    
    self.hearts = {}
    self.hearts.img = love.graphics.newImage("assets/heartFull.png")
    self.hearts.width = self.hearts.img:getWidth()
    self.hearts.height = self.hearts.img:getHeight()
    self.hearts.x = 0
    self.hearts.y = 30
    self.hearts.scale = 3
    self.hearts.spacing = self.hearts.width * self.hearts.scale + 10
end

function GUI:update(dt)
  
end

function GUI:draw()
    if not Map.gameOver and not Player.beatGame then
        self:displayCoins()
        self:displayCoinText()
        self:displayHearts()
    end
end

function GUI:displayHearts()
    for i=1,Player.health.current do
        local x = self.hearts.x + self.hearts.spacing * i
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.draw(self.hearts.img, x - 38, self.hearts.y + 2, 
            0, self.hearts.scale, self.hearts.scale)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.hearts.img, x - 40, self.hearts.y, 
            0, self.hearts.scale, self.hearts.scale)
        
    end
end

function GUI:displayCoins()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.draw(self.coins.img, self.coins.x + 2, self.coins.y + 2,
        0, self.coins.scale, self.coins.scale)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y,
        0, self.coins.scale, self.coins.scale)
end

function GUI:displayCoinText()
    love.graphics.setFont(self.font)
    local x = self.coins.x + self.coins.width * self.coins.scale
    local y = self.coins.y + self.coins.height / 2 * self.coins.scale - self.font:getHeight() / 2
    love.graphics.setColor(0,0,0,1)
    love.graphics.print(" : "..Player.coins, x, y)
    love.graphics.setColor(1,1,1,1)
end

return GUI