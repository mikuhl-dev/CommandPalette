local _, addon = ...;

local L = addon.L;

local actions = nil;

CommandPalette.RegisterModule(L["AddOns"], {
    OnEnable = function()
        actions = nil;
    end,

    OnDisable = function()
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        for _, addonInfo in pairs(AddonCompartmentFrame.registeredAddons) do
            table.insert(actions, {
                name = string.format(L["Open AddOn: %s"], StripHyperlinks(addonInfo.text)),
                icon = addonInfo.icon,
                action = {
                    type = "addon",
                    _addon = addonInfo.func
                }
            });
        end;

        return actions;
    end,
});
