-- {joker key or list of keys, music key, volume, has an intro, after how long switch from intro to loop}
NIMMU.jokers = {
  {{"j_poke_articuno", "j_poke_zapdos", "j_poke_moltres", "j_poke_mewtwo", "j_poke_mega_mewtwo_x", "j_poke_mega_mewtwo_y"}, "kanto_legendary", 0.8, true, 52.33333},
  {"j_poke_raikou", "j_poke_raikou", 0.8, true, 12.7},
  {"j_poke_entei", "j_poke_entei", 0.8, true, 13.6},
  {"j_poke_suicune", "j_poke_suicune", 0.8, true, 12.66666},
  {"j_poke_ho_oh", "j_poke_ho_oh", 0.8, true, 39.53333},
  {"j_poke_lugia", "j_poke_lugia", 0.8, true, 19.86666},
  {"j_poke_deoxys", "j_poke_deoxys", 0.8, true, 58.13333},
}

for _, v in pairs(NIMMU.jokers) do
  NIMMU.joker_theme(v[1], v[2], v[3], v[4], v[5])
end