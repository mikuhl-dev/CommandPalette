local _, addon = ...;

local L = addon.L;

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    for totemIndex = 1, MAX_TOTEMS do
        local totemInfo = { GetTotemInfo(totemIndex) };
        local name = totemInfo[2];
        local icon = totemInfo[5];
        if name ~= nil and GetTotemTimeLeft(totemIndex) > 0 then
            local title = string.format(L["Destroy Totem: %s"], name);
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "destroytotem",
                        ["totem-slot"] = totemIndex
                    }
                });
            end;
        end;
    end;
end);
