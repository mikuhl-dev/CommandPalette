---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

local auraFilter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Cancelable);

CommandPalette.RegisterModule(L["Auras"], function(self)
    AuraUtil.ForEachAura("player", auraFilter, nil, function(auraData)
        local name = auraData.name;
        local icon = auraData.icon;
        local auraInstanceID = auraData.auraInstanceID;
        self.CreateAction({
            name = format(L["Cancel Aura: %s"], name),
            icon = icon,
            tooltip = GenerateClosure(GameTooltip.SetUnitBuffByAuraInstanceID, GameTooltip, "player", auraInstanceID,
                auraFilter),
            action = {
                type = "cancelaura",
                spell = name
            }
        });
    end, true);

    self.RegisterUnitEvent("UNIT_AURA", "player");
end);
