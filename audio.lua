local Audio = {}

sfx = {}

sfx.jump = love.audio.newSource("assets/audio/sfx/jump.ogg", "static")
sfx.ham = love.audio.newSource("assets/audio/sfx/ham.ogg", "static")
sfx.ow = love.audio.newSource("assets/audio/sfx/ow.ogg", "static")
sfx.bark = love.audio.newSource("assets/audio/sfx/bark.ogg", "static")
sfx.win = love.audio.newSource("assets/audio/sfx/win.ogg", "static")
sfx.feather = love.audio.newSource("assets/audio/sfx/feather.ogg", "static")


function Audio.jump()
    sfx.jump:play()
end

function Audio.ham()
    sfx.ham:play()
end

function Audio.ow()
    sfx.ow:play()
end

function Audio.bark()
    sfx.bark:play()
end

function Audio.win()
    sfx.win:play()
end

function Audio.feather()
    sfx.feather:play()
end

return Audio