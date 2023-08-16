local _, addon = ...

local L = addon.L

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    for macroIndex = 0, GetNumMacros() do
        local macroInfo = { GetMacroInfo(macroIndex) }
        local name = macroInfo[1]
        local icon = macroInfo[2]
        if name ~= nil then
            local title = string.format(L["Use Macro: %s"], name)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "macro",
                        macro = macroIndex
                    }
                })
            end
        end
    end
end)
