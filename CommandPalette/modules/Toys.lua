---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Toys"], function(self)
    C_ToyBox.SetFilterString("");
    C_ToyBoxInfo.SetDefaultFilters();

    local numToys = C_ToyBox.GetNumToys();
    for i = 1, numToys do
        local itemId = C_ToyBox.GetToyFromIndex(i);
        if PlayerHasToy(itemId) then
            local toyInfo = { C_ToyBox.GetToyInfo(itemId) };
            local name = toyInfo[2];
            local icon = toyInfo[3];
            if name ~= nil then
                self.CreateAction({
                    name = format(L["Use Toy: %s"], name),
                    icon = icon,
                    quality = C_Item.GetItemQualityByID(itemId),
                    cooldown = GenerateClosure(GetItemCooldown, itemId),
                    tooltip = GenerateClosure(GameTooltip.SetToyByItemID, GameTooltip, itemId),
                    pickup = GenerateClosure(C_ToyBox.PickupToyBoxItem, itemId),
                    action = {
                        type = "toy",
                        toy = itemId,
                    }
                });
            end;
        end;
    end;

    self.RegisterEvent("NEW_TOY_ADDED");
end);
