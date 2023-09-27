---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["AddOns"], function(self)
    for _, addonInfo in pairs(AddonCompartmentFrame.registeredAddons) do
        self.CreateAction({
            name = format(L["Open AddOn: %s"], StripHyperlinks(addonInfo.text)),
            icon = addonInfo.icon,
            action = {
                type = "addon",
                _addon = addonInfo.func
            }
        });
    end;
end);
