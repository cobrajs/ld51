function GameLoad()
  ClearMatches()

  for i = 1, Global.Levels[Global.Level].MatchCount do
    AddRandomMatch()
  end

  Global.Countdown = 10
  Global.Level = 1
  Global.HeartsLevel = 1.5
  Global.MouseHover.Match = nil
  Global.HighlightMatch = nil
  Global.GameOver = false
  Global.Win = false
end

function GameDraw()
  love.graphics.clear(Global.Colors.Grass)

  DrawMatches()

  local countdownWidth = Global.Width * (Global.Countdown / 10)
  love.graphics.setColor(Global.Colors.MatchHeadFill)
  love.graphics.rectangle('fill', 0, Global.Height - 40, countdownWidth, 40)
  love.graphics.setColor(Global.Colors.Grass)
  love.graphics.rectangle('fill', countdownWidth, Global.Height - 40, Global.Width - countdownWidth, 40)
  love.graphics.setColor(Global.Colors.Outline)
  love.graphics.line(0, Global.Height - 40, Global.Width, Global.Height - 40)

  if Global.HeartsLevel > 0 then
    local hearts = math.floor(Global.HeartsLevel)
    for i = 1, hearts do
      renderHeart(i * 50, 50, 40, 1)
    end
    if Global.HeartsLevel % 1 > 0 then
      renderHalfHeart((hearts + 1) * 50, 50, 40)
    end
  end

  if Global.GameOver then
    DrawGameOver()
  end

  renderLevel(Global.Width - 30, 30, 50, Global.Level)
end

function GameUpdate(dt)
  if Global.GameOver then
    Global.GameOverBounce = Global.GameOverBounce + dt * 5
    if Global.GameOverBounce > math.pi * 2 then
      Global.GameOverBounce = Global.GameOverBounce - math.pi * 2
    end

    return
  end

  UpdateMatches(dt)

  Global.Countdown = decreaseTime(Global.Countdown, dt)
  if Global.Countdown <= 0 then
    Global.Countdown = 10
    
    CountdownEnded()
  end

  if Global.MouseHover.Time > 0 then
    Global.MouseHover.Time = Global.MouseHover.Time - dt
    if Global.MouseHover.Time <= 0 then
      Global.MouseHover.Time = 0
      if Global.MouseHover.Match then
        local mouse = {
          x = love.mouse.getX(),
          y = love.mouse.getY() + Global.Sizes.Match.Height / 2
        }
        if getDist(Global.MouseHover.Match, mouse) > 50 then
          Global.MouseHover.Match = nil
        end
      end
    end
  end
end

function GameMousePressed(x, y, button)
  local highlightMatch = NearestMatch(x, y, 50)
  if highlightMatch then
    --highlightMatch.chatting.match.chatting = nil
    --highlightMatch.chatting = nil
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

function GameMouseMoved(x, y, dx, dy)
  if Global.MouseHover.Time == 0 then
    local hoverMatch = NearestMatch(x, y, 50)
    if hoverMatch then
      Global.MouseHover.Match = hoverMatch
    else
      Global.MouseHover.Match = nil
    end
    Global.MouseHover.Time = 0.2
  end
end

function GameWheelMoved(x, y)
  print(x, y)
end


function CountdownEnded()
  print('Oh no')
  local heartsChange = 0
  local pairCount = 0
  local burntCount = 0
  for i, match in ipairs(Global.Matches) do
    if match.state.lit or match.state.burnt then
      burntCount = burntCount + 1
      MatchLeave(match)
    end

    if match.paired then
      pairCount = pairCount + 0.5
      MatchLeave(match)
    end
  end
  print('Pair count: ' .. pairCount)
  print('Burnt count: ' .. burntCount)

  if pairCount == 0 then
    heartsChange = -0.5
  else
    heartsChange = pairCount 
  end

  if burntCount > 0 then
    heartsChange = heartsChange - burntCount / 2
  end

  Global.HeartsLevel = Global.HeartsLevel + heartsChange
  if Global.HeartsLevel <= 0 then
    GameOver(false)
    return
  end
  print('Hearts to subtract: ' .. heartsChange)

  Global.Level = Global.Level + 1
  if Global.Level > #Global.Levels then
    GameOver(true)
  end
end


function GameOver(win)
  Global.GameOver = true
  Global.Win = win
  Global.GameOverBounce = 0
  for i, match in ipairs(Global.Matches) do
    if match.sounds.step then
      match.sounds.step:stop()
      match.sounds.step = nil
    end
    if match.chatting and match.chatting.sound then
      match.chatting.sound:stop()
      match.chatting.sound = nil
    end
    match.animation.bounce = 0
  end
end

function DrawGameOver()
  love.graphics.setColor(0, 0, 0, 0.2)
  love.graphics.rectangle('fill', 0, 0, Global.Width, Global.Height)

  local text = "Game Over!"
  if Global.Win then
    text = "You Win!"
  end
  love.graphics.setColor(Global.Colors.White)
  love.graphics.print(text, Global.Width / 2 - 50, Global.Height / 2 - 5 + math.floor(math.sin(Global.GameOverBounce) * 10))
end

