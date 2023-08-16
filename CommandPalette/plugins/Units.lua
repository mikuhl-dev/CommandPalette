local _, addon = ...

local L = addon.L

local focusMacro = [[
/cleartarget
/targetexact %s
/focus [exists]
/targetlasttarget [noexists]
]]

local inspectMacro = [[
/cleartarget
/targetexact %s
/inspect [exists]
/targetlasttarget [noexists]
]]

local tradeMacro = [[
/cleartarget
/targetexact %s
/trade [exists]
/targetlasttarget [noexists]
]]

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    for name, unit in pairs(EnumerateUnits()) do
        local function icon(texture)
            SetPortraitTexture(texture, unit, true)
        end

        do -- Target
            local title = string.format(L["Target: %s"], name)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "macro",
                        macrotext = string.format([[/targetexact %s]], name)
                    }
                })
            end
        end

        do -- Focus
            local title = string.format(L["Focus: %s"], name)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "macro",
                        macrotext = string.format(focusMacro, name)
                    }
                })
            end
        end

        -- Inspect
        if CanInspect(unit) then
            local title = string.format(L["Inspect: %s"], name)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "macro",
                        macrotext = string.format(inspectMacro, name)
                    }
                })
            end
        end

        -- Trade
        if CheckInteractDistance(unit, 2) and
            UnitIsPlayer(unit) and
            UnitCanCooperate("player", unit) and
            HasFullControl() and
            not UnitIsDeadOrGhost("player") and
            not UnitIsDeadOrGhost(unit) then
            local title = string.format(L["Trade: %s"], name)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "macro",
                        macrotext = string.format(tradeMacro, name)
                    }
                })
            end
        end

        -- Follow
        if CheckInteractDistance(unit, 4) and
            UnitCanCooperate("player", unit) and
            not UnitIsDead("player") then
            local title = string.format(L["Follow: %s"], name)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "macro",
                        macrotext = string.format([[/follow %s]], name)
                    }
                })
            end
        end

        -- Invite
        if UnitIsPlayer(unit) and UnitCanCooperate("player", unit) then
            local title = string.format(L["Invite: %s"], name)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "macro",
                        macrotext = string.format([[/invite %s]], name)
                    }
                })
            end
        end

        -- Request Invite
        if UnitIsPlayer(unit) and
            UnitCanCooperate("player", unit) and
            not UnitInAnyGroup("player") then
            local title = string.format(L["Request Invite: %s"], name)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "macro",
                        macrotext = string.format([[/requestinvite %s]], name)
                    }
                })
            end
        end

        -- Pet Battle
        if UnitCanPetBattle("player", unit) then
            local title = string.format(L["Pet Battle: %s"], name)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "macro",
                        macrotext = string.format([[/run C_PetBattles.StartPVPDuel("%s")]], name)
                    }
                })
            end
        end
    end
end)
