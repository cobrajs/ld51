local Global = require('global')

function getDist(a, b)
  return math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2))
end

function getMagnitude(x, y)
  return math.sqrt(math.pow(x, 2) + math.pow(y, 2))
end

function getUnitVector(x, y)
  local mag = getMagnitude(x, y)
  if mag == 0 then
    return 0, 0
  end
  return x / mag, y / mag
end

local LIKE_SIZE = 16
local LIKE_RADIUS = LIKE_SIZE / 2
function renderLike(likeId, x, y)
  if likeId == 1 then
    love.graphics.setColor(Global.Colors.White)
    love.graphics.circle('fill', x + LIKE_RADIUS, y + LIKE_RADIUS, LIKE_RADIUS)
    love.graphics.setColor(Global.Colors.Outline)
    love.graphics.circle('line', x + LIKE_RADIUS, y + LIKE_RADIUS, LIKE_RADIUS)
  elseif likeId == 2 then
    love.graphics.setColor(Global.Colors.White)
    love.graphics.rectangle('fill', x, y, LIKE_SIZE, LIKE_SIZE)
    love.graphics.setColor(Global.Colors.Outline)
    love.graphics.rectangle('line', x, y, LIKE_SIZE, LIKE_SIZE)
  elseif likeId == 3 then
    love.graphics.setColor(Global.Colors.Outline)
    love.graphics.rectangle('line', x + LIKE_RADIUS, y, x + LIKE_RADIUS, y + LIKE_SIZE)
    love.graphics.rectangle('line', x, y + LIKE_RADIUS, x + LIKE_SIZE, y + LIKE_RADIUS)
  end
end

function RandomChoices(choiceList, choiceCount)
  return choiceList[1]
end

function RandomChoice(choiceList)
  return choiceList[1]
end
