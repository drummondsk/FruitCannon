_G.love = require("love")
_G.time = os.clock()

local fruitModule = require("Implementation.FruitsObjects.fruit")
local createFruit = fruitModule.createFruit
local types = fruitModule.types
local createCannon = require("Implementation.UserControl.CannonObject")
local button = require("Implementation.button")
local cannonball = require("Implementation.UserControl.cannonBall")
local test = require("Implementation.FruitsObjects.fruit")

math.randomseed(os.time())

-- Indicates where in the game cycle the user is currently in
local game = {
    disposition = {
        menu_screen = true,
        settings = false,
        level_one = false,
        game_over = false
    }
}

-- Table storing the various buttons for the menu_screen states 
local buttons = {
    menu_screen = {
        play_game = nil,
        settings = nil, 
        exit_game = nil
    }, 

    settings = {
        back_menu = nil,
        page_1 = nil, 
        page_2 = nil
    }, 
    game_over_screen = {
        play_game = nil,
        menu_screen = nil,
        exit_game = nil
    }
}
-- Table storing the various random fruit objects
local setfruits = {}

-- Resets the game dispostions to initiate a new game
function NewGame()
    game.disposition["menu_screen"] = false
    game.disposition["settings"] = false
    game.disposition["level_one"] = true
    game.disposition["game_over"] = false
    countdown = 20
    score = 0
    
end 

-- Resets the game dispostions to initiate the instructions screen
function Instructions()
    game.disposition["menu_screen"] = false
    game.disposition["settings"] = true
    game.disposition["level_one"] = false
    game.disposition["game_over"] = false
    
end 

-- Resets the game dispostions to initiate a new menu screen
function NewMenu()
    game.disposition["menu_screen"] = true
    game.disposition["settings"] = false
    game.disposition["level_one"] = false
    game.disposition["game_over"] = false
     
end 


