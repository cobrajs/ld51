require('utils')

require('match')
local Global = require('global')

function love.load()
  local width, height, flags = love.window.getMode()
  Global.Width = width
  Global.Height = height

  for i = 1, 6 do
    AddRandomMatch()
  end

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

  Global.Countdown = 10
end

function love.update(dt)
  UpdateMatches(dt)

  Global.Countdown = decreaseTime(Global.Countdown, dt)
  if Global.Countdown <= 0 then
    Global.Countdown = 10
    
    CountdownEnded()
  end
end

function love.draw()
  love.graphics.clear(Global.Colors.Grass)

  DrawMatches()

  love.graphics.setColor(Global.Colors.MatchHeadFill)
  love.graphics.rectangle('fill', 0, Global.Height - 40, Global.Width * (Global.Countdown / 10), 40)
  love.graphics.setColor(Global.Colors.Outline)
  love.graphics.line(0, Global.Height - 40, Global.Width, Global.Height - 40)

  --[[
  love.graphics.setColor(Global.Colors.MatchStickFill)
  love.graphics.rectangle('fill', 0, 0, 30, 30)
  love.graphics.setColor(Global.Colors.MatchStickBurntFill)
  love.graphics.rectangle('fill', 30, 0, 30, 30)
  love.graphics.setColor(Global.Colors.MatchHeadFill)
  love.graphics.rectangle('fill', 60, 0, 30, 30)
  love.graphics.setColor(Global.Colors.HeartFill)
  love.graphics.rectangle('fill', 90, 0, 30, 30)
  love.graphics.setColor(Global.Colors.Outline)
  love.graphics.rectangle('fill', 120, 0, 30, 30)
  --]]
end

function love.keypressed(key)
  if key == 'escape' or key == 'q' then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  local highlightMatch = NearestMatch(x, y, 100)
  if highlightMatch then
    if Global.HighlightMatch then
      MatchPair(Global.HighlightMatch, highlightMatch)
      Global.HighlightMatch = nil
    else
      Global.HighlightMatch = highlightMatch
    end
  else
    Global.HighlightMatch = nil
  end
end

function love.mousemoved(x, y, dx, dy)
end

function love.wheelmoved(x, y)
end


function CountdownEnded()
end

