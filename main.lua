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

  love.graphics.setLineWidth(4)
end

function love.update(dt)
  UpdateMatches(dt)
end

function love.draw()
  love.graphics.clear(Global.Colors.Grass)

  DrawMatches()

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
