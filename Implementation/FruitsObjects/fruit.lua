-- _G.love = require("love")
--cannonball = require("Implementation.UserControl.CannonBall")

math.randomseed(os.time())

local types = {
    love.graphics.newImage("Images/watermelon2.png"),
    love.graphics.newImage("Images/banana.png")
}


function createFruit()
    local typeoffruit = types[math.random(#types)]
    local fruitWidth, fruitHeight = typeoffruit:getDimensions()
    local instance = {
        fruitType = typeoffruit,
        x = math.random(200, 2600) * 0.48, -- Scale the x position
        y = 70,
        rot_width = fruitWidth / 2,
        rot_height = fruitHeight / 2,
        -- radius = math.max(fruitWidth, fruitHeight) * 0.5 * 0.48
    }

    function instance:move()
        self.y = self.y  + 5
    end

    function instance:draw()
        local angle = love.timer.getTime() * 2 * math.pi / 2.5
        love.graphics.draw(self.fruitType, self.x, self.y, angle, 1, 1, self.rot_width / 2, self.rot_height / 2)
    end

    function instance:collidesWith(cannonball)
        local fruitScale = 0.48
        local cannonballScale = 0.55
        local fruitX, fruitY = self.x * fruitScale, self.y * fruitScale
        local cannonballX, cannonballY = cannonball.x * cannonballScale, cannonball.y * cannonballScale
        local fruitWidth, fruitHeight = self.fruitType:getDimensions()
        local scaledFruitWidth, scaledFruitHeight = fruitWidth * fruitScale, fruitHeight * fruitScale
        local scaledCannonballRadius = cannonball.radius * cannonballScale
    
        -- Calculate the boundaries of the fruit
        local fruitLeft = fruitX - scaledFruitWidth / 2
        local fruitRight = fruitX + scaledFruitWidth / 2
        local fruitTop = fruitY - scaledFruitHeight / 2
        local fruitBottom = fruitY + scaledFruitHeight / 2
    
        -- Calculate the boundaries of the cannonball
        local cannonballLeft = cannonballX - scaledCannonballRadius
        local cannonballRight = cannonballX + scaledCannonballRadius
        local cannonballTop = cannonballY - scaledCannonballRadius
        local cannonballBottom = cannonballY + scaledCannonballRadius
    
        -- Check for overlap between the two objects
        if fruitRight < cannonballLeft or
           fruitLeft > cannonballRight or
           fruitBottom < cannonballTop or
           fruitTop > cannonballBottom then
            return false
        else
            return true
        end
    end
    return instance
end

return {
    createFruit = createFruit,
    types = types
}