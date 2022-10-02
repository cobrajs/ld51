function getColor(r, g, b, a)
  local rr, gg, bb = love.math.colorFromBytes(r, g, b)
  return {rr, gg, bb, a}
end

local Global = {
  Colors = {
    --MatchStickFill = getColor(225, 218, 189),
    MatchStickFill = getColor(196, 167, 125),
    MatchStickBurntFill = getColor(45, 35, 46, 0.7),
    MatchHeadFill = getColor(196, 32, 33),
    MatchHeadBurnFill = getColor(234, 196, 53),
    HeartFill = getColor(194, 140, 174),
    Outline = getColor(45, 35, 46),
    Grass = getColor(0, 207, 193),
    White = getColor(255, 255, 255),
    HoverOutline = getColor(45, 35, 46, 0.5),
  },
  
  -- Assets
  Sounds = {
    match100 = love.audio.newSource('assets/sfx/100_match.ogg', 'static'),
    match75 = love.audio.newSource('assets/sfx/75_match.ogg', 'static'),
    match50 = love.audio.newSource('assets/sfx/50_match.ogg', 'static'),
    match25 = love.audio.newSource('assets/sfx/25_match.ogg', 'static'),

    Burn = love.audio.newSource('assets/sfx/burn.ogg', 'static'),

    Step = {
      love.audio.newSource('assets/sfx/step1.ogg', 'static'),
      love.audio.newSource('assets/sfx/step2.ogg', 'static'),
    },

    Chat = {
      love.audio.newSource('assets/sfx/chat1.ogg', 'static'),
      love.audio.newSource('assets/sfx/chat2.ogg', 'static'),
      love.audio.newSource('assets/sfx/chat3.ogg', 'static'),
    }
  },
  Images = {
  },
  Prerendered = {
    LikeBubble = {
    },
    LikeThought = {
    }
  },

  -- Game Entities
  Matches = {},

  -- Game State Details
  Scene = 'game',
  Level = 1,
  Countdown = 0,
  HeartsLevel = 2,
  MouseHover = {
    Time = 0,
    Match = nil
  },
  GameOver = false,
  Win = false,
  GameOverBounce = 0,

  -- Levels Info
  Levels = {
    {
      Likes = {1, 2},
      Dislikes = nil,
      MaxLikes = 1,
      MinLikes = 1,
      MaxDislikes = 0,
      MinDislikes = 0,
      MatchCount = 4,
    },
    {
      Likes = {1, 2, 3},
      Dislikes = nil,
      MaxLikes = 2,
      MinLikes = 1,
      MaxDislikes = 0,
      MinDislikes = 0,
      MatchCount = 6
    },
    {
      Likes = {1, 2, 3},
      Dislikes = {1, 2},
      MaxLikes = 2,
      MinLikes = 2,
      MaxDislikes = 1,
      MinDislikes = 0,
      MatchCount = 8
    },
    {
      Likes = {1, 2, 3, 4},
      Dislikes = {1, 2, 3, 4},
      MaxLikes = 2,
      MinLikes = 2,
      MaxDislikes = 1,
      MinDislikes = 0,
      MatchCount = 12
    },
    {
      Likes = {1, 2, 3, 4, 5},
      Dislikes = {1, 2, 3, 4, 5},
      MaxLikes = 2,
      MinLikes = 2,
      MaxDislikes = 1,
      MinDislikes = 1,
      MatchCount = 14
    }
  },

  Sizes = {
    Like = 32,
    LikeRadius = 16,
    Match = {
      Width = 20,
      Height = 80,
      Stick = {
        Width = 16,
        Height = 70
      },
      Head = {
        Width = 12,
        Height = 14
      }
    }
  }
}

Global.ChangeScene = function(scene)
  Global.Scene = scene
end

return Global
