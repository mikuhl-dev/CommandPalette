local _, addon = ...;

local L = addon.L;

local actions = nil;

local frame = CreateFrame("Frame");

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Items"], {
    OnEnable = function()
        frame:RegisterEvent("BAG_UPDATE_DELAYED");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

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
                            table.insert(actions, {
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

        return actions;
    end
});
