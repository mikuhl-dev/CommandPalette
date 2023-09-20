local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Totems"], {
    OnEnable = function()
        frame:RegisterEvent("PLAYER_TOTEM_UPDATE");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        for totemIndex = 1, MAX_TOTEMS do
            local totemInfo = { GetTotemInfo(totemIndex) };
            local name = totemInfo[2];
            local icon = totemInfo[5];
            if name ~= nil and GetTotemTimeLeft(totemIndex) > 0 then
                table.insert(actions, {
                    name = string.format(L["Destroy Totem: %s"], name),
                    icon = icon,
                    action = {
                        type = "destroytotem",
                        ["totem-slot"] = totemIndex
                    }
                });
            end;
        end;

        return actions;
    end,
});
