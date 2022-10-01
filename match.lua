local Global = require('global')

local MATCH_STICK_WIDTH = 16
local MATCH_STICK_HEIGHT = 70
local MATCH_HEAD_RADIUS = 12
local MATCH_WIDTH = 20
local MATCH_HEIGHT = 80

local MATCH_DIST = 26

function MatchNew(x, y)
  local match = {
    x = x, y = y,
    animation = {
    },
    move = {
      to = nil
    },
    state = {
      lit = false,
      burnt = false
    },
    taste = {},
    paired = nil,
    chatting = nil
  }

  return match
end

function MatchDraw(self)
  love.graphics.push()
  love.graphics.translate(self.x, self.y)

  local outline = Global.Colors.Outline

  if self == Global.HighlightMatch then
    outline = Global.Colors.MatchHeadFill
  end

  love.graphics.setColor(Global.Colors.MatchStickFill)
  love.graphics.rectangle('fill', -MATCH_STICK_WIDTH / 2, -MATCH_STICK_HEIGHT, MATCH_STICK_WIDTH, MATCH_STICK_HEIGHT)
  love.graphics.setColor(outline)
  love.graphics.rectangle('line', -MATCH_STICK_WIDTH / 2, -MATCH_STICK_HEIGHT, MATCH_STICK_WIDTH, MATCH_STICK_HEIGHT)

  love.graphics.setColor(Global.Colors.MatchHeadFill)
  love.graphics.ellipse('fill', 0, -Global.Sizes.Match.Stick.Height, Global.Sizes.Match.Head.Width, Global.Sizes.Match.Head.Height)
  love.graphics.setColor(outline)
  love.graphics.ellipse('line', 0, -Global.Sizes.Match.Stick.Height, Global.Sizes.Match.Head.Width, Global.Sizes.Match.Head.Height)

  love.graphics.setColor(Global.Colors.Outline)
  love.graphics.circle('fill', 0, 0, 4)

  if self.paired then
  end

  love.graphics.setColor(Global.Colors.White)

  if self.chatting and self.chatting.near then
    local x = -Global.Prerendered.LikeBubble[1]:getWidth() / 2
    local y = -MATCH_HEIGHT - 40
    love.graphics.draw(Global.Prerendered.LikeBubble[1], x, y)
    if self.chatting.like then
      renderLike(self.chatting.like, x, y + 2)
    elseif self.chatting.dislike then
      renderLike(self.chatting.dislike, x, y + 2)
    end
  end

  -- Showing Tastes
  if self.taste.show or true and not (self.chatting and self.chatting.near) then
    local tastesCount = #self.taste.likes + (self.taste.dislikes and #self.taste.dislikes or 0)
    local tastesWidth = tastesCount * Global.Sizes.Like
    local tasteX = -tastesWidth / 2
    local tasteY = -MATCH_HEIGHT - 40
    love.graphics.draw(Global.Prerendered.LikeThought[tastesCount], -Global.Prerendered.LikeThought[tastesCount]:getWidth() / 2, tasteY)

    for i, like in ipairs(self.taste.likes) do
      renderLike(like, tasteX, tasteY + 2)
      tasteX = tasteX + Global.Sizes.Like
    end
  end

  love.graphics.pop()

  --[[
  if self.move.to then
    love.graphics.setColor(Global.Colors.Outline)
    love.graphics.circle('fill', self.move.to.x, self.move.to.y, 4)
  end
  --]]

  if self.paired and self.paired.near then
    local midX = self.x + (self.paired.match.x - self.x) / 2
    local midY = self.y + (self.paired.match.y - self.y) / 2 - MATCH_STICK_HEIGHT / 2
    local fillHeight = math.floor((self.paired.loveLevel.burnLevel / 10) * 40)

    love.graphics.setScissor(midX - 20, midY - 20, 40, 40 - fillHeight)
    love.graphics.setColor(Global.Colors.White)
    love.graphics.circle('fill', midX, midY, 20)
    love.graphics.setScissor()

    love.graphics.setScissor(midX - 20, midY - 20 + 40 - fillHeight, 40, fillHeight)
    love.graphics.setColor(Global.Colors.HeartFill)
    love.graphics.circle('fill', midX, midY, 20)
    love.graphics.setScissor()

    love.graphics.setColor(Global.Colors.Outline)
    love.graphics.circle('line', midX, midY, 20)
  end
end


