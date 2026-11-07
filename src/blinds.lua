NIMMU.blinds = {
  {"bl_poke_mirror", "kanto_wild", 0.8, true, 2.866},
  {{"bl_poke_rocket", "bl_poke_white_executive"}, "bl_poke_rocket", 0.8, true, 52.333},
  {"bl_poke_gray_godfather", "bl_poke_gray_godfather", 0.7, true, 4.533},
  {"bl_poke_star", "bl_poke_star", 0.8, true, 40.5},
  {"bl_poke_iridescent_hacker", "bl_poke_iridescent_hacker", 0.8, true, 174.966},
}

for _, v in pairs(NIMMU.blinds) do
  NIMMU.blind_theme(v[1], v[2], v[3], v[4], v[5])
end