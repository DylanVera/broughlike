gameState = require("src/libs.hump.gamestate")
behavior = require("src/libs.knife.behavior")
signal = require("src/libs.hump.signal")
Vector = require("src/libs.hump.vector")
event = require("src/libs.knife.event")
class = require("src/libs.hump.class")
timer = require("src/libs.hump.timer")
screen = require("src/libs.shack")
lume = require("src/libs.lume")
flux = require("src/libs.flux")
suit = require("src/libs.suit")
push = require("src/libs.push")
lue = require("src/libs.lue")

inspect = require("src/libs.inspect")

require("src/utils.utils")
require("src/utils.state_machine")
require("src/utils.state_stack")

require("src/constants")

--entities/game objectss
require("src/board")
require("src/cursor")
require("src/ability_defs")
require("src/ability")
require("src/entity_defs")
require("src/entity")
require("src/object_defs")
require("src/game_object")
require("src/tile_defs")
require("src/tile")

require("src/actionbar")
require("src/animation")

require("src/commands.move_command")

--game states
require("src/states.base_state")
require("src/states.target_state")
require("src/states.game.menu_state")
require("src/states.game.play_state")

--Load assets
gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/transparentBoy.png'),
    ['ragebaby'] = love.graphics.newImage('graphics/rageBaby.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 128, 128),
    ['ragebaby'] = GenerateQuads(gTextures['ragebaby'], 478, 498)
}

gFonts = {
    ['small'] = love.graphics.newFont('graphics/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('graphics/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('graphics/fonts/font.ttf', 32)
}

gSounds = {
    ['music'] = love.audio.newSource('audio/music.mp3'),
    ['hit-enemy'] = love.audio.newSource('audio/hit_enemy.wav'),
    ['hit-healer'] = love.audio.newSource('audio/hit_player.wav')
}