local Map = {}
local STI = require("sti")
local Box = require("box")
local Enemy = require("enemy")
local Coin = require("coin")
local Spike = require("spike")
local Player = require("player")
local Poont = require("poont")
local Feather = require("feather")



function Map:load()
    World = love.physics.newWorld(0,2000)
    World:setCallbacks(beginContact, endContact)
    
    self.currentLevel = 1
    self.currentSong = 1
    self.gameOver = false
    self:song()
    self:init()
end

function Map:song()
    song = love.audio.newSource("assets/audio/music/"..self.currentSong..".ogg", "stream")
    song:setLooping(true)
    song:setVolume(0.75)
    song:play()
end

function Map:update(dt)
    if not Player.alive then
        self:dead()
    end
    if Player.nextLevel then
        Player.nextLevel = false
        self:nextLevel()
    end
    if self.currentLevel == 3 then
        Player.cheerTime = 500
        Player.beatGame = true
        Player:cheer(dt)
    end
end

function Map:init()
    self.level = STI("map/"..self.currentLevel..".lua", {"box2d"})
  
    self.level:box2d_init(World)
    self.level.layers.Solid.visible = false
    self.level.layers.Object.visible = false
    MapWidth = self.level.layers.Ground.width * 18
    
    self:spawnObjects()
end

function Map:nextLevel()
    self:clear()
    love.audio.stop()
    self.currentLevel = self.currentLevel + 1
    self.currentSong = self.currentSong + 1
    self:init()
    self:song()
    Player:resetPosition()
end

function Map:dead()
    if not self.gameOver then
        self:clear()
        love.audio.stop()
        self.currentLevel = 4
        self.currentSong = 4
        self:init()
        self:song()
        Player:resetPosition()
        Player.xVel = 0
        Player.yVel = 200
        self.gameOver = true
    end
end

function Map:clear()
    self.level:box2d_removeLayer("Solid")
    Coin:removeAll()
    Spike:removeAll()
    Box:removeAll()
    Enemy:removeAll()
    Poont:removeAll()
end

function Map:spawnObjects()
    for i,v in ipairs(self.level.layers.Object.objects) do
        if v.name == "Spike" then
            Spike.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.name == "Coin" then
            Coin.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.name == "Box" then
            Box.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.name == "Enemy" then
            Enemy.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.name == "Poont" then
            Poont.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.name == "Feather" then
            Feather.new(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end

return Map