--Credit: https://stackoverflow.com/questions/62625639/changing-the-on-screen-text-and-the-button-text-when-pressing-the-coded-button-i

local love = require "love"

function Button(text, func, width, height)
    return{
        button_width = width,
        button_height = height,
        func = func,
        text = text,
        text_x = 0,
        text_y = 0,
        button_x = 0, 
        button_y = 0, 
        

        draw = function(self, button_x, button_y, text_x, text_y)
            self.button_x = button_x 
            self.button_y = button_y 

            self.text_x = text_x + self.button_x
            self.text_y = text_y + self.button_y
            
            love.graphics.push()
            love.graphics.setColor(0.9, 0.3, 0.6)
            love.graphics.rectangle("fill", self.button_x, self.button_y, self.button_width, self.button_height)

            love.graphics.setColor(0.9, 0.9, 0.9)
            love.graphics.print(self.text, self.text_x, self.text_y)

            love.graphics.setColor(1,1,1)
            love.graphics.pop()
        end,

        button_click = function(self, mouse_x, mouse_y, cursor_radius)
            --  adjust the mouse coordinates to match the scaling when drawn
            local scaled_mouse_x = mouse_x / 0.9
            local scaled_mouse_y = mouse_y / 0.9
            if (scaled_mouse_x + cursor_radius >= self.button_x) and (scaled_mouse_x - cursor_radius <= self.button_x + self.button_width) then
                if (scaled_mouse_y + cursor_radius >= self.button_y) and (scaled_mouse_y - cursor_radius <= self.button_y + self.button_height) then
                    self.func()
                end
            end
        end
    }
end

return Button
