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

function renderLike(likeId, x, y)
  local offset = 2
  love.graphics.setLineWidth(2)
  if likeId == 1 then
    love.graphics.setColor(Global.Colors.White)
    love.graphics.circle('fill', x + Global.Sizes.LikeRadius, y + Global.Sizes.LikeRadius, Global.Sizes.LikeRadius - offset * 2)
    love.graphics.setColor(Global.Colors.Outline)
    love.graphics.circle('line', x + Global.Sizes.LikeRadius, y + Global.Sizes.LikeRadius, Global.Sizes.LikeRadius - offset * 2)
  elseif likeId == 2 then
    love.graphics.setColor(Global.Colors.White)
    love.graphics.rectangle('fill', x + offset * 2, y + offset * 2, Global.Sizes.Like - offset * 4, Global.Sizes.Like - offset * 4)
    love.graphics.setColor(Global.Colors.Outline)
    love.graphics.rectangle('line', x + offset * 2, y + offset * 2, Global.Sizes.Like - offset * 4, Global.Sizes.Like - offset * 4)
  elseif likeId == 3 then
    love.graphics.setColor(Global.Colors.Outline)
    love.graphics.line(x + Global.Sizes.LikeRadius, y + offset * 2, x + Global.Sizes.LikeRadius, y + Global.Sizes.Like - offset * 2)
    love.graphics.line(x + offset * 2, y + Global.Sizes.LikeRadius, x + Global.Sizes.Like - offset * 2, y + Global.Sizes.LikeRadius)
  end
  love.graphics.setLineWidth(4)
end

function RandomChoices(choiceList, choiceCount)
  local choiceListCopy = {}
  for i, choice in ipairs(choiceList) do
    choiceListCopy[i] = choice
  end
  for i = 1, (#choiceListCopy - choiceCount) do
    local removeIndex = math.ceil(math.random() * #choiceListCopy)
    table.remove(choiceListCopy, removeIndex)
  end
  return choiceListCopy
end

function RandomChoice(choiceList)
  return choiceList[math.ceil(math.random() * #choiceList)]
end

function getRoundedRect(x, y, width, height, corner, triangleW, triangleH)
  local right = x + width
  local bottom = y + height
  local polygon = {
    -- Top Left
    x + corner, y,  x, y + corner,
    -- Bottom left
    x, bottom - corner,  x + corner, bottom,
    -- Bottom right
    right - corner, bottom,  right, bottom - corner,
    -- Top right
    right, y + corner,  right - corner, y
  }

  local triangle = nil
  if triangleW and triangleH then
    local centerX = x + width / 2
    table.insert(polygon, 9, bottom)
    table.insert(polygon, 9, centerX + triangleW / 2)
    table.insert(polygon, 9, bottom + triangleH)
    table.insert(polygon, 9, centerX)
    table.insert(polygon, 9, bottom)
    table.insert(polygon, 9, centerX - triangleW / 2)
  end

  return polygon
end

function renderRoundedRect(polygon, outlineColor, fillColor)
  local triangles = love.math.triangulate(polygon)

  love.graphics.setColor(fillColor)
  for i, triangle in ipairs(triangles) do
    love.graphics.polygon('fill', triangle)
  end

  love.graphics.setColor(outlineColor)
  love.graphics.polygon('line', polygon)
end


function decreaseTime(baseTime, dt)
  return baseTime - dt
end
