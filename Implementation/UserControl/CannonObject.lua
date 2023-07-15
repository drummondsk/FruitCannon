love = require("love")

local cannonball = require("Implementation.UserControl.cannonBall")
local cannonImage = love.graphics.newImage("Images/cannon.png")
function createCannon()

    local instance = {
        x = 100,
        y = 500,
        angle = 0,
        cannonballs = {},
        image = love.graphics.newImage("Images/cannon.png")
    }

    function instance:shoot()
        table.insert(self.cannonballs, cannonball(
            self.x -25, self.y - 70, self.angle)) --x and y values adjusted to display in the middle of the cannon chamber 
    end

    function instance:draw()

        love.graphics.draw(self.image, self.x, self.y, self.angle)
        for i, cb in pairs(self.cannonballs) do
            cb:draw()
        end
    end

    function instance:left()
        self.x = self.x - 8
    end

    function instance:right()
        self.x = self.x + 8
    end

    return instance
end

return createCannon
