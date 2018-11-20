include("organizer-lib")

function get_sets()
    TP_Index = 1
    Idle_Index = 1

    ta_hands = {}
    acc_hands = {}
    wsd_hands = {}
    crit_hands = {}
    dt_hands = {}
    waltz_hands = {}

    sets.weapons = {}
    sets.weapons[1] = {main = "Dagger of Trials"}
    sets.weapons[2] = {main = "Dagger of Trials"}
    sets.weapons[3] = {main = "Dagger of Trials"}

    sets.JA = {}
    sets.JA["Perfect Dodge"] = {}
    sets.JA.Steal = {}
    sets.JA.Flee = {
        feet = "Rogue's Poulaines"
    }
    sets.JA.Despoil = {}
    sets.JA.Mug = {}
    sets.JA.Waltz = {}
    sets.JA.Hide = {
        body = "Rogue's Vest"
    }

    sets.WS = {}
    sets.WS.SA = {}
    sets.WS.TA = {}
    sets.WS.SATA = {}

    sets.WS.Evisceration = {}

    sets.WS["Rudra's Storm"] = {}

    sets.WS.SA["Rudra's Storm"] = set_combine(sets.WS["Rudra's Storm"], {})

    sets.WS.TA["Rudra's Storm"] = set_combine(sets.WS["Rudra's Storm"], {})

    sets.WS["Mandalic Stab"] = sets.WS["Rudra's Storm"]

    sets.WS.SA["Mandalic Stab"] = sets.WS.SA["Rudra's Storm"]

    sets.WS.TA["Mandalic Stab"] = sets.WS.TA["Rudra's Storm"]

    sets.WS.Exenterator = {}

    TP_Set_Names = {"Low Man", "Delay Cap", "Evasion", "TH", "Acc", "DT"}
    sets.TP = {
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
    sets.TP["Low Man"] = {
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

    sets.TP["TH"] = set_combine(sets.TP["Low Man"], {})

    sets.TP["Acc"] = {}

    sets.TP["Delay Cap"] = {}

    sets.TP.Evasion = {}

    sets.TP.DT = {}

    Idle_Set_Names = {"Normal", "MDT", "STP"}
    sets.Idle = {}
    sets.Idle.Normal = {
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

    sets.Idle.MDT = {}

    sets.Idle["STP"] = {}

    --send_command("input /macro book 12;wait .1;input /macro set 2")

    sets.FastCast = {}

    sets.frenzy = {}
end

function precast(spell)
    if sets.JA[spell.english] then
        equip(sets.JA[spell.english])
    elseif spell.type == "WeaponSkill" then
        if sets.WS[spell.english] then
            equip(sets.WS[spell.english])
        end
        if buffactive["sneak attack"] and buffactive["trick attack"] and sets.WS.SATA[spell.english] then
            equip(sets.WS.SATA[spell.english])
        elseif buffactive["sneak attack"] and sets.WS.SA[spell.english] then
            equip(sets.WS.SA[spell.english])
        elseif buffactive["trick attack"] and sets.WS.TA[spell.english] then
            equip(sets.WS.TA[spell.english])
        end
    elseif string.find(spell.english, "Waltz") then
        equip(sets.JA.Waltz)
    elseif spell.action_type == "Magic" then
        equip(sets.FastCast)
    end
end

function aftercast(spell)
    if player.status == "Engaged" then
        equip(sets.TP[TP_Set_Names[TP_Index]])
    else
        equip(sets.Idle[Idle_Set_Names[Idle_Index]])
    end
end

function status_change(new, old)
    if T {"Idle", "Resting"}:contains(new) then
        equip(sets.Idle[Idle_Set_Names[Idle_Index]])
    elseif new == "Engaged" then
        equip(sets.TP[TP_Set_Names[TP_Index]])
    end
end

function buff_change(buff, gain_or_loss)
    if buff == "Sneak Attack" then
        soloSA = gain_or_loss
    elseif buff == "Trick Attack" then
        soloTA = gain_or_loss
    elseif gain_or_loss and buff == "Sleep" and player.hp > 99 then
        print("putting on Frenzy sallet!")
        equip(sets.frenzy)
    end
end

function self_command(command)
    if command == "toggle TP set" then
        TP_Index = TP_Index + 1
        if TP_Index > #TP_Set_Names then
            TP_Index = 1
        end
        send_command("@input /echo ----- TP Set changed to " .. TP_Set_Names[TP_Index] .. " -----")
        equip(sets.TP[TP_Set_Names[TP_Index]])
    elseif command == "toggle Idle set" then
        Idle_Index = Idle_Index + 1
        if Idle_Index > #Idle_Set_Names then
            Idle_Index = 1
        end
        send_command("@input /echo ----- Idle Set changed to " .. Idle_Set_Names[Idle_Index] .. " -----")
        equip(sets.Idle[Idle_Set_Names[Idle_Index]])
    end
end
