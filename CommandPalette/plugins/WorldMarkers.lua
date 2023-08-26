local _, addon = ...;

local L = addon.L;

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    for i = 1, 8 do
        local name = _G["RAID_TARGET_" .. i];
        local icon = 137000 + i;

        do -- Set
            local title = string.format(L["Set World Marker: %s"], name);
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "worldmarker",
                        action = "set",
                        marker = i,
                    }
                });
            end;
        end;

        do -- Clear
            local title = string.format(L["Clear World Marker: %s"], name);
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = icon,
                    action = {
                        type = "worldmarker",
                        action = "clear",
                        marker = i,
                    }
                });
            end;
        end;
    end;
end);
