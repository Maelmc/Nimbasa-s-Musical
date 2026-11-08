local current_mod = SMODS.current_mod

local config_pages = {
  blinds = 1,
  jokers = 1,
}

local config_card_areas = {
  blinds = {},
  jokers = {},
}

local function get_affected_keys(entry)
  local keys = entry[1]
  if type(keys) ~= "table" then
    return {keys}
  end
  return keys
end

local function clear_config_card_areas(category)
  for _, cardarea in ipairs(config_card_areas[category]) do
    cardarea:remove()
  end
  config_card_areas[category] = {}
end

local config_tile_width = G.CARD_W * 1.5
local config_tile_height = G.CARD_H + 0.75
local config_cardarea_width = G.CARD_W * 1.3
local config_cardarea_height = G.CARD_H + 0.15

local function create_config_cardarea(keys, is_blind, category)
  local cardarea = CardArea(
    G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
    G.ROOM.T.h,
    config_cardarea_width,
    config_cardarea_height,
    {
      card_limit = #keys,
      type = "title_2",
      highlight_limit = 0,
      collection = true,
    }
  )
  config_card_areas[category][#config_card_areas[category] + 1] = cardarea

  for _, key in ipairs(keys) do
    local card = PokeDisplayCard({
      existing_key = key,
      set = is_blind and "Blind" or "Joker",
      display_text = false,
    }, cardarea.T.x, cardarea.T.y)
    card.no_ui = true
    cardarea:emplace(card)
  end

  return {n = G.UIT.O, config = {align = "cm", object = cardarea}}
end

local function create_config_tile(entry, is_blind, category)
  local theme_key = entry[2]
  local affected_keys = get_affected_keys(entry)
  local enabled = NIMMU.config[theme_key]
  return {
    n = G.UIT.C,
    config = {
      align = "cm",
      minw = config_tile_width,
      minh = config_tile_height,
      padding = 0.04,
    },
    nodes = {
      {
        n = G.UIT.R,
        config = {
          align = "cm",
          minw = config_tile_width,
          minh = G.CARD_H + 0.15,
          padding = 0.04,
          r = 0.1,
          colour = enabled and G.C.GREEN or G.C.RED,
          hover = true,
          shadow = true,
          button = "nimmu_toggle_theme",
          ref_table = NIMMU.config,
          ref_value = theme_key,
          theme_key = theme_key,
        },
        nodes = {create_config_cardarea(affected_keys, is_blind, category)},
      },
      {
        n = G.UIT.R,
        config = {align = "cm", minw = config_tile_width, minh = 0.5, padding = 0.03},
        nodes = {
          {n = G.UIT.T, config = {
            text = localize("nimmu_" .. theme_key),
            scale = 0.32,
            colour = G.C.UI.TEXT_LIGHT,
            shadow = true,
          }},
        },
      },
    },
  }
end

local function create_config_page(category, is_blind)
  clear_config_card_areas(category)
  local entries = is_blind and NIMMU.blinds or NIMMU.jokers
  local page_count = math.max(math.ceil(#entries / 6), 1)
  config_pages[category] = math.min(config_pages[category], page_count)
  local page = config_pages[category]
  local tiles = {}

  for index = (page - 1) * 6 + 1, math.min(page * 6, #entries) do
    tiles[#tiles + 1] = create_config_tile(entries[index], is_blind, category)
  end

  local rows = {}
  for first = 1, #tiles, 3 do
    local row_nodes = {}
    for index = first, math.min(first + 2, #tiles) do
      row_nodes[#row_nodes + 1] = tiles[index]
    end
    rows[#rows + 1] = row_nodes
  end

  while #rows < 2 do
    rows[#rows + 1] = {}
  end
  for _, row in ipairs(rows) do
    local leading_padding = math.floor((3 - #row) / 2)
    for _ = 1, leading_padding do
      table.insert(row, 1, {
        n = G.UIT.C,
        config = {align = "cm", minw = config_tile_width, minh = config_tile_height},
        nodes = {},
      })
    end
    while #row < 3 do
      row[#row + 1] = {
        n = G.UIT.C,
        config = {align = "cm", minw = config_tile_width, minh = config_tile_height},
        nodes = {},
      }
    end
  end

  local grid_width = config_tile_width * 3
  local grid_height = config_tile_height * 2
  return {
    n = G.UIT.ROOT,
    config = {align = "cm", padding = 0.05, colour = G.C.CLEAR, minw = grid_width, minh = grid_height + 0.8},
    nodes = {
      {
        n = G.UIT.C,
        config = {align = "cm", minw = grid_width, minh = grid_height + 0.8},
        nodes = {
          {
            n = G.UIT.R,
            config = {align = "cm", minw = grid_width, minh = grid_height},
            nodes = {
              {n = G.UIT.R, config = {align = "cm", minw = grid_width, minh = config_tile_height}, nodes = rows[1]},
              {n = G.UIT.R, config = {align = "cm", minw = grid_width, minh = config_tile_height}, nodes = rows[2]},
            },
          },
          {
            n = G.UIT.R,
            config = {align = "cm", minw = grid_width, minh = 0.8, padding = 0.08},
            nodes = {
              {
                n = G.UIT.C,
                config = {
                  align = "cm",
                  minw = 0.65,
                  minh = 0.55,
                  padding = 0.05,
                  r = 0.1,
                  colour = page > 1 and G.C.RED or G.C.GREY,
                  hover = page > 1,
                  button = page > 1 and "nimmu_previous_config_page" or nil,
                  category = category,
                },
                nodes = {{n = G.UIT.T, config = {text = "<", scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}},
              },
              {
                n = G.UIT.C,
                config = {align = "cm", minw = 1.8},
                nodes = {{n = G.UIT.T, config = {
                  text = page .. " / " .. page_count,
                  scale = 0.4,
                  colour = G.C.UI.TEXT_LIGHT,
                }}},
              },
              {
                n = G.UIT.C,
                config = {
                  align = "cm",
                  minw = 0.65,
                  minh = 0.55,
                  padding = 0.05,
                  r = 0.1,
                  colour = page < page_count and G.C.RED or G.C.GREY,
                  hover = page < page_count,
                  button = page < page_count and "nimmu_next_config_page" or nil,
                  category = category,
                },
                nodes = {{n = G.UIT.T, config = {text = ">", scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}},
              },
            },
          },
        },
      },
    },
  }
end

local function refresh_config_page(category, is_blind)
  local content = G.OVERLAY_MENU:get_UIE_by_ID("nimmu_" .. category .. "_content")
  content.config.object:remove()
  content.config.object = UIBox({
    definition = create_config_page(category, is_blind),
    config = {parent = content, colour = G.C.CLEAR},
  })
  content.UIBox:recalculate()
end

G.FUNCS.nimmu_toggle_theme = function(element)
  local theme_key = element.config.ref_value
  local config = element.config.ref_table
  config[theme_key] = not config[theme_key]
  element.config.colour = config[theme_key] and G.C.GREEN or G.C.RED
  SMODS.save_mod_config(current_mod)
end

G.FUNCS.nimmu_previous_config_page = function(element)
  local category = element.config.category
  config_pages[category] = config_pages[category] - 1
  refresh_config_page(category, category == "blinds")
end

G.FUNCS.nimmu_next_config_page = function(element)
  local category = element.config.category
  config_pages[category] = config_pages[category] + 1
  refresh_config_page(category, category == "blinds")
end

SMODS.current_mod.extra_tabs = function()
  return {
    {
      label = localize("nimmu_blinds"),
      tab_definition_function = function()
        local content = UIBox({
          definition = create_config_page("blinds", true),
          config = {colour = G.C.CLEAR},
        })
        return {
          n = G.UIT.ROOT,
          config = {align = "cm", padding = 0.05, colour = G.C.CLEAR},
          nodes = {{n = G.UIT.O, config = {id = "nimmu_blinds_content", object = content}}},
        }
      end,
    },
    {
      label = localize("nimmu_jokers"),
      tab_definition_function = function()
        local content = UIBox({
          definition = create_config_page("jokers", false),
          config = {colour = G.C.CLEAR},
        })
        return {
          n = G.UIT.ROOT,
          config = {align = "cm", padding = 0.05, colour = G.C.CLEAR},
          nodes = {{n = G.UIT.O, config = {id = "nimmu_jokers_content", object = content}}},
        }
      end,
    },
  }
end
