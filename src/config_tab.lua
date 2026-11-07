SMODS.current_mod.extra_tabs = function()
    return {
      {
        label = localize("nimmu_blinds"),
        tab_definition_function = function()
          local nodes = {}
          for _, v in ipairs(NIMMU.blinds) do
            nodes[#nodes+1] = {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    padding = 0.25,
                    colour = G.C.CLEAR,
                },
                nodes = {
                  create_toggle({
                    label = localize{
                      type = "name_text",
                      key = type(v[1]) == "table" and v[1][1] or v[1],
                      set = "Blind"
                    },
                    ref_table = NIMMU.config,
                    ref_value = v[2],
                  })
                },
              }
          end

          return {
            n = G.UIT.ROOT,
            config = {
              align = "cm",
              padding = 0.05,
              colour = G.C.CLEAR,
            },
            nodes = nodes
          }
        end
      },

      {
        label = localize("nimmu_jokers"),
        tab_definition_function = function()
          local nodes = {}
          for _, v in ipairs(NIMMU.jokers) do
            nodes[#nodes+1] = {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    padding = 0.25,
                    colour = G.C.CLEAR,
                },
                nodes = {
                  create_toggle({
                    label = localize{
                      type = "name_text",
                      key = type(v[1]) == "table" and v[1][1] or v[1],
                      set = "Joker"
                    },
                    ref_table = NIMMU.config,
                    ref_value = v[2],
                  })
                },
              }
          end

          return {
            n = G.UIT.ROOT,
            config = {
              align = "cm",
              padding = 0.05,
              colour = G.C.CLEAR,
            },
            nodes = nodes
          }
        end
      },
    }
end