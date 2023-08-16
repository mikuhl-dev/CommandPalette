local _, addon = ...

local L = addon.L

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    -- Duel
    if CheckInteractDistance("target", 3) and
        UnitIsPlayer("target") and
        not UnitIsUnit("player", "target") and
        not UnitCanAttack("player", "target") and
        HasFullControl() and
        not UnitIsDeadOrGhost("player") and
        not UnitIsDeadOrGhost("target") then
        local title = L["Request Duel"]
        if CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                action = {
                    type = "macro",
                    macrotext = [[/duel]]
                }
            })
        end
    end

    -- PVP
    local title = L["Toggle Player Vs Player"]
    if CommandPalette:MatchesSearch(title) then
        CommandPalette:AddAction({
            title = title,
            action = {
                type = "macro",
                macrotext = [[/pvp]]
            }
        })
    end
end)
