WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
VERSION = 0.1

function love.load()
    -- love.graphics.setDefaultFilter("nearest")

    require "_resources"
    Class = require "library/classic"
    serpent = require "library/serpent"
    fileUtil = require "util/file"

    require "scene/intro"
    require "scene/mainMenu"
    require "scene/stage1"
    require "scene/stage2"
    require "scene/stage3"
    require "scene/end"

	require "object/player"
    require "object/background"
    require "object/enemy"
	require "object/meteor"
    require "object/shot"
    require "object/enemyShot"

    intro = Intro()
    mainMenu = MainMenu()
    stages = {
        Stage1(),
        Stage2(),
        Stage3()
    }
    endStage = End() 

    scenes = {}
    scenes["intro"] = intro
    scenes["mainMenu"] = mainMenu
    for i = 1, #stages do
        scenes["stage" .. i] = stages[i]
    end
    scenes["end"] = endStage

    currentScene = "intro"
    love.graphics.setFont(fontImg)

    showHitbox = false

    data = {}
    for i = 1, #stages do
        local tmp = {}
        tmp.stageCleared = false
        tmp.maxScore = 0
        table.insert(data, tmp)
    end

    fileUtil.load()
end

function love.update(dt)
    scenes[currentScene]:update(dt)
end

function love.draw()
    scenes[currentScene]:draw()
end

function love.keypressed (key)
    if key == "f1" then
        if showHitbox then
            showHitbox = false
        else
            showHitbox = true
        end
    end
end

function love.quit()
    fileUtil.save(data)
end

