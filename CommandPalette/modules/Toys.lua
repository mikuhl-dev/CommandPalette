---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;
local Async = addon.Async;

CommandPalette.RegisterModule(L["Toys"], function(self)
    C_ToyBox.SetFilterString("");
    C_ToyBoxInfo.SetDefaultFilters();

    local numToys = C_ToyBox.GetNumFilteredToys();
    for i = 1, numToys do
        local itemID = C_ToyBox.GetToyFromIndex(i);
        if PlayerHasToy(itemID) then
            Async.WaitForItemData(itemID);

            local toyInfo = { C_ToyBox.GetToyInfo(itemID) };
            local name = toyInfo[2];
            local icon = toyInfo[3];

            self.CreateAction({
                name = format(L["Use Toy: %s"], name),
                icon = icon,
                quality = C_Item.GetItemQualityByID(itemID),
                cooldown = GenerateClosure(GetItemCooldown, itemID),
                tooltip = GenerateClosure(GameTooltip.SetToyByItemID, GameTooltip, itemID),
                pickup = GenerateClosure(C_ToyBox.PickupToyBoxItem, itemID),
                action = {
                    type = "toy",
                    toy = itemID,
                }
            });
        end;
    end;

    self.RegisterEvent("NEW_TOY_ADDED");
end);
