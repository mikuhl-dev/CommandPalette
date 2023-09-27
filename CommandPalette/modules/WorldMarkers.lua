---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["World Markers"], function(self)
    for i = 1, 8 do
        local name = _G["RAID_TARGET_" .. i];
        local icon = 137000 + i;

        self.CreateAction({
            name = format(L["Set World Marker: %s"], name),
            icon = icon,
            action = {
                type = "worldmarker",
                action = "set",
                marker = i,
            }
        });

        self.CreateAction({
            name = format(L["Clear World Marker: %s"], name),
            icon = icon,
            action = {
                type = "worldmarker",
                action = "clear",
                marker = i,
            }
        });
    end;
end);