-- Handles onclick funcitons when a mouse button is pressed 
function love.mousepressed(x, y, button, istouch)
    if button == 1 then --checks which button was pressed, refer to [url=https://love2d.org/wiki/love.mousepressed]wiki[/url]
        if game.disposition["menu_screen"] then
            for i in pairs(buttons.menu_screen) do
                buttons.menu_screen[i]: button_click(x, y, 10)
            end
        elseif game.disposition["settings"] then
            for i in pairs(buttons.settings) do
                buttons.settings[i]: button_click(x, y, 10)
            end
        elseif game.disposition["game_over"] then
            for i in pairs(buttons.game_over_screen) do
                buttons.game_over_screen[i]: button_click(x, y, 10)
            end
        end
    end 
end



function love.load()
    --[[ 
        This funciton establishes the resources that will be utilized by other functions in the game.
    --]]

    love.graphics.setColor(0,20,50,255)

    menu_font = love.graphics.newFont(70)
    score_font = love.graphics.newFont(30)
    font = love.graphics.newFont(20)
    count_font = love.graphics.newFont(50)

    fruitdelay = 1 
    timesincelastfruit = 0
    numFruitsDisplayed = 0
    numFruit = 100

    cannon = createCannon()
    background = love.graphics.newImage("Images/bg.jpg")
    help_image = love.graphics.newImage("Images/instructions1.png")
    
    -- Loading in the buttons for the game
    buttons.menu_screen.play_game = button("Play Game", NewGame, 140, 40)
    buttons.menu_screen.settings = button("How to Play", Instructions, 140, 40)
    buttons.menu_screen.exit_game = button("Quit Game", love.event.quit, 140, 40)

    buttons.settings.back_menu = button("Menu", NewMenu, 140, 40)

    buttons.game_over_screen.play_game = button("Play Again", NewGame, 140, 40)
    buttons.game_over_screen.menu_screen = button("Menu", NewMenu, 140, 40)
    buttons.game_over_screen.exit_game = button("Quit Game", love.event.quit, 140, 40)
   
end 

function love.update(dt)
    --[[
        This function updates the state of the game after every frame
    --]]

    timesincelastfruit = timesincelastfruit + dt
    
    if game.disposition["level_one"] then
        -- Countdown timer
        if countdown > 0 then
            countdown = countdown - dt -- Subtract from countdown every second
            if countdown < 0 then
                countdown = 0
                game.disposition["level_one"] = false
                game.disposition["game_over"] = true
            end
        end

        for i = #setfruits, 1, -1 do -- loop backwards to avoid index error
            local fruit = setfruits[i]
            fruit:move()

            for j = #cannon.cannonballs, 1, -1 do
                local cannonball = cannon.cannonballs[j]
                if fruit:collidesWith(cannonball) then
                    table.remove(setfruits, i)
                    table.remove(cannon.cannonballs, j)

                    score = score + 1
                    break
                end
            end
        end
    end

    for i = #cannon.cannonballs, 1, -1 do 
        local cannonball = cannon.cannonballs[i]
        cannonball:move(dt)
        if cannonball.y < 0 then
            table.remove(cannon.cannonballs, i)
        end
    end

    -- Creates a delay beween fruits being updated on the screen
    if timesincelastfruit >= fruitdelay then 
        if numFruitsDisplayed < numFruit then
            table.insert(setfruits, createFruit())
            timesincelastfruit = timesincelastfruit - fruitdelay
            numFruitsDisplayed = numFruitsDisplayed + 1
        end
    end
    
    -- Accepts keyboard input 
    if love.keyboard.isDown("left") then 
        cannon:left()
    elseif love.keyboard.isDown("right") then 
        cannon:right()
    elseif love.keyboard.isDown("space") then
        cannon:shoot()
    end

    if game.disposition["settings"] then
        love.graphics.print("Testing, 20, 20")
    end 
end

function love.draw()

    love.graphics.setColor(255, 255, 255)
    -- sets the background image
    --source: https://love2d.org/forums/viewtopic.php?t=10919
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.scale(0.9, 0.9)
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end


    if game.disposition["level_one"] then
        if countdown <= 10 then
            love.graphics.setColor(255, 0, 0)
            love.graphics.setFont(count_font)
            love.graphics.print("Time left: " .. math.ceil(countdown), 550, 50)
            love.graphics.setFont(font)
        else
            love.graphics.setFont(count_font)
            love.graphics.print("Time left: " .. math.ceil(countdown), 550, 50)
        end

        -- Score graphics
        love.graphics.setFont(score_font)
        love.graphics.print("Score: "..tostring(score), 10, 40 )
        love.graphics.print(score, 1800, 100)
       
        love.graphics.scale(0.95, 0.95)
        cannon:draw()
        
        love.graphics.scale(0.4, 0.4)
    
        for i = 1, #setfruits do
            local fruit = setfruits[i]
            love.graphics.draw(fruit.fruitType, fruit.x * (1/0.48), fruit.y * (1/0.48))
        end

    elseif game.disposition["game_over"] then

        love.graphics.setColor(0.9, 0.3, 0.6)
        love.graphics.setFont(menu_font)
        love.graphics.print("Game Over!", 400, 50)
        love.graphics.print("Final Score: " .. tostring(score), 400, 200)
        love.graphics.setFont(font)

        buttons.game_over_screen.play_game:draw(600, 350, 17, 10)
        buttons.game_over_screen.menu_screen:draw(600, 400, 17, 10)
        buttons.game_over_screen.exit_game:draw(600, 450, 17, 10)
       
    
    elseif game.disposition["menu_screen"] then

        love.graphics.setColor(0.9, 0.3, 0.6)
        love.graphics.setFont(menu_font)
        love.graphics.print("FRUIT CANNON", 400, 50)
        love.graphics.setFont(font)

        buttons.menu_screen.play_game:draw(600, 300, 17, 10)
        buttons.menu_screen.settings:draw(600, 350, 17, 10)
        buttons.menu_screen.exit_game:draw(600, 400, 17, 10)

    elseif game.disposition["settings"] then
        love.graphics.scale(0.6, 0.6)
        love.graphics.draw(help_image, 500, 200)
        love.graphics.scale(0.9, 0.9)
        buttons.settings.back_menu:draw(1200, 1100, 17, 10)
    end
end