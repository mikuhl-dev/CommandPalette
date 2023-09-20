local _, addon = ...;

local L = addon.L;

local actions = nil;

CommandPalette.RegisterModule(L["World Markers"], {
    OnEnable = function()
        actions = nil;
    end,

    OnDisable = function()
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        for i = 1, 8 do
            local name = _G["RAID_TARGET_" .. i];
            local icon = 137000 + i;

            table.insert(actions, {
                name = string.format(L["Set World Marker: %s"], name),
                icon = icon,
                action = {
                    type = "worldmarker",
                    action = "set",
                    marker = i,
                }
            });

            table.insert(actions, {
                name = string.format(L["Clear World Marker: %s"], name),
                icon = icon,
                action = {
                    type = "worldmarker",
                    action = "clear",
                    marker = i,
                }
            });
        end;

        return actions;
    end,
});
