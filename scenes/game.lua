function GameLoad()
  ClearMatches()

  for i = 1, 6 do
    AddRandomMatch()
  end

  Global.Countdown = 10
  Global.Level = 1
  Global.HeartsLevel = 1.5
  Global.MouseHover.Match = nil
  Global.HighlightMatch = nil
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

  local hearts = math.floor(Global.HeartsLevel)
  for i = 1, hearts do
    renderHeart(i * 50, 50, 40, 1)
  end
  if Global.HeartsLevel % 1 > 0 then
    renderHalfHeart((hearts + 1) * 50, 50, 40)
  end
end

function GameUpdate(dt)
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
      Global.MouseHover.Match = nil
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
    end

    if match.paired then
      pairCount = pairCount + 0.5
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

  print('Hearts to subtract: ' .. heartsChange)
end

