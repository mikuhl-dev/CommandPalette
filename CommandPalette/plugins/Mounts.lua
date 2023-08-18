local _, addon = ...

local L = addon.L

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
        local mountInfo = { C_MountJournal.GetMountInfoByID(mountID) }
        local name = mountInfo[1]
        local icon = mountInfo[3]
        local isUsable = mountInfo[5]

        local title = string.format(L["Summon Mount: %s"], name)
        if isUsable and CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                icon = icon,
                action = {
                    type = "macro",
                    macrotext = string.format([[/run C_MountJournal.SummonByID(%d)]], mountID),
                }
            })
        end
    end
end)
