--
-- LazyMattCam v1.1.0
-- mod made by witherisafk :3
--
-- i highly encourage you to borrow or reference this code if you want to make a "face cam" with FaceCam Mod!!!
--

-- mod
local lazymattcam_mod = RegisterMod("LazyMattCam", 1)
local sprites_table, sfx_table
local is_loaded = false -- this variable and the check it is used for is imperative if your mod will be inserting variables/tables/etc into or modifying callbacks for FaceCamMod to ensure this does not occur at every game start!

-- create streamer object function
function CreateStreamerObject(name, anim, type)
    return {
        Name = name,
        Anim = anim,
        Type = type
    }

    -- end function
end

-- register sprites and sfx function
function lazymattcam_mod.RegisterSpritesAndSFX()
    -- update sprites
    -- format: <.anm2 file path>, <animation name specified in .anm2; set to "Vary" to play random animations in .anm2>, <animation table*>
    sprites_table = {
        CreateStreamerObject("gfx/lazymattcam/mattman.anm2", "still", FaceCamMod.idle_sprites),
        CreateStreamerObject("gfx/lazymattcam/mattman.anm2", "bounce", FaceCamMod.happy_sprites),
        CreateStreamerObject("gfx/lazymattcam/mattman.anm2", "bounce", FaceCamMod.intro_sprites)
    }

    -- update sfx
    -- format: <sfx name as specified in sounds.xml>, <leave this nil>, <sfx table*>
    sfx_table = {
        CreateStreamerObject("scream.wav", nil, FaceCamMod.death_sfx),
        CreateStreamerObject("denial.wav", nil, FaceCamMod.death_sfx),
        CreateStreamerObject("scream_1.wav", nil, FaceCamMod.happy_sfx),
        CreateStreamerObject("scream_2.wav", nil, FaceCamMod.happy_sfx),
        CreateStreamerObject("scream_3.wav", nil, FaceCamMod.happy_sfx),
        CreateStreamerObject("exclaim.wav", nil, FaceCamMod.happy_sfx),
        CreateStreamerObject("intro.wav", nil, FaceCamMod.intro_sfx)
    }

    -- end function
end

-- * FaceCam Mod currently offers (for both sprites and sfx):
--    - idle (default)
--    - happy (positive reactions, e.g. finding quality 4 items w/o curse of the blind, killing enemies, etc)
--    - angry (negative reactions, e.g. finding quality 0 items w/o curse of the blind, getting hit, etc)
--    - intro (plays at start of the first run you play on the current instance of the game)
--    - death (when player dies)
-- And, uniquely for sfx:
--    - hit (upon getting hit)
--    - kill (upon getting kills)

-- config table
-- miscellaneous settings; tweak as needed, each variable only updates a default value
-- all of these variables can be tweaked by the user in the mod config menu, except version and _des (descriptions; second line descriptions specifically) variables
-- NOTE: none of the values here are the default ones for FaceCam Mod!
local config = {
    version = 1.0, -- version; this variable currently does not matter as it is automatically updated to the latest one by the facecam mod, but it will likely be utilized if there are new requirements to mods supported by the facecam mod such as this one

    should_streamer_visible = true, -- whether the streamer should be rendered
    should_streamer_visible_des = "Default: True",
    should_streamer_speak = true, -- whether sound effects from this mod should play
    should_streamer_speak_des = "Default: True",
    should_auto_reposition = true, -- whether the face cam is auto-repositioned
    should_auto_reposition_des = "Default: True",
    should_streamer_react = true, -- whether the streamer should react to items of specific qualities
    should_streamer_react_des = "Default: True",

    height_additional_modifier = 0, -- value to add to value subtracted against screen height for vertical position of facecam; exists because value of 10 was necessary for sprites of certain dimensions... for some reason
    height_additional_modifier_des = "Default: 0",
    facecam_scale = 2.0, -- scale of the face cam
    facecam_scale_des = "Default: 0.4",
    facecam_width = 44, -- width of the face cam sprite; used for auto positioning, tweak as needed
    facecam_width_des = "Default: 44",
    facecam_height = 12, -- height of the face cam; used for auto positioning, tweak as needed
    facecam_height_des = "Default: 12",
    facecam_pos_width = 0, -- horizontal position of the face cam sprite; only changes if auto repositioning is set to false
    facecam_pos_width_des = "Default: 0 (only changes if Auto Repos. is False)",
    facecam_pos_height = 0, -- vertical position of the face cam sprite; only changes if auto repositioning is set to false
    facecam_pos_height_des = "Default: 0 (only changes if Auto Repos. is False)",
    upon_hit_react_chance = 0, -- 1 in x chance to react upon getting hit; set to 0 to disable
    upon_hit_react_chance_des = "Default: 0", -- TODO: ADD THESE REACTIONS
    upon_kill_react_chance = 0, -- 1 in x chance to react upon getting a kill; set to 0 to disable
    upon_kill_react_chance_des = "Default: 0",
    idle_react_chance = 0, -- currently unused; wip
    idle_react_chance_des = "Default: 0",

    sfx_volume = 2.0, -- volume of played sfx
    sfx_volume_des = "Default: 2.0",
    delay_threshold = 15, -- how many frames until actual sprite rendering/sfx playing for the mod occurs; exists to account for that screen fade-in/out between games
    delay_threshold_des = "Default: 15"
}

-- post game started function
function lazymattcam_mod.PostGameStarted()
    -- check
    if is_loaded then return end

    if FaceCamMod and FaceCamMod.LoadFaceCam then
        -- custom table insertion and/or FaceCamMod callback modification can be done here
        -- regardless, it is recommended to register the sprites/sfx with a separate function as follows, as FaceCamMod may be null outside of the post game start call
        lazymattcam_mod.RegisterSpritesAndSFX()

        FaceCamMod.LoadFaceCam(sprites_table, sfx_table, config)

        is_loaded = true
    else
        Isaac.ConsoleOutput("[LazyMattCam] YO! You must install FaceCam Mod to see me.")
    end

    -- end function
end

-- callback
lazymattcam_mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, lazymattcam_mod.PostGameStarted)
