---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["AddOns"], function()
    for _, addonInfo in pairs(AddonCompartmentFrame.registeredAddons) do
        coroutine.yield({
            name = string.format(L["Open AddOn: %s"], StripHyperlinks(addonInfo.text)),
            icon = addonInfo.icon,
            action = {
                type = "addon",
                _addon = addonInfo.func
            }
        });
    end;
end);
