
function IntroLoad()
end
function IntroUnload()
end

function IntroDraw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(Global.Images.Intro, 0, 0)
end

function IntroUpdate(dt)
end

function IntroMousePressed(x, y, button)
  SwitchScene('game')
end
