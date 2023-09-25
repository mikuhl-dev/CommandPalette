---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["World Markers"], function()
    for i = 1, 8 do
        local name = _G["RAID_TARGET_" .. i];
        local icon = 137000 + i;

        coroutine.yield({
            name = string.format(L["Set World Marker: %s"], name),
            icon = icon,
            action = {
                type = "worldmarker",
                action = "set",
                marker = i,
            }
        });

        coroutine.yield({
            name = string.format(L["Clear World Marker: %s"], name),
            icon = icon,
            action = {
                type = "worldmarker",
                action = "clear",
                marker = i,
            }
        });
    end;
end);
