local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

local auraFilter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Cancelable);

CommandPalette.RegisterModule(L["Auras"], {
    OnEnable = function()
        frame:RegisterUnitEvent("UNIT_AURA", "player");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        AuraUtil.ForEachAura("player", auraFilter, nil, function(auraData)
            local name = auraData.name;
            local icon = auraData.icon;
            local auraInstanceID = auraData.auraInstanceID;
            table.insert(actions, {
                name = string.format(L["Cancel Aura: %s"], name),
                icon = icon,
                tooltip = GenerateClosure(GameTooltip.SetUnitBuffByAuraInstanceID, GameTooltip, "player", auraInstanceID,
                    auraFilter),
                action = {
                    type = "cancelaura",
                    spell = name
                }
            });
        end, true);

        return actions;
    end
});
