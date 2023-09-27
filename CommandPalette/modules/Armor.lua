---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Armor"], function(self)
    for slotIndex = 0, CONTAINER_BAG_OFFSET do
        local itemID = GetInventoryItemID("player", slotIndex);
        if itemID then
            local itemName = C_Item.GetItemNameByID(itemID);
            if itemName ~= nil then
                if GetItemSpell(itemID) ~= nil then
                    self.CreateAction({
                        name = format(L["Use Armor: %s"], itemName),
                        icon = C_Item.GetItemIconByID(itemID),
                        quality = C_Item.GetItemQualityByID(itemID),
                        cooldown = GenerateClosure(GetItemCooldown, itemID),
                        tooltip = GenerateClosure(GameTooltip.SetInventoryItem, GameTooltip, "player", slotIndex),
                        action = {
                            type = "item",
                            item = slotIndex,
                        }
                    });
                end;
            end;
        end;
    end;

    self.RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
end);
