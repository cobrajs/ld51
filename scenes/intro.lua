
function IntroLoad()
end

function IntroDraw()
  love.graphics.clear()

  love.graphics.print("Welcome to It's a Match!", Global.Width / 2 - 50, Global.Height / 2)
  love.graphics.print("Click to Start", Global.Width / 2 - 30, Global.Height / 2 + 40)
end

function IntroUpdate(dt)
end

function IntroMousePressed(x, y, button)
  Global.Scene = 'game'
end
