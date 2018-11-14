-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Mod')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('Evasion', 'PDT')


    --gear.default.weaponskill_neck = "Spike Necklace" -- STR +3 DEX +3 MND -6
    --gear.default.weaponskill_waist = "Key Ring Belt" -- DEF: 2 DEX +1 "Steal" +1
    --gear.AugQuiahuiz = {name="Quiahuiz Trousers", augments={'Haste+2','"Snapshot"+2','STR+8'}}

    -- Additional local binds
    -- Supported Modifiers
    -- Modifier 	Description
    -- ^ 	Ctrl
    -- ! 	Alt
    -- @ 	Win
    -- # 	Apps
	-- send_command('bind f9 gs c cycle OffenseMode')
	-- send_command('bind ^f9 gs c cycle HybridMode')
	-- send_command('bind !f9 gs c cycle RangedMode')
	-- send_command('bind @f9 gs c cycle WeaponskillMode')
	-- send_command('bind f10 gs c set DefenseMode Physical')
	-- send_command('bind ^f10 gs c cycle PhysicalDefenseMode')
	-- send_command('bind !f10 gs c toggle Kiting')
	-- send_command('bind f11 gs c set DefenseMode Magical')
	-- send_command('bind ^f11 gs c cycle CastingMode')
	-- send_command('bind f12 gs c update user')
	-- send_command('bind ^f12 gs c cycle IdleMode')
	-- send_command('bind !f12 gs c reset DefenseMode')
	-- send_command('bind ^- gs c toggle selectnpctargets')
	-- send_command('bind ^= gs c cycle pctargetmode')
    -- full keymapping http://docs.windower.net/commands/keymapping/
    
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !- gs c cycle targetmode')

    --select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^=')
    send_command('unbind !-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {}
    sets.ExtraRegen = {}
    sets.Kiting = {
        feet="Areion Boots", -- DEF:4 AGI+2 Movement speed +12% Latent effect: "Flee", (Flee activates ~10% of the time when hit.)
    }

    -- Base damage is the sum of these following things:

    -- Weapon Base Damage (D)
    -- Ammo Damage (if the calculation is for ranged attack) (aD)
    -- STR - VIT Difference Function (fSTR or fSTR2) (your strength minus enemy vitality)
            -- fSTR is the damage bonus/penalty from your STR - monster VIT for melee attack
            --     Melee attacks need roughly 4~6 STR to increase fSTR value by 1.
            --     When STR-VIT value is high, fSTR can be approximated by ((your STR - monster VIT)+4)/4.
            --     fSTR's lower and upper cap values are affected by weapon rank.
            --     The lower cap of fSTR is - Weapon Rank
            --         Exception: Rank 0 weapons have lower cap -1.
            --     The upper cap of fSTR is ( weapon rank+8).
            -- Example:
            --     Juggernaut is a rank 5 weapon (int(46/9) = 5). Therefore the possible fSTR value of Juggernaut ranges from -5 to 5+8=13. 
    -- Weapon Skill Secondary Attribute Modifier (WSC) (only for WS Calculation)

    -- So, Base Damage = D + (aD) + fSTR(2) for normal attack
    -- and Base Damage = floor((D + (aD) + fSTR(2) + WSC)* fTP) for WS

    -- for THF Main, SATA + Normal hit is calculated as Base Damage = floor(D + fSTR) + Total AGI + Total DEX.
    -- Similarly, THF Main SATA+WS is calculated as Base Damage = floor((D + fSTR + WSC)* fTP) + Total AGI + Total DEX

    -- https://ffxiclopedia.fandom.com/wiki/Talk:Thief_Weapon_Skill_Damage_Guide_by_Malizia
    -- For Sneak Attack: Damage = (Base Damage + Total DEX) x critical hit pDIF 
    -- DEX is most important
    sets.buff['Sneak Attack'] = {
        ammo="Bomb Core", -- Fire-6 Attack +12
        head="Zeal Cap", -- DEF: 19 Accuracy +2 Attack +2 Haste +1%
        left_ear="Fang Earring", -- Attack +4 Evasion -4
        right_ear="Fang Earring", -- Attack +4 Evasion -4
        neck="Spike Necklace", -- STR +3 DEX +3 MND -6
        body="Antares Harness", -- DEF: 50 HP +15 DEX +8 AGI +8 Accuracy +8 Evasion +8
        back="Cuchulain's Mantle", -- DEF: 8 STR +4 DEX +4 Accuracy +5
        waist="Key Ring Belt", -- DEF: 2 DEX +1 "Steal" +1
        hands="Rogue's Armlets", -- DEF: 15 HP +10 DEX +3 Ice+10 "Steal" +1
        left_ring="Fluorite Ring", -- DEX +3  Lightning+7
        right_ring="Fluorite Ring", -- DEX +3  Lightning+7
        legs="Dragon Subligar", -- DEF: 32 DEX +4 "Subtle Blow" +5 Breath damage taken -3% Enmity +2
        feet="Adsilio Boots +1", -- DEF:14 DEX +5 AGI +5 Accuracy +3 Haste +1%
    }

    -- For Trick Attack: Damage = (Base Damage + Total AGI) x pDIF 
    -- AGI is most important
    sets.buff['Trick Attack'] = {
        range="Long Boomerang", -- DMG: 18 Delay: 294 AGI +2
        head="Noct Beret", -- DEF: 9 AGI +1  Dark+1
        left_ear="Fang Earring", -- Attack +4 Evasion -4
        right_ear="Fang Earring", -- Attack +4 Evasion -4
        neck="Spike Necklace", -- STR +3 DEX +3 MND -6
        body="Antares Harness", -- DEF: 50 HP +15 DEX +8 AGI +8 Accuracy +8 Evasion +8
        back="Cerberus Mantle", -- DEF: 12 STR +3 Trans Fire+10 Attack +12 Enmity +3
        waist="Scouter's Rope", -- DEF: 6 HP -40 AGI +4 Evasion +10
        hands="Lgn. Mittens", -- DEF: 3 Attack +3
        left_ring="Fluorite Ring", -- DEX +3  Lightning+7
        right_ring="Fluorite Ring", -- DEX +3  Lightning+7
        legs="Rogue's Culottes", -- DEF: 32 HP +15 AGI +4 Shield skill +10 "Steal" +1
        feet="Adsilio Boots +1", -- DEF:14 DEX +5 AGI +5 Accuracy +3 Haste +1%
    }

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {}
    sets.precast.JA['Accomplice'] = {}
    sets.precast.JA['Flee'] = {
        feet="Rogue's Poulaines", -- DEF: 13 HP +12 DEX +3 Increases "Flee" duration "Steal" +2
    }
    sets.precast.JA['Hide'] = {
        body="Rogue's Vest", -- DEF: 44 HP +20 STR +3  Earth+10 Increases "Hide" duration
    }
    sets.precast.JA['Conspirator'] = {}
    sets.precast.JA['Steal'] = {
        head="Rogue's Bonnet", -- DEF: 23 HP +13 INT +5 Parrying skill +10 "Steal" +1
        waist="Key Ring Belt", -- DEF: 2 DEX +1 "Steal" +1
        hands="Rogue's Armlets", -- DEF: 15 HP +10 DEX +3 Ice+10 "Steal" +1
        legs="Rogue's Culottes", -- DEF: 32 HP +15 AGI +4 Shield skill +10 "Steal" +1
        feet="Rogue's Poulaines", -- DEF: 13 HP +12 DEX +3 Increases "Flee" duration "Steal" +2
    }
    sets.precast.JA['Despoil'] = sets.precast.JA['Steal']
    sets.precast.JA['Perfect Dodge'] = {}
    sets.precast.JA['Feint'] = {}

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']


    -- Waltz set (chr and vit)
    -- Amount Healed = floor(((Target's VIT + Caster's CHR)*0.125 + 60),1) 
    sets.precast.Waltz = {
        body="Savage Separates", -- DEF: 18 HP +32 STR +1 CHR +1
        feet="Savage Gaiters", -- DEF: 5 HP +16 STR +3 CHR +2
    }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fast cast sets for spells
    sets.precast.FC = {}

    --sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})


    -- Ranged snapshot gear
    sets.precast.RA = {
        range="Long Boomerang", -- DMG: 18 Delay: 294 AGI +2
        back="Sniper's Mantle", -- DEF: 4 Attack +2 Ranged Attack +1
        hands="Noct Gloves", -- DEF: 5  Dark+1 Ranged Accuracy +1
        legs="Noct Brais", -- DEF: 12 DEX +1  Dark+1 Ranged Accuracy +1
    }


    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    -- focus on attack and strength, assume guaranteed hit
    sets.precast.WS = {
        ammo="Bomb Core", -- Fire-6 Attack +12
        head="Zeal Cap", -- DEF: 19 Accuracy +2 Attack +2 Haste +1%
        back="Cerberus Mantle", -- DEF: 12 STR +3 Trans Fire+10 Attack +12 Enmity +3
        left_ear="Fang Earring", -- Attack +4 Evasion -4
        right_ear="Fang Earring", -- Attack +4 Evasion -4
    }
    --sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Honed Tathlum", back="Letalis Mantle"})
    -- sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    -- dancing edge: first hit DEX(40%)/CHR(40%), use accuracy to increase more hits to connect
    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {
        neck="Spike Necklace", -- STR +3 DEX +3 MND -6
        body="Antares Harness", -- DEF: 50 HP +15 DEX +8 AGI +8 Accuracy +8 Evasion +8
        back="Cuchulain's Mantle", -- DEF: 8 STR +4 DEX +4 Accuracy +5
        waist="Life Belt", -- Accuracy +10
        hands="Rogue's Armlets", -- DEF: 15 HP +10 DEX +3 Ice+10 "Steal" +1
        left_ring="Fluorite Ring", -- DEX +3  Lightning+7
        right_ring="Fluorite Ring", -- DEX +3  Lightning+7
        legs="Dragon Subligar", -- DEF: 32 DEX +4 "Subtle Blow" +5 Breath damage taken -3% Enmity +2
        feet="Adsilio Boots +1", -- DEF:14 DEX +5 AGI +5 Accuracy +3 Haste +1%
    })
    -- sets.precast.WS['Dancing Edge'].Acc = set_combine(sets.precast.WS['Dancing Edge'], {})
    -- sets.precast.WS['Dancing Edge'].Mod = set_combine(sets.precast.WS['Dancing Edge'], {})
    -- sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {})
    -- sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {})
    -- sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {})

    -- Delivers a twofold attack. Damage varies with TP. 
    -- Modifiers: 	DEX:40% AGI:40% 
    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {
        range="Long Boomerang", -- DMG: 18 Delay: 294 AGI +2
        head="Noct Beret", -- DEF: 9 AGI +1  Dark+1
        neck="Spike Necklace", -- STR +3 DEX +3 MND -6
        body="Antares Harness", -- DEF: 50 HP +15 DEX +8 AGI +8 Accuracy +8 Evasion +8
        back="Cuchulain's Mantle", -- DEF: 8 STR +4 DEX +4 Accuracy +5
        waist="Scouter's Rope", -- DEF: 6 HP -40 AGI +4 Evasion +10
        hands="Rogue's Armlets", -- DEF: 15 HP +10 DEX +3 Ice+10 "Steal" +1
        left_ring="Fluorite Ring", -- DEX +3  Lightning+7
        right_ring="Fluorite Ring", -- DEX +3  Lightning+7
        legs="Dragon Subligar", -- DEF: 32 DEX +4 "Subtle Blow" +5 Breath damage taken -3% Enmity +2
        feet="Adsilio Boots +1", -- DEF:14 DEX +5 AGI +5 Accuracy +3 Haste +1%
    })

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {}

    -- Specific spells
    sets.midcast.Utsusemi = {}

    -- Ranged gear
    sets.midcast.RA = {}

    sets.midcast.RA.Acc = {}


    --------------------------------------
    -- Idle/resting/defense sets
    --------------------------------------

    -- Resting sets
    sets.resting = {
    }


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
        main="Martial Knife", -- DMG: 27 Delay: 186 TP Bonus - adds 1000%TP if in Main hand during weaponskill
        sub="Stylet", -- DMG: 31 Delay: 195 DEX +4 AGI +2 Enmity +1
        ammo="Bomb Core", -- Fire-6 Attack +12
        head="Rogue's Bonnet", -- DEF: 23 HP +13 INT +5 Parrying skill +10 "Steal" +1
        left_ear="Fang Earring", -- Attack +4 Evasion -4
        right_ear="Fang Earring", -- Attack +4 Evasion -4
        neck="Elemental Charm", -- Fire+6 Ice+6 Wind+6 Earth+6 Lightning+6 Water+6
        body="Rogue's Vest", -- DEF: 44 HP +20 STR +3  Earth+10 Increases "Hide" duration
        waist="Key Ring Belt", -- DEF: 2 DEX +1 "Steal" +1
        hands="Rogue's Armlets", -- DEF: 15 HP +10 DEX +3 Ice+10 "Steal" +1
        left_ring="Echad Ring", -- Experience point bonus: +150% Maximum duration: 720 min. Maximum bonus: 30000
        right_ring="Warp Ring", -- Enchantment: Warp
        legs="Rogue's Culottes", -- DEF: 32 HP +15 AGI +4 Shield skill +10 "Steal" +1
        feet="Areion Boots", -- DEF:4 AGI+2 Movement speed +12% Latent effect: "Flee", (Flee activates ~10% of the time when hit.)
    }

    sets.idle.Town = {
        main="Pitchfork +1",
        range="Long Boomerang", -- DMG: 18 Delay: 294 AGI +2
        head="Green Ribbon +1", -- all elements +10
        body="Savage Separates", -- DEF: 18 HP +32 STR +1 CHR +1
        hands="Savage Gauntlets", -- DEF: 6 MP +16 VIT +4 MND +2
        legs="Savage Loincloth", -- DEF: 12 MP +32 VIT +1 MND +1
        feet="Areion Boots", -- DEF:4 AGI+2 Movement speed +12% Latent effect: "Flee", (Flee activates ~10% of the time when hit.)
        left_ring="Echad Ring", -- Experience point bonus: +150% Maximum duration: 720 min. Maximum bonus: 30000
        right_ring="Warp Ring", -- Enchantment: Warp
    }

    sets.idle.Weak = {}


    -- Defense sets

    sets.defense.Evasion = {
        left_ear="Dodge Earring", -- Evasion +3
        right_ear="Dodge Earring", -- Evasion +3
        body="Antares Harness", -- DEF: 50 HP +15 DEX +8 AGI +8 Accuracy +8 Evasion +8
        waist="Scouter's Rope", -- DEF: 6 HP -40 AGI +4 Evasion +10
        feet="Areion Boots", -- DEF:4 AGI+2 Movement speed +12% Latent effect: "Flee", (Flee activates ~10% of the time when hit.)
    }

    sets.defense.PDT = {
        head="Rogue's Bonnet", -- DEF: 23 HP +13 INT +5 Parrying skill +10 "Steal" +1
        left_ear="Dodge Earring", -- Evasion +3
        right_ear="Dodge Earring", -- Evasion +3
        neck="Elemental Charm", -- Fire+6 Ice+6 Wind+6 Earth+6 Lightning+6 Water+6
        body="Antares Harness", -- DEF: 50 HP +15 DEX +8 AGI +8 Accuracy +8 Evasion +8
        back="Cerberus Mantle", -- DEF: 12 STR +3 Trans Fire+10 Attack +12 Enmity +3
        hands="Rogue's Armlets", -- DEF: 15 HP +10 DEX +3 Ice+10 "Steal" +1
        left_ring="Fluorite Ring", -- DEX +3  Lightning+7
        right_ring="Fluorite Ring", -- DEX +3  Lightning+7
        legs="Rogue's Culottes", -- DEF: 32 HP +15 AGI +4 Shield skill +10 "Steal" +1
        feet="Adsilio Boots +1", -- DEF:14 DEX +5 AGI +5 Accuracy +3 Haste +1%
    }

    sets.defense.MDT = {
        head="Green Ribbon +1", -- all elements +10
        right_ear="Amber Earring", -- Earth+2 Lightning+2
        neck="Elemental Charm", -- Fire+6 Ice+6 Wind+6 Earth+6 Lightning+6 Water+6
        body="Rogue's Vest", -- DEF: 44 HP +20 STR +3  Earth+10 Increases "Hide" duration
        back="Cerberus Mantle", -- DEF: 12 STR +3 Fire+10 Attack +12 Enmity +3
        hands="Rogue's Armlets", -- DEF: 15 HP +10 DEX +3 Ice+10 "Steal" +1
        left_ring="Fluorite Ring", -- DEX +3  Lightning+7
        right_ring="Fluorite Ring", -- DEX +3  Lightning+7
    }


    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
    sets.engaged = {
        main="Martial Knife", -- DMG: 27 Delay: 186 TP Bonus - adds 1000%TP if in Main hand during weaponskill
        sub="Stylet", -- DMG: 31 Delay: 195 DEX +4 AGI +2 Enmity +1
        ammo="Bomb Core", -- Fire-6 Attack +12
        head="Zeal Cap", -- DEF: 19 Accuracy +2 Attack +2 Haste +1%
        left_ear="Fang Earring", -- Attack +4 Evasion -4
        right_ear="Fang Earring", -- Attack +4 Evasion -4
        neck="Spike Necklace", -- STR +3 DEX +3 MND -6
        body="Antares Harness", -- DEF: 50 HP +15 DEX +8 AGI +8 Accuracy +8 Evasion +8
        waist="Life Belt", -- Accuracy +10
        hands="Lgn. Mittens", -- DEF: 3 Attack +3
        left_ring="Fluorite Ring", -- DEX +3  Lightning+7
        right_ring="Fluorite Ring", -- DEX +3  Lightning+7
        legs="Dragon Subligar", -- DEF: 32 DEX +4 "Subtle Blow" +5 Breath damage taken -3% Enmity +2
        feet="Adsilio Boots +1", -- DEF:14 DEX +5 AGI +5 Accuracy +3 Haste +1%
    }
    sets.engaged.Acc = {}
        
    -- Mod set for trivial mobs (Skadi+1)
    sets.engaged.Mod = {}

    -- Mod set for trivial mobs (Thaumas)
    sets.engaged.Mod2 = {}

    sets.engaged.Evasion = {
        left_ear="Dodge Earring", -- Evasion +3
        right_ear="Dodge Earring", -- Evasion +3
        body="Antares Harness", -- DEF: 50 HP +15 DEX +8 AGI +8 Accuracy +8 Evasion +8
        waist="Scouter's Rope", -- DEF: 6 HP -40 AGI +4 Evasion +10
    }

    sets.engaged.Acc.Evasion = {}

    sets.engaged.PDT = {
        head="Rogue's Bonnet", -- DEF: 23 HP +13 INT +5 Parrying skill +10 "Steal" +1
        left_ear="Dodge Earring", -- Evasion +3
        right_ear="Dodge Earring", -- Evasion +3
        back="Cerberus Mantle", -- DEF: 12 STR +3 Trans Fire+10 Attack +12 Enmity +3
        hands="Rogue's Armlets", -- DEF: 15 HP +10 DEX +3 Ice+10 "Steal" +1
    }
    sets.engaged.Acc.PDT = {}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
        equip(sets.TreasureHunter)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end


-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- Check that ranged slot is locked, if necessary
    check_range_lock()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end


function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end


function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    th_update(cmdParams, eventArgs)
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- (macro set #, macro book #)
    set_macro_page(2, 2)
end


