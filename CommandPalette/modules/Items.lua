---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Items"], function(self)
    for containerIndex = 0, NUM_BAG_SLOTS + 1 do
        for slotIndex = 0, C_Container.GetContainerNumSlots(containerIndex) do
            local itemID = C_Container.GetContainerItemID(containerIndex, slotIndex);
            if itemID then
                local itemName = C_Item.GetItemNameByID(itemID);
                if itemName ~= nil then
                    local name = nil;

                    if IsEquippableItem(itemID) then
                        name = string.format(L["Equip Item: %s"], itemName);
                    elseif GetItemSpell(itemID) ~= nil then
                        name = string.format(L["Use Item: %s"], itemName);
                    end;

                    if name ~= nil then
                        coroutine.yield({
                            name = name,
                            icon = C_Item.GetItemIconByID(itemID),
                            quality = C_Item.GetItemQualityByID(itemID),
                            cooldown = GenerateClosure(GetItemCooldown, itemID),
                            tooltip = GenerateClosure(GameTooltip.SetBagItem, GameTooltip, containerIndex, slotIndex),
                            pickup = GenerateClosure(C_Container.PickupContainerItem, containerIndex, slotIndex),
                            action = {
                                type = "item",
                                bag = containerIndex,
                                slot = slotIndex
                            }
                        });
                    end;
                end;
            end;
        end;
    end;

    self.RegisterEvent("BAG_UPDATE_DELAYED");
end);
