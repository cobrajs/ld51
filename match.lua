local MATCH_DIST = 26

function MatchNew(x, y)
  local match = {
    x = x, y = y,
    animation = {
      bounce = love.math.random() * math.pi,
      stopBounce = false,
      burning = 0
    },
    move = {
      to = nil
    },
    state = {
      lit = false,
      burnt = false,
      leaving = false,
      arriving = false
    },
    taste = {
      show = true
    },
    paired = nil,
    chatting = nil,
    cooldowns = {
      chat = 0,
      walk = 0,
      showTastes = 2,
      lit = 0
    },
    sounds = {
      step = Global.Sounds.Step[love.math.random(#Global.Sounds.Step)]:clone()
    }
  }

  match.sounds.step:setRelative(true)

  return match
end

function MatchDraw(self)
  local offset = math.abs(math.sin(self.animation.bounce)) * 10
  love.graphics.push()
  love.graphics.translate(self.x, self.y - offset)

  love.graphics.setLineWidth(4)

  local outline = Global.Colors.Outline
  local shadowWeight = 0.05

  if self == Global.HighlightMatch then
    outline = Global.Colors.MatchHeadFill
  end

  if self == Global.MouseHover.Match then
    shadowWeight = 0.2
    love.graphics.setLineWidth(8)
    love.graphics.setColor(outline[1], outline[2], outline[3], 0.5)
    love.graphics.rectangle('line', -Global.Sizes.Match.Stick.Width / 2, -Global.Sizes.Match.Stick.Height, Global.Sizes.Match.Stick.Width, Global.Sizes.Match.Stick.Height)
    love.graphics.ellipse('line', 0, -Global.Sizes.Match.Stick.Height, Global.Sizes.Match.Head.Width, Global.Sizes.Match.Head.Height)

    love.graphics.setLineWidth(4)
  end


  love.graphics.setColor(0, 0, 0, shadowWeight)
  love.graphics.ellipse('fill', 0, offset, Global.Sizes.Match.Width * 1.2, Global.Sizes.Match.Width * 0.8)
  love.graphics.setColor(0, 0, 0, shadowWeight * 1.5)
  love.graphics.ellipse('fill', 0, offset, Global.Sizes.Match.Width * 1.2 - offset / 4, Global.Sizes.Match.Width * 0.8 - offset / 4)

  love.graphics.setColor(Global.Colors.MatchStickFill)
  love.graphics.rectangle('fill', -Global.Sizes.Match.Stick.Width / 2, -Global.Sizes.Match.Stick.Height, Global.Sizes.Match.Stick.Width, Global.Sizes.Match.Stick.Height)
  if self.state.burnt then
    love.graphics.setColor(Global.Colors.MatchStickBurntFill)
    love.graphics.rectangle('fill', -Global.Sizes.Match.Stick.Width / 2, -Global.Sizes.Match.Stick.Height, Global.Sizes.Match.Stick.Width, Global.Sizes.Match.Stick.Height / 3)
  end
  love.graphics.setColor(outline)
  love.graphics.rectangle('line', -Global.Sizes.Match.Stick.Width / 2, -Global.Sizes.Match.Stick.Height, Global.Sizes.Match.Stick.Width, Global.Sizes.Match.Stick.Height)

  love.graphics.setColor(Global.Colors.MatchHeadFill)
  love.graphics.ellipse('fill', 0, -Global.Sizes.Match.Stick.Height, Global.Sizes.Match.Head.Width, Global.Sizes.Match.Head.Height)
  if self.state.burnt then
    love.graphics.setColor(Global.Colors.MatchStickBurntFill)
    love.graphics.ellipse('fill', 0, -Global.Sizes.Match.Stick.Height, Global.Sizes.Match.Head.Width, Global.Sizes.Match.Head.Height)
  end
  love.graphics.setColor(outline)
  love.graphics.ellipse('line', 0, -Global.Sizes.Match.Stick.Height, Global.Sizes.Match.Head.Width, Global.Sizes.Match.Head.Height)

  if self.paired then
  end

  if self.state.lit then
    local burnOffset = math.abs(math.cos(self.animation.burning)) * 10
    love.graphics.setColor(Global.Colors.MatchHeadBurnFill)
    love.graphics.ellipse('fill', 0, -Global.Sizes.Match.Stick.Height * 1.2 - burnOffset, Global.Sizes.Match.Head.Width * 1.5, Global.Sizes.Match.Head.Height * 2 + burnOffset)
    love.graphics.setColor(Global.Colors.MatchHeadFill)
    love.graphics.ellipse('fill', 0, -Global.Sizes.Match.Stick.Height * 1 - burnOffset, Global.Sizes.Match.Head.Width * 1.1, Global.Sizes.Match.Head.Height + burnOffset)
    love.graphics.setColor(outline)
    love.graphics.ellipse('line', 0, -Global.Sizes.Match.Stick.Height * 1.2 - burnOffset, Global.Sizes.Match.Head.Width * 1.5, Global.Sizes.Match.Head.Height * 2 + burnOffset)
  end

  love.graphics.setColor(Global.Colors.White)

  if self.chatting and self.chatting.near then
    local x = -Global.Prerendered.LikeBubble[1]:getWidth() / 2
    local y = -Global.Sizes.Match.Height - 40
    love.graphics.draw(Global.Prerendered.LikeBubble[1], x, y)
    if self.chatting.like then
      renderLike(self.chatting.like, x + 2, y + 2)
    elseif self.chatting.dislike then
      renderLike(self.chatting.dislike, x + 2, y + 2)
    end
  end

  -- Showing Tastes
  if (self.taste.show or Global.HighlightMatch == self or Global.MouseHover.Match == self) and not (self.chatting and self.chatting.near) then
    local tastesCount = #self.taste.likes + (self.taste.dislikes and #self.taste.dislikes or 0)
    local tastesWidth = tastesCount * Global.Sizes.Like
    local tasteX = -tastesWidth / 2
    local tasteY = -Global.Sizes.Match.Height - 40
    love.graphics.draw(Global.Prerendered.LikeThought[tastesCount], -Global.Prerendered.LikeThought[tastesCount]:getWidth() / 2, tasteY)

    for i, like in ipairs(self.taste.likes) do
      renderLike(like, tasteX, tasteY + 2)
      tasteX = tasteX + Global.Sizes.Like
    end

    if self.taste.dislikes then
      for i, dislike in ipairs(self.taste.dislikes) do
        renderDislike(dislike, tasteX, tasteY + 2)
        tasteX = tasteX + Global.Sizes.Like
      end
    end
  end

  love.graphics.pop()

  --[[
  love.graphics.setColor(Global.Colors.Outline)
  love.graphics.circle('fill', self.x, self.y, 4)
  --]]

  --[[
  if self.move.to then
    love.graphics.setColor(Global.Colors.Outline)
    love.graphics.circle('fill', self.move.to.x, self.move.to.y, 4)
  end
  --]]

  if self.paired and self.paired.original and self.paired.near then
    local midX = self.x + (self.paired.match.x - self.x) / 2
    local midY = self.y + (self.paired.match.y - self.y) / 2 - Global.Sizes.Match.Stick.Height / 2

    renderHeart(midX, midY, 40, self.paired.loveLevel.burnLevel / 10, 'horizontal')
  end
end


local MOVE_SPEED = 70

function MatchUpdate(self, dt)
  AnimateBounce(self, dt)
  AnimateBurning(self, dt)
  if self.move.to then
    self.animation.stopBounce = false
    local moveSpeed = MOVE_SPEED
    if self.state.leaving or self.state.arriving then moveSpeed = moveSpeed * 4
    elseif self.state.lit then moveSpeed = moveSpeed * 1.3
    elseif self.state.burnt then moveSpeed = moveSpeed * 0.5
    end

    GoToward(self, self.move.to, dt, moveSpeed)
    if math.abs(self.x - self.move.to.x) <= 3 and math.abs(self.y - self.move.to.y) <= 3 then
      self.x = self.move.to.x
      self.y = self.move.to.y
      self.move.to = nil
      self.cooldowns.walk = love.math.random(10) / 8
      if self.state.leaving then
        RemoveMatch(self)
        return
      end
      if self.state.arriving then
        self.state.arriving = false
      end
    end
  elseif self.paired then
    self.animation.stopBounce = false
    if not self.paired.near then
      if GoTowardMatch(self, self.paired.match, dt) then
        self.paired.near = true
      end
    else
      EqualizePair(self, self.paired.match, dt)
    end
  elseif self.chatting then
    self.animation.stopBounce = false
    if not self.chatting.near then
      if GoTowardMatch(self, self.chatting.match, dt) then
        self.chatting.near = true
        if self.chatting.sound then
          --self.chatting.sound:setPosition(self.x, self.y, 0)
          self.chatting.sound:play()
        end
      end
    else
      EqualizePair(self, self.chatting.match, dt)

      self.chatting.chatTime = self.chatting.chatTime - dt
      if self.chatting.chatTime <= 0 then
        self.chatting.match.cooldowns.chat = 2
        self.cooldowns.chat = 2
        EndChatting(self)
      end
    end
  elseif self.state.lit then
    RandomWalk(self)
  elseif not self.paired and not self.chatting then
    local choice = love.math.random()
    if choice > 0.96 and self.cooldowns.walk == 0 then
      RandomWalk(self)
    elseif choice > 0.9 and choice < 0.92 and not self.state.lit and self.cooldowns.chat == 0 then
      local randomMatch = PickNearbyMatch(self)
      if randomMatch then
        ChatPair(self, randomMatch)
      end
    else
      self.animation.stopBounce = true
    end
  end

  if self.paired and self.paired.near then
    self.paired.loveLevel.burnLevel = decreaseTime(self.paired.loveLevel.burnLevel, dt, self.paired.loveLevel.burnSpeed)

    if self.paired.loveLevel.burnLevel <= 0 then
      local otherMatch = self.paired.match
      self.paired = nil
      LightMatch(self, true)

      otherMatch.paired = nil
      LightMatch(otherMatch)
    end
  end

  HandleCooldown(self, 'chat', dt)
  HandleCooldown(self, 'walk', dt)
  HandleCooldown(self, 'showTastes', dt, DisableTasteShow)
  if self.state.lit then
    HandleCooldown(self, 'lit', dt, BurnOut)
  end
end

function EndChatting(self)
  if not self.chatting then
    return
  end

  if self.chatting.sound then
    --self.chatting.sound:setPosition(self.x, self.y, 0)
    self.chatting.sound:stop()
    self.chatting.sound = nil
  end
  if self.chatting.match.chatting.sound then
    self.chatting.match.chatting.sound:stop()
    self.chatting.match.chatting.sound = nil
  end
  self.chatting.match.chatting = nil
  self.chatting = nil
end

function HandleCooldown(self, cooldown, dt, callback)
  if self.cooldowns[cooldown] > 0 then
    self.cooldowns[cooldown] = self.cooldowns[cooldown] - dt
    if self.cooldowns[cooldown] <= 0 then
      self.cooldowns[cooldown] = 0
      if callback then
        callback(self)
      end
    end
  end
end

function DisableTasteShow(self)
  self.taste.show = false
end

function BurnOut(self)
  self.state.lit = false
  if self.sounds.burn then
    self.sounds.burn:stop()
    self.sounds.burn = nil
  end
  self.state.burnt = true
end

function LightMatch(self, addSound)
  self.state.lit = true
  self.cooldowns.lit = 3

  if addSound then
    self.sounds.burn = Global.Sounds.Burn:clone()
    self.sounds.burn:play()
  end
end


function AnimateBounce(self, dt)
  if self.animation.stopBounce and self.animation.bounce == 0 then
    return
  end

  self.animation.bounce = self.animation.bounce + dt * 10
  if self.animation.bounce > math.pi then
    self.animation.bounce = self.animation.bounce - math.pi
    if self.sounds.step then
      --self.sounds.step:setPosition(self.x, self.y, 0)
      self.sounds.step:play()
    end
  end
end

function AnimateBurning(self, dt)
  if self.state.lit then
    self.animation.burning = self.animation.burning + dt * 5
    if self.animation.burning > math.pi then
      self.animation.burning = self.animation.burning - math.pi
    end
  end
end


function GoTowardMatch(self, otherMatch, dt)
  local diffX = otherMatch.x - self.x
  local diffY = otherMatch.y - self.y
  local mag = getMagnitude(diffX, diffY)

  if mag > MATCH_DIST then
    local unitX, unitY = getUnitVector(diffX, diffY)
    self.x = self.x + unitX * dt * MOVE_SPEED * 2 * love.math.random()
    self.y = self.y + unitY * dt * MOVE_SPEED * 2 * love.math.random()
    return false
  end

  return true
end

function GoToward(self, point, dt, moveSpeed)
  if moveSpeed == nil then
    moveSpeed = MOVE_SPEED * 2
  end
  local unitX, unitY = getUnitVector(point.x - self.x, point.y - self.y)
  self.x = self.x + unitX * dt * moveSpeed
  self.y = self.y + unitY * dt * moveSpeed
end


function ChatPair(self, match)
  local chatTime = 2 --love.math.random() * 2 + 0.5
  local sound = love.math.random(#Global.Sounds.Chat)

  self.chatting = {
    match = match,
    sound = Global.Sounds.Chat[sound]:clone(),
    chatTime = chatTime
  }
  if self.taste.dislike and love.math.random() > 0.6 then
    self.chatting.dislike = RandomChoice(self.taste.dislikes)
  else
    self.chatting.like = RandomChoice(self.taste.likes)
  end
  match.chatting = {
    match = self,
    chatTime = chatTime
  }
  if match.taste.dislike and love.math.random() > 0.6 then
    match.chatting.dislike = RandomChoice(match.taste.dislikes)
  else
    match.chatting.like = RandomChoice(match.taste.likes)
  end
end

function RandomWalk(self)
  local x = (love.math.random(Global.Width / 2) - Global.Width / 4) + self.x 
  local y = (love.math.random(Global.Height / 3) - Global.Height / 6) + self.y
  if x < 20 then x = 20
  elseif x > Global.Width - 20 then x = Global.Width - 20
  end
  if y < Global.Sizes.Match.Height + 40 then y = Global.Sizes.Match.Height + 40
  elseif y > Global.Height - 60 then y = Global.Height - 60
  end

  self.move.to = {
    x = x, y = y
  }
end

function PickNearbyMatch(self, allowPaired, allowChatting)
  local choices = {}
  for i, match in ipairs(Global.Matches) do
    if match ~= self and 
      (allowPaired or not match.paired) and 
      (allowChatting or not match.chatting) and
      not (match.state.lit or match.state.burnt or match.state.leaving or match.state.arriving) then
      table.insert(choices, match)
    end
  end

  if #choices then
    return RandomChoice(choices)
  end

  return nil
end

function EqualizePair(self, otherMatch, dt)
  local diffX = self.x - otherMatch.x
  local diffY = self.y - otherMatch.y
  local centerX = self.x - diffX / 2
  if math.abs(diffY) > 2 then
    GoToward(self, {
      x = diffX < 0 and (centerX - MATCH_DIST) or (centerX + MATCH_DIST),
      y = self.y - diffY / 2
    }, dt)
  end
end


function MatchPair(self, match)
  -- We're already matched haha
  if self.paired or self == match or
    self.state.leaving or match.state.leaving or
    self.state.arriving or match.state.arriving then
    return
  end

  local matchPercent = 0.5
  if not self.taste.dislikes and not match.taste.dislikes then
    if #self.taste.likes == #match.taste.likes then
      if #self.taste.likes == 1 then
        if self.taste.likes[1] == match.taste.likes[1] then
          matchPercent = 1
        else
          matchPercent = 0.25
        end
      elseif #self.taste.likes > 1 then
        local matchCount = 0
        for i, like in ipairs(self.taste.likes) do
          for j, matchLike in ipairs(match.taste.likes) do
            if like == matchLike then
              matchCount = matchCount + 1
            end
          end
        end
        matchPercent = math.min((matchCount * 2) / (#self.taste.likes + #match.taste.likes), 1)
      end
    elseif #self.taste.likes ~= #match.taste.likes then
      local matchCount = 0
      for i, like in ipairs(self.taste.likes) do
        for j, matchLike in ipairs(match.taste.likes) do
          if like == matchLike then
            matchCount = matchCount + 1
          end
        end
      end
      matchPercent = (matchCount * 2) / (#self.taste.likes + #match.taste.likes)
    end
  end

  --local matchPercent = love.math.random()
  if matchPercent > 0.75 then
    Global.Sounds.match100:play()
  elseif matchPercent > 0.5 then
    Global.Sounds.match75:play()
  elseif matchPercent > 0.25 then
    Global.Sounds.match50:play()
  else
    Global.Sounds.match25:play()
  end

  self.animation.bounce = 0
  match.animation.bounce = (math.pi / 2) * (1 - matchPercent)

  if self.chatting then
    EndChatting(self)
  end
  if match.chatting then
    EndChatting(match)
  end

  print('Match: ' .. matchPercent)
  local loveLevel = {
    level = matchPercent,
    --burnLevel = 10 * matchPercent,
    burnLevel = 10,
    burnSpeed = 0
  }

  if matchPercent < 1 then
    loveLevel.burnSpeed = 1 / matchPercent
  end

  self.move.to = nil
  self.move.by = nil
  match.move.to = nil
  match.move.by = nil

  self.paired = {
    match = match,
    original = true,
    loveLevel = loveLevel
  }

  match.paired = {
    match = self,
    loveLevel = loveLevel
  }
end


function MatchLeave(self)
  self.state.leaving = true
  local diffX = self.x - Global.Width / 2
  local diffY = self.y - Global.Height / 2
  self.move.to = {
    x = -30, y = self.y
  }
  if diffX > 0 then
    self.move.x = Global.Width + 30
  end

  EndChatting(self)

  self.paired = nil
end


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
  local match = MatchNew(startX, y)
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
    MatchUpdate(match, dt)
  end

  table.sort(Global.Matches, ZSortMatch)
end

function DrawMatches()
  for i, match in ipairs(Global.Matches) do
    MatchDraw(match)
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
