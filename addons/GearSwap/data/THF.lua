-------------------------------------------------------------------------------------------------------------------
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include("Mote-Include.lua")
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    -- Resting sets
    sets.resting = {
        main = "Dagger of Trials",
        sub = "Eminent Dagger",
        range = "Long Boomerang",
        head = "Espial Cap",
        body = "Espial Gambison",
        hands = "Espial Bracers",
        legs = "Espial Hose",
        feet = "Espial Socks",
        neck = "Spike Necklace",
        waist = "Key Ring Belt",
        left_ear = "Fang Earring",
        right_ear = "Fang Earring",
        left_ring = "Enlivened Ring",
        right_ring = "Warp Ring",
        back = "Cuchulain's Mantle"
    }

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
        main = "Dagger of Trials",
        sub = "Eminent Dagger",
        range = "Long Boomerang",
        head = "Espial Cap",
        body = "Espial Gambison",
        hands = "Espial Bracers",
        legs = "Espial Hose",
        feet = "Areion Boots",
        neck = "Spike Necklace",
        waist = "Key Ring Belt",
        left_ear = "Fang Earring",
        right_ear = "Fang Earring",
        left_ring = "Enlivened Ring",
        right_ring = "Warp Ring",
        back = "Cuchulain's Mantle"
    }

    sets.idle.Town = {
        main = "Pitchfork +1",
        range = "Long Boomerang",
        head = "Green Ribbon +1",
        body = "Savage Separates",
        hands = "Savage Gauntlets",
        legs = "Savage Loincloth",
        feet = "Areion Boots",
        left_ring = "Echad Ring",
        right_ring = "Warp Ring"
    }
    -- Defense sets

    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
    sets.engaged = {
        main = "Dagger of Trials",
        sub = "Eminent Dagger",
        range = "Long Boomerang",
        head = "Espial Cap",
        body = "Espial Gambison",
        hands = "Espial Bracers",
        legs = "Espial Hose",
        feet = "Espial Socks",
        neck = "Spike Necklace",
        waist = "Key Ring Belt",
        left_ear = "Fang Earring",
        right_ear = "Fang Earring",
        left_ring = "Enlivened Ring",
        right_ring = "Warp Ring",
        back = "Cuchulain's Mantle"
    }
end
