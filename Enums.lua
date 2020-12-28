local DM = DodgeMaster
DM.Enums = {}

--Format for cone is angle, length
--Format for rect is width, length
DM.Enums.Casts = {
    --Shadowlands

    --NecroticWake
    [324323] = {"cone", 5, 120}, --Gruesome Cleave
    -- [333489] = {"rect", 25, 10}, --Amarth Necrotic Breath???????????????????????
    [333477] = {"cone", 10, 60}, -- Gut Slice
    --De Other Side
    [334051] = {"rect", 20, 7}, --Erupting Darkness
    --Mists of Tirna Scithe
    [323137] = {"cone", 35, 20}, --Bewildering Pollen
    [321968] = {"cone", 35, 20}, --Bewildering Pollen
    [340160] = {"cone", 20, 45}, --Radiant Breath
    [340300] = {"cone", 12, 60}, --Tongue Lashing
    --PlagueFall
    [328395] = {"cone", 15, 30}, --Venompiercer
    [330404] = {"rect", 15, 10}, --Wing Buffet
    [318949] = {"cone", 20, 60}, --FesteringBelch
    [327233] = {"cone", 30, 45}, --Belch Plague
    --Halls of Attonement
    -- [325797] = {"cone"} -- Rapid Fire 325797 325793 325799 not found
    --322936 First boss ???
    [346866] = {"cone", 15, 60}, --Stone Breath
    [325523] = {"cone", 8, 40}, --Deadly Thrust
    [326623] = {"cone", 8, 90}, --Reaping Strike
    [326997] = {"cone", 7, 60}, --Powerful Swipe
    [323236] = {"cone", 25, 30}, --Unleashed Suffering
    --Sanguine Depths
    [320991] = {"rect", 8, 5}, --Echoing Thrust ??? add areatriggers
    [322429] = {"cone", 8, 60}, --Severing Slice
    --Spires of Ascension
    [317943] = {"cone", 8, 60}, --Sweeping Blow
    [323943] = {"rect", 25, 4}, --Run Through
    [324205] = {"cone", 30, 25}, --Blinding Flash
    --Theeatre of Pain

    --misc
    [331718] = {"cone", 60, 15}, --Spear Flurry ???
    [333294] = {"rect", 25, 10}, --Death Winds ??? or 333297
    [334329] = {"cone", 60, 15}, --Sweeping Slash
    -- [330403] = {"rect", 10, 20}, --WingBuffet ???
    [329518] = {"cone", 60, 20},
    [326455] = {"cone", 75, 10}
}
