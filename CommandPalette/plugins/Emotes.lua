local _, addon = ...

local L = addon.L

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    for i = 1, 672 do
        local command = _G["EMOTE" .. i .. "_CMD1"]
        if command ~= nil then
            local title = string.format(L["Use Emote: %s"], command)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    action = {
                        type = "macro",
                        macrotext = command,
                    }
                })
            end
        end
    end
end)