local MOVE_SPEED = 70
function MatchUpdate(self, dt)
  if self.move.to then
    self.x = self.x + self.move.by.x * dt * MOVE_SPEED
    self.y = self.y + self.move.by.y * dt * MOVE_SPEED
    if math.abs(self.x - self.move.to.x) <= 1 and math.abs(self.y - self.move.to.y) <= 1 then
      self.x = self.move.to.x
      self.y = self.move.to.y
      self.move.to = nil
      self.move.by = nil
    end
  elseif self.paired and not self.paired.near then
    if GoToward(self, self.paired.match, dt) then
      self.paired.near = true
      self.paired.match.near = true
    end
  elseif self.chatting and not self.chatting.near then
    if GoToward(self, self.chatting.match, dt) then
      self.chatting.near = true
      self.chatting.match.near = true
    end
  elseif self.state.lit then

  elseif not self.paired and not self.chatting then
    local choice = math.random()
    if choice > 0.95 then
      local x = (math.random() * 200 - 100) + self.x 
      local y = (math.random() * 100 - 50) + self.y
      if x < 20 then x = 20
      elseif x > Global.Width - 20 then x = Global.Width - 20
      end
      if y < MATCH_HEIGHT + 10 then y = MATCH_HEIGHT + 10
      elseif y > Global.Height - 20 then y = Global.Height - 20
      end

      self.move.to = {
        x = x, y = y
      }

      local diffX = x - self.x
      local diffY = y - self.y
      local mag = getMagnitude(diffX, diffY)
      local unitX, unitY = getUnitVector(diffX, diffY)
      self.move.by = {
        x = unitX,
        y = unitY
      }
    elseif choice > 0.9 and choice < 0.94 and not self.state.lit and false then
      local randomMatch = PickNearbyMatch(self)
      if randomMatch then
        self.chatting = {
          match = randomMatch
        }
        randomMatch.chatting = {
          match = self
        }
      end
    end
  end

  if self.paired and self.paired.near then
    self.paired.loveLevel.burnLevel = self.paired.loveLevel.burnLevel - dt

    if self.paired.loveLevel.burnLevel <= 0 then
      local otherMatch = self.paired.match
      self.paired = nil
      self.state.lit = true
      otherMatch.paired = nil
      otherMatch.state.lit = true
    end
  end

end


function GoToward(self, otherMatch, dt)
  local diffX = otherMatch.x - self.x
  local diffY = otherMatch.y - self.y
  local mag = getMagnitude(diffX, diffY)

  if mag > MATCH_DIST then
    local unitX, unitY = getUnitVector(diffX, diffY)
    self.x = self.x + unitX * dt * MOVE_SPEED * 2 * math.random()
    self.y = self.y + unitY * dt * MOVE_SPEED * 2 * math.random()
    return false
  end

  return true
end


function MatchPair(self, match)
  -- We're already matched haha
  if self.paired then
    return
  end

  local matchPercent = math.random()
  if matchPercent > 0.75 then
    Global.Sounds.match100:play()
  elseif matchPercent > 0.5 then
    Global.Sounds.match75:play()
  elseif matchPercent > 0.25 then
    Global.Sounds.match50:play()
  else
    Global.Sounds.match25:play()
  end

  self.chatting = nil
  match.chatting = nil

  local loveLevel = {
    level = matchPercent,
    burnLevel = 10 * matchPercent
  }

  self.paired = {
    match = match,
    loveLevel = loveLevel
  }

  match.paired = {
    match = self,
    loveLevel = loveLevel
  }
end


function PickNearbyMatch(self, allowPaired, allowChatting)
  local choices = {}
  for i, match in ipairs(Global.Matches) do
    if match ~= self and (allowPaired or not match.paired) and (allowChatting or not match.chatting) then
      table.insert(choices, match)
    end
  end

  if #choices then
    return choices[math.ceil(math.random() * #choices)]
  end

  return nil
end


-- 
-- Functions for managing all matches

function AddRandomMatch()
  local match = MatchNew(math.floor(math.random() * (Global.Width - 40) + 20), math.floor(math.random() * (Global.Height - MATCH_HEIGHT - 30) + MATCH_HEIGHT + 10))
  local level = Global.Levels[Global.Level]
  local likeCount = math.floor(math.random() * (level.MaxLikes - level.MinLikes + 1)) + level.MinLikes
  match.taste.likes = RandomChoices(level.Likes, likeCount)
  print("Random Likes: " .. #match.taste.likes )
  for i, like in ipairs(match.taste.likes) do
    print("  - " .. like)
  end
  
  if level.Dislikes then
    local dislikeCount = math.floor(math.random() * (level.MaxDislikes - level.MinDislikes + 1)) + level.MinDislikes
    match.taste.dislikes = RandomChoices(level.Dislikes, dislikeCount)
  end

  table.insert(Global.Matches, match)
end


function ZSortMatch(matchA, matchB)
  return matchA.y < matchB.y
end

function UpdateMatches(dt)
  for i, match in ipairs(Global.Matches) do
    MatchUpdate(match, dt)
  end

  table.sort(Global.Matches, ZSortMatch)
end

function DrawMatches()
  for i, match in ipairs(Global.Matches) do
    MatchDraw(match)
  end
end

function NearestMatch(x, y, radius)
  local nearest = nil
  local nearestDist = 1000
  local point = {x = x, y = y}

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
