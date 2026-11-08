NIMMU = {}

NIMMU.config = SMODS.current_mod.config
NIMMU.start = {}

SMODS.Atlas({
  key = "modicon",
  path = "icon.png",
  px = 171,
  py = 171
})

function NIMMU.table_contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

NIMMU.blind_theme = function(blind_keys, theme_name, volume, has_intro, play_loop_after)
  if type(blind_keys) ~= "table" then blind_keys = {blind_keys} end

  if has_intro and play_loop_after then

    SMODS.Sound({
      key = theme_name.."_intro_music",
      path = theme_name.."_intro_music.ogg",
      select_music_track = function()
        if NIMMU.config[theme_name] then
          if G.GAME and G.GAME.blind and NIMMU.table_contains(blind_keys, G.GAME.blind.name) then
            if not NIMMU.start[theme_name] then
              NIMMU.start[theme_name] = G.TIMERS.REAL
              return 3
            end
            return 3
          end
        end
        NIMMU.start[theme_name] = nil
      end,
      sync = false,
      pitch = 1,
      volume = volume or 0.8,
    })

    SMODS.Sound({
      key = theme_name.."_loop_music",
      path = theme_name.."_loop_music.ogg",
      select_music_track = function()
        if NIMMU.config[theme_name] then
          if G.GAME and G.GAME.blind and NIMMU.table_contains(blind_keys, G.GAME.blind.name) then
            if NIMMU.start[theme_name] then
              local elapsed = G.TIMERS.REAL - NIMMU.start[theme_name]
              if elapsed >= play_loop_after then
                return 4
              else
                return false
              end
            end
          end
        end
      end,
      sync = false,
      pitch = 1,
      volume = volume or 0.8,
    })

  else

    SMODS.Sound({
      key = blind_keys.."_loop_music",
      path = blind_keys.."_loop_music.ogg",
      select_music_track = function()
        if NIMMU.config[theme_name] and G.GAME and G.GAME.blind and NIMMU.table_contains(blind_keys, G.GAME.blind.name) then
          return 3
        end
      end,
      sync = false,
      pitch = 1,
      volume = volume or 0.8,
    })

  end
end

NIMMU.joker_theme = function(joker_keys, theme_name, volume, has_intro, play_loop_after)
  if type(joker_keys) ~= "table" then joker_keys = {joker_keys} end

  if has_intro and play_loop_after then

    SMODS.Sound({
      key = theme_name.."_intro_music",
      path = theme_name.."_intro_music.ogg",
      select_music_track = function()
        if NIMMU.config[theme_name] then
          for _, v in pairs(joker_keys) do
            if next(SMODS.find_card(v)) then
              if not NIMMU.start[theme_name] then
                NIMMU.start[theme_name] = G.TIMERS.REAL
              end
              return 1
            end
          end
        end
        NIMMU.start[theme_name] = nil
      end,
      sync = false,
      pitch = 1,
      volume = volume or 0.8,
    })

    SMODS.Sound({
      key = theme_name.."_loop_music",
      path = theme_name.."_loop_music.ogg",
      select_music_track = function()
        if NIMMU.config[theme_name] then
          for _, v in pairs(joker_keys) do
            if next(SMODS.find_card(v)) then
              if NIMMU.start[theme_name] then
                local elapsed = G.TIMERS.REAL - NIMMU.start[theme_name]
                if elapsed >= play_loop_after then
                  return 2
                else
                  return false
                end
              end
            end
          end
        end
      end,
      sync = false,
      pitch = 1,
      volume = volume or 0.8,
    })

  else

    SMODS.Sound({
      key = theme_name.."_loop_music",
      path = theme_name.."_loop_music.ogg",
      select_music_track = function()
        if NIMMU.config[theme_name] then
          for _, v in pairs(joker_keys) do
            if next(SMODS.find_card(v)) then
              return 2
            end
          end
        end
      end,
      sync = false,
      pitch = 1,
      volume = volume or 0.8,
    })

  end
end

assert(SMODS.load_file("src/jokers.lua"))()
assert(SMODS.load_file("src/blinds.lua"))()
assert(SMODS.load_file("src/config_tab.lua"))()