local Match = require('match')

-- 
-- Functions for managing all matches

function AddRandomMatch()
  local side = love.math.random(2)
  local startX = 0
  local y = love.math.random(Global.Height - Global.Sizes.Match.Height - 100) + Global.Sizes.Match.Height + 50
  local targetX = 0
  if side == 1 then -- Left
    startX = -40
    targetX = love.math.random(Global.Width / 2) + 20
  elseif side == 2 then -- Right
    startX = Global.Width + 40
    targetX = love.math.random(Global.Width / 2 - 20) + Global.Width / 2
  end
  --local match = MatchNew(startX, y)
  local match = Match:new(startX, y)
  local level = Global.Levels[Global.Level]
  local likeCount = love.math.random(level.MinLikes, level.MaxLikes)
  match.taste.likes = RandomChoices(level.Likes, likeCount)
  
  if level.Dislikes then
    local dislikeCount = love.math.random(level.MinDislikes, level.MaxDislikes)
    match.taste.dislikes = RandomChoices(level.Dislikes, dislikeCount)
  end

  match.move.to = {
    x = targetX,
    y = y
  }

  match.state.arriving = true

  table.insert(Global.Matches, match)
end


function RemoveMatch(removeMatch)
  for i, match in ipairs(Global.Matches) do
    if removeMatch == match then
      table.remove(Global.Matches, i)
      return
    end
  end
end

-- Fix sorting so that the Original will display the heart correctly
function ZSortMatch(matchA, matchB)
  return (matchA.y + ((matchA.paired and matchA.paired.original) and 20 or 0)) < (matchB.y + ((matchB.paired and matchB.paired.original) and 20 or 0))
end

function UpdateMatches(dt)
  for i, match in ipairs(Global.Matches) do
    match:update(dt)
  end

  table.sort(Global.Matches, ZSortMatch)
end

function DrawMatches()
  for i, match in ipairs(Global.Matches) do
    match:draw()
  end
end

function ClearMatches()
  for i = 1, #Global.Matches do
    table.remove(Global.Matches)
  end
end


function NearestMatch(x, y, radius)
  local nearest = nil
  local nearestDist = 1000
  local point = {x = x, y = y + Global.Sizes.Match.Height / 2}

  for i, match in ipairs(Global.Matches) do
    local dist = getDist(match, point)
    if dist < nearestDist then
      nearest = match
      nearestDist = dist
    end
  end

  if nearestDist < radius then
    return nearest
  end
  
  return nil
end

