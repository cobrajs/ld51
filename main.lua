Global = require('global')

require('utils')

require('match')

require('scenes.intro')
require('scenes.game')

function love.load()
  local width, height, flags = love.window.getMode()
  Global.Width = width
  Global.Height = height

  love.graphics.setLineJoin('none')
  love.graphics.setLineWidth(4)

  for i = 1, 3 do 
    local singleLikeBubblePolygon = getRoundedRect(2, 2, Global.Sizes.Like * i, Global.Sizes.Like, 2, 4, 7)
    table.insert(Global.Prerendered.LikeBubble, love.graphics.newCanvas((Global.Sizes.Like * i) + 4, Global.Sizes.Like + 12))
    love.graphics.setCanvas(Global.Prerendered.LikeBubble[i])
    renderRoundedRect(singleLikeBubblePolygon, Global.Colors.Outline, Global.Colors.White)
    love.graphics.setCanvas()

    local singleLikeThoughtPolygon = getRoundedRect(2, 2, Global.Sizes.Like * i, Global.Sizes.Like, 2)
    table.insert(Global.Prerendered.LikeThought, love.graphics.newCanvas((Global.Sizes.Like * i) + 4, Global.Sizes.Like + 4))
    love.graphics.setCanvas(Global.Prerendered.LikeThought[i])
    renderRoundedRect(singleLikeThoughtPolygon, Global.Colors.Outline, Global.Colors.White)
    love.graphics.setCanvas()
  end

  if Global.Scene == 'game' then
    GameLoad()
  elseif Global.Scene == 'intro' then
    IntroLoad()
  end
end

function love.update(dt)
  if Global.Scene == 'game' then
    GameUpdate(dt)
  elseif Global.Scene == 'intro' then
    IntroUpdate(dt)
  end
end

function love.draw()
  if Global.Scene == 'game' then
    GameDraw()
  elseif Global.Scene == 'intro' then
    IntroDraw()
  end
end

function love.keypressed(key)
  if key == 'escape' or key == 'q' then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  if Global.Scene == 'game' then
    GameMousePressed(x, y, button)
  elseif Global.Scene == 'intro' then
    IntroMousePressed(x, y, button)
  end
end

function love.mousemoved(x, y, dx, dy)
  if Global.Scene == 'game' then
    GameMouseMoved(x, y, dx, dy)
  elseif Global.Scene == 'intro' then
  end
end

function love.wheelmoved(x, y)
  if Global.Scene == 'game' then
    GameWheelMoved(x, y)
  elseif Global.Scene == 'intro' then
  end
end

