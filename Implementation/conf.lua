-- manages the configuration of the file
function love.conf(game)
    game.version = "11.4" -- Indicates the game's version for future updates when escalated to a project outside of class 
    game.console = false -- Indicates whether a console should be attached to the game 
    game.gammacorrect = true -- If the system supports, then gamma correct will be enabled
    game.window.title = "Fruit Cannon" 
    -- T0 D0 : Figure out why the below line does not work
    --game.window.icon = "Images/Icons/images.png" 
    game.window.width = 1200
    game.window.height = 600 
end