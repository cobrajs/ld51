function getColor(r, g, b)
  local rr, gg, bb = love.math.colorFromBytes(r, g, b)
  return {rr, gg, bb}
end

local Global = {
  Colors = {
    --MatchStickFill = getColor(225, 218, 189),
    MatchStickFill = getColor(196, 167, 125),
    MatchStickBurntFill = getColor(45, 35, 46),
    MatchHeadFill = getColor(196, 32, 33),
    HeartFill = getColor(194, 140, 174),
    Outline = getColor(45, 35, 46),
    Grass = getColor(0, 207, 193),
    White = getColor(255, 255, 255)
  },
  
  -- Assets
  Sounds = {
    match100 = love.audio.newSource('assets/audio/100_match.ogg', 'static'),
    match75 = love.audio.newSource('assets/audio/75_match.ogg', 'static'),
    match50 = love.audio.newSource('assets/audio/50_match.ogg', 'static'),
    match25 = love.audio.newSource('assets/audio/25_match.ogg', 'static')
  },
  Images = {
  },

  -- Game Entities
  Matches = {},

  -- Game State Details
  Level = 1,
  MouseHover = {
    Time = 0,
    Match = nil
  },

  -- Levels Info
  Levels = {
    {
      Likes = {1, 2, 3},
      Dislikes = nil,
      MaxLikes = 2,
      MinLikes = 1,
      MaxDislikes = 0,
      MinDislikes = 0
    },
  }
}

return Global
