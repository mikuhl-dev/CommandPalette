local _, addon = ...

local L = addon.L

local auraFilter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Cancelable)

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    AuraUtil.ForEachAura("player", auraFilter, nil, function(name, icon)
        if name ~= nil then
            local title = string.format(L["Cancel Aura: %s"], name)
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "cancelaura",
                        spell = name
                    }
                })
            end
        end
    end)
end)
