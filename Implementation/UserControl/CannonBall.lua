local love = require("love")
local image = love.graphics.newImage("Images/cannonball.png")
local scale = 0.55
local radius = (image:getWidth()/2) * 0.5 * scale
local function cannonball(x, y, angle)
    local instance = {
        x = x , 
        y = y,
        angle = angle,
        speed = 800,
        radius = radius,
        image = image
    }

    function instance:move(dt)
        self.y = self.y - self.speed * dt/2
        if self.y < -10 then
            return false
        else
            return true
        end
    end

    function instance:draw()
        local scale = 0.55
        love.graphics.draw(self.image, self.x - (self.radius * scale) + 90, self.y - (self.radius * scale), 0, scale, scale)
    end

    return instance
end

return cannonball