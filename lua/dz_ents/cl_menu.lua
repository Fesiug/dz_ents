local function header(panel, text)
    local ctrl = panel:Help(text)
    ctrl:SetFont("DermaDefaultBold")
    return ctrl
end

local function combobox(panel, text, convar, options)
    local cb, lb = panel:ComboBox(text, convar)
    for k, v in pairs(options) do
        cb:AddChoice(k, v)
    end
    cb:DockMargin(8, 0, 0, 0)
    lb:SizeToContents()
end

local function menu_client(panel)
    panel:AddControl("checkbox", {
        label = "Use spawn menu subcategories",
        command = "cl_dzents_subcat"
    })
    panel:AddControl("checkbox", {
        label = "Automatically deploy parachute",
        command = "cl_dzents_parachute_autodeploy"
    })
    panel:ControlHelp("Parachute will deploy when your falling velocity becomes lethal.")
    panel:AddControl("checkbox", {
        label = "Parachute viewmodel",
        command = "cl_dzents_parachute_vm"
    })
    panel:AddControl("checkbox", {
        label = "Parachute letterbox",
        command = "cl_dzents_parachute_frame"
    })
    panel:AddControl("checkbox", {
        label = "Medi-Shot overlay",
        command = "cl_dzents_healthshot_overlay"
    })
    panel:AddControl("checkbox", {
        label = "Heavy Assault Suit color correction",
        command = "cl_dzents_heavyarmor_cc"
    })
end



local function menu_ammo(panel)

    header(panel, "Ammo Boxes")
    panel:AddControl("checkbox", {
        label = "Give clip size per use",
        command = "dzents_ammo_clip"
    })
    panel:ControlHelp("Uses Danger Zone values if not selected.")
    panel:AddControl("checkbox", {
        label = "Cleanup empty ammo boxes",
        command = "dzents_ammo_cleanup"
    })
    panel:ControlHelp("Does not clean up if ammo box regen is enabled.")
    panel:AddControl("checkbox", {
        label = "Limit maximum reserves",
        command = "dzents_ammo_limit"
    })
    panel:ControlHelp("Limit is based on ammo type (except for SWCS weapons).")
    panel:AddControl("slider", {
        label = "Ammo given",
        command = "dzents_ammo_mult",
        type = "float",
        min = 0,
        max = 5,
    })
    panel:AddControl("checkbox", {
        label = "Infinite ammo can is admin only",
        command = "dzents_ammo_adminonly"
    })
    panel:ControlHelp("Requires a map reload to take effect.")

    header(panel, "Regeneration")
    panel:AddControl("checkbox", {
        label = "Ammo boxes regenerate ammo",
        command = "dzents_ammo_regen"
    })
    panel:AddControl("checkbox", {
        label = "Gradual regeneration",
        command = "dzents_ammo_regen_partial"
    })
    panel:AddControl("slider", {
        label = "Regeneration delay",
        command = "dzents_ammo_regen_delay",
        type = "int",
        min = 1,
        max = 600,
    })
    panel:ControlHelp("Time it takes to fully regenerate all ammo.")

end

local function menu_cases(panel)
    panel:AddControl("checkbox", {
        label = "Reinforced cases",
        command = "dzents_case_reinforced"
    })
    panel:ControlHelp("Reinforced cases cannot be damaged by unarmed attacks.")
    panel:AddControl("slider", {
        label = "Case health",
        command = "dzents_case_health",
        type = "float",
        min = 0,
        max = 5,
    })
    combobox(panel, "Case gibs", "dzents_case_gib", {
        ["0 - No gibs"] = "0",
        ["1 - Clientside gibs"] = "1",
        ["2 - Serverside gibs"] = "2",
    })
    panel:ControlHelp("Serverside gibs may be more performance intensive.")
end


local function menu_armor(panel)

    header(panel, "Armor + Helmet")
    combobox(panel, "CS:GO behavior", "dzents_armor_enabled", {
        ["0 - Disabled"] = "0",
        ["1 - With armor/helmet"] = "1",
        ["2 - Always"] = "2",
    })
    panel:ControlHelp("Modifies damage and armor logic to closely match CS:GO.")

    panel:AddControl("checkbox", {
        label = "Protect against all damage",
        command = "dzents_armor_fallback"
    })
    panel:ControlHelp("Damage not protected by CS:GO armor will be handled like HL2 logic. If disabled, armor will be ignored.")

    combobox(panel, "Armor on spawn", "dzents_armor_onspawn", {
        ["0 - Disabled"] = "0",
        ["1 - Armor only"] = "1",
        ["2 - Armor + Helmet"] = "2",
        ["3 - Heavy Assault Armor"] = "3",
    })
    panel:AddControl("checkbox", {
        label = "Drop armor on death",
        command = "dzents_drop_armor"
    })

    header(panel, "\nHeavy Assault Armor")
    panel:AddControl("checkbox", {
        label = "Restrict to admins only",
        command = "dzents_armor_heavy_adminonly"
    })
    panel:ControlHelp("Requires a map reload to take effect.")
    panel:AddControl("checkbox", {
        label = "Heavy Armor can break",
        command = "dzents_armor_heavy_break"
    })
    panel:ControlHelp("When broken, movement speed and other attributes will be restored.")
    panel:AddControl("checkbox", {
        label = "Disallow sprinting",
        command = "dzents_armor_heavy_nosprint"
    })
    panel:AddControl("checkbox", {
        label = "Always take realistic fall damage",
        command = "dzents_armor_heavy_falldamage"
    })
    panel:ControlHelp("Fall damage taken is identical to turning on 'Realistic fall damage'.")
    panel:AddControl("checkbox", {
        label = "Goomba stomp on landing",
        command = "dzents_armor_heavy_fallstomp"
    })
    panel:ControlHelp("Stomp damage is 3x fall damage.")
    panel:AddControl("checkbox", {
        label = "ROBERRRRRRRRRTTTTTTTTTTTTT",
        command = "dzents_armor_heavy_robert"
    })
    combobox(panel, "Restrict using rifles", "dzents_armor_heavy_norifle", {
        ["0 - No restriction"] = "0",
        ["1 - CS:GO rifles"] = "1",
        ["2 - All rifles"] = "2",
    })
    panel:ControlHelp("Restricted weapons cannot be picked up or switched to.\n'All rifles' option uses autodetection based on weapon base and may not be perfectly accurate.")
    panel:AddControl("slider", {
        label = "Damage taken",
        command = "dzents_armor_heavy_damage",
        type = "float",
        min = 0,
        max = 1,
    })
    panel:AddControl("slider", {
        label = "Durability loss",
        command = "dzents_armor_heavy_durability",
        type = "float",
        min = 0,
        max = 10,
    })
    panel:AddControl("slider", {
        label = "Walk speed",
        command = "dzents_armor_heavy_speed",
        type = "int",
        min = 50,
        max = 200,
    })
    panel:AddControl("slider", {
        label = "Deploy speed",
        command = "dzents_armor_heavy_deployspeed",
        type = "float",
        min = 0,
        max = 1,
    })
    panel:ControlHelp("Only affects certain weapon bases.")
    panel:AddControl("slider", {
        label = "Additional gravity",
        command = "dzents_armor_heavy_gravity",
        type = "float",
        min = 0,
        max = 1,
    })
    panel:ControlHelp("Makes you fall faster, and makes parachute and ExoJump less effective.")
    panel:AddControl("slider", {
        label = "ExoJump strength",
        command = "dzents_armor_heavy_exojump",
        type = "float",
        min = 0,
        max = 2,
    })
    panel:ControlHelp("Velocity multiplier when using the ExoJump with the Heavy Assault Armor.")

end

local function menu_pickups(panel)

    header(panel, "Pickups")
    panel:AddControl("checkbox", {
        label = "Instantly use pickups",
        command = "dzents_pickup_instantuse"
    })
    panel:AddControl("checkbox", {
        label = "Drop armor on death",
        command = "dzents_drop_armor"
    })
    panel:AddControl("checkbox", {
        label = "Drop equipment on death",
        command = "dzents_drop_equip"
    })
    panel:AddControl("slider", {
        label = "Drop cleanup delay",
        command = "dzents_drop_cleanup",
        type = "int",
        min = 0,
        max = 300,
    })
    panel:ControlHelp("Timer for removing items dropped on death. 0 - never remove.")

    -- header(panel, "\nGive on Spawn")
    combobox(panel, "Armor on spawn", "dzents_armor_onspawn", {
        ["0 - Disabled"] = "0",
        ["1 - Armor only"] = "1",
        ["2 - Armor + Helmet"] = "2",
        ["3 - Heavy Assault Armor"] = "3",
    })
    panel:AddControl("checkbox", {
        label = "ExoJump on spawn",
        command = "dzents_exojump_onspawn"
    })
    panel:AddControl("checkbox", {
        label = "Parachute on spawn",
        command = "dzents_parachute_onspawn"
    })

    header(panel, "\nExoJump")
    panel:AddControl("checkbox", {
        label = "Sprint boost",
        command = "dzents_exojump_runboost"
    })
    panel:ControlHelp("Allow using running speed to boost with the ExoJump. If disabled, drag will slow down velocity to walking speed.")

    panel:AddControl("slider", {
        label = "High jump boost",
        command = "dzents_exojump_boost_up",
        type = "float",
        min = 0,
        max = 2,
    })
    panel:AddControl("slider", {
        label = "Long jump boost",
        command = "dzents_exojump_boost_forward",
        type = "float",
        min = 0,
        max = 2,
    })
    panel:AddControl("slider", {
        label = "Fall damage",
        command = "dzents_exojump_falldamage",
        type = "float",
        min = 0,
        max = 1,
    })
    panel:AddControl("slider", {
        label = "Drag",
        command = "dzents_exojump_drag",
        type = "float",
        min = 0,
        max = 2,
    })
    panel:ControlHelp("Drag reduces horizontal velocity when it exceeds maximum.")

    header(panel, "\nParachute")
    panel:AddControl("checkbox", {
        label = "Consume on landing",
        command = "dzents_parachute_consume"
    })
    panel:AddControl("checkbox", {
        label = "Allow premature detach",
        command = "dzents_parachute_detach"
    })
    panel:AddControl("slider", {
        label = "Deploy threshold",
        command = "dzents_parachute_threshold",
        type = "float",
        min = 0,
        max = 1000,
    })
    panel:AddControl("slider", {
        label = "Fall velocity",
        command = "dzents_parachute_fall",
        type = "int",
        min = 50,
        max = 500,
    })
    panel:AddControl("slider", {
        label = "Horizontal speed",
        command = "dzents_parachute_speed",
        type = "float",
        min = 0,
        max = 400,
    })
    panel:AddControl("slider", {
        label = "Horizontal drag",
        command = "dzents_parachute_drag",
        type = "float",
        min = 0,
        max = 5,
    })
end

local function menu_equip(panel)
    header(panel, "Equipment")
    panel:AddControl("checkbox", {
        label = "Use SWCS base if available",
        command = "dzents_equipment_swcs"
    })
    panel:ControlHelp("Gives equipment crosshair and viewbob from SWCS if installed. Requires reload.")

    header(panel, "\nMedi-Shot")
    panel:AddControl("checkbox", {
        label = "Allow using at max health",
        command = "dzents_healthshot_use_at_full"
    })
    panel:AddControl("slider", {
        label = "Max ammo",
        command = "dzents_healthshot_maxammo",
        type = "int",
        min = 0,
        max = 10,
    })
    panel:ControlHelp("IMPORTANT: This only works if 'gmod_maxammo' is set to 0!")
    panel:AddControl("slider", {
        label = "Health given",
        command = "dzents_healthshot_health",
        type = "int",
        min = 0,
        max = 100,
    })
    panel:AddControl("slider", {
        label = "Health delay",
        command = "dzents_healthshot_healtime",
        type = "float",
        min = 0,
        max = 5,
    })
    panel:ControlHelp("Takes this amount of time to give all the health. Set to 0 for instant.")
    panel:AddControl("slider", {
        label = "Boost duration",
        command = "dzents_healthshot_duration",
        type = "float",
        min = 0,
        max = 10,
    })
    panel:AddControl("slider", {
        label = "Boost damage dealt",
        command = "dzents_healthshot_damage_dealt",
        type = "float",
        min = 0,
        max = 2,
    })
    panel:AddControl("slider", {
        label = "Boost damage taken",
        command = "dzents_healthshot_damage_taken",
        type = "float",
        min = 0,
        max = 2,
    })
    panel:AddControl("slider", {
        label = "Boost move speed",
        command = "dzents_healthshot_speed",
        type = "float",
        min = 0,
        max = 2,
    })

    header(panel, "\nBump Mine")
    panel:AddControl("checkbox", {
        label = "Crash chaining",
        command = "dzents_bumpmine_damage_crashchain"
    })
    panel:ControlHelp("Players and NPCs that crash into another entity will damage and launch that entity.")

    panel:AddControl("slider", {
        label = "Max ammo",
        command = "dzents_bumpmine_maxammo",
        type = "int",
        min = 0,
        max = 10,
    })
    panel:ControlHelp("IMPORTANT: This only works if 'gmod_maxammo' is set to 0!")

    panel:AddControl("slider", {
        label = "Launch force",
        command = "dzents_bumpmine_force",
        type = "int",
        min = 300,
        max = 3000,
    })
    panel:AddControl("slider", {
        label = "Bonus up force",
        command = "dzents_bumpmine_upadd",
        type = "int",
        min = 0,
        max = 1500,
    })
    panel:ControlHelp("Bonus force is angled upwards regardless of player's relative position to the mine. If crouching, it is not applied.")
    panel:AddControl("slider", {
        label = "Fall damage",
        command = "dzents_bumpmine_damage_fall",
        type = "float",
        min = 0,
        max = 1,
    })
    panel:ControlHelp("If set, players/NPCs will take velocity-based fall damage. Set to 0 to not modify damage for players and apply no damage to NPCs.")
    panel:AddControl("slider", {
        label = "Wall crash damage",
        command = "dzents_bumpmine_damage_crash",
        type = "float",
        min = 0,
        max = 1,
    })
    panel:AddControl("slider", {
        label = "Self crash damage",
        command = "dzents_bumpmine_damage_selfcrash",
        type = "float",
        min = 0,
        max = 1,
    })
    panel:ControlHelp("Self crash multiplier is applied on top of wall crash damage for the attacker of the mine.")
    panel:AddControl("slider", {
        label = "Arm delay",
        command = "dzents_bumpmine_armdelay",
        type = "float",
        min = 0,
        max = 1,
    })
    panel:AddControl("slider", {
        label = "Detonation delay",
        command = "dzents_bumpmine_detdelay",
        type = "float",
        min = 0,
        max = 1,
    })
end

local menus = {
    {
        text = "Client", func = menu_client
    },
    {
        text = "Server - Ammo", func = menu_ammo
    },
    {
        text = "Server - Cases", func = menu_cases
    },
    {
        text = "Server - Equipment", func = menu_equip
    },
    {
        text = "Server - Pickups", func = menu_pickups
    },
    {
        text = "Server - Armor", func = menu_armor
    },
}
hook.Add("PopulateToolMenu", "dz_ents_menu", function()
    for smenu, data in pairs(menus) do
        spawnmenu.AddToolMenuOption("Options", "Danger Zone", "DZ_Ents_" .. tostring(smenu), data.text, "", "", data.func)
    end
end)
