-- Ham Quest, my very first 2d game, is my final project for CS50. 
-- I was greatly assisted by the Jeepzor tutorial "How To Make A PLATFORMER GAME (Love2D)" to help me structure the foundations of the game.
-- Source code for that project can be found at: https://github.com/Jeepzor/Platformer-tutorial

love.graphics.setDefaultFilter("nearest", "nearest")
local Player = require("player")
local Coin = require("coin")
local GUI = require("GUI")
local Spike = require("spike")
local Camera = require("camera")
local Box = require("box")
local Enemy = require("enemy")
local Map = require("map")
local Audio = require("audio")
local Poont = require("poont")
local Feather = require("feather")


function love.load()
    Enemy.loadAssets()
    Map:load()
    Player:load()
    GUI:load()
end

function love.update(dt)
    Coin.updateAll(dt)
    Spike.updateAll(dt)
    Box.updateAll(dt)
    Enemy.updateAll(dt)
    World:update(dt)
    Player:update(dt)
    GUI:update(dt)
    Camera:setPosition(Player.x, 0)
    Map:update(dt)
    Poont.updateAll(dt)
    Feather.updateAll(dt)
end

function love.draw()
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
    
    Camera:apply()
    Player:draw()
    Coin.drawAll()
    Spike.drawAll()
    Box.drawAll()
    Enemy.drawAll()
    Poont.drawAll()
    Feather.drawAll()
    Camera:clear()
    
    GUI:draw()
end

function love.keypressed(key)
    Player:jump(key)
    Player:restart(key)
end

function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    if Feather.beginContact(a, b, collision) then return end
    if Spike.beginContact(a, b, collision) then return end
    Enemy.beginContact(a, b, collision)
    Poont.beginContact(a, b, collision)
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end
