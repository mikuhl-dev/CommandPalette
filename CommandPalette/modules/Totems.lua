---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Totems"], function(self)
    for totemIndex = 1, MAX_TOTEMS do
        local totemInfo = { GetTotemInfo(totemIndex) };
        local name = totemInfo[2];
        local icon = totemInfo[5];
        if name ~= nil and GetTotemTimeLeft(totemIndex) > 0 then
            self.CreateAction({
                name = format(L["Destroy Totem: %s"], name),
                icon = icon,
                action = {
                    type = "destroytotem",
                    ["totem-slot"] = totemIndex
                }
            });
        end;
    end;

    self.RegisterEvent("PLAYER_TOTEM_UPDATE");
end);
