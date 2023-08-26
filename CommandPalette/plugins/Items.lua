local _, addon = ...

local L = addon.L

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    -- Bag Items
    for containerIndex = 0, NUM_BAG_SLOTS + 1 do
        for slotIndex = 0, C_Container.GetContainerNumSlots(containerIndex) do
            local itemID = C_Container.GetContainerItemID(containerIndex, slotIndex)
            if itemID then
                local itemName = C_Item.GetItemNameByID(itemID)
                if itemName ~= nil then
                    local title = nil
                    if IsUsableItem(itemID) or GetItemSpell(itemID) ~= nil then
                        title = string.format(L["Use Bag Item: %s"], itemName)
                    elseif IsEquippableItem(itemID) then
                        title = string.format(L["Equip Bag Item: %s"], itemName)
                    end
                    if title ~= nil and CommandPalette:MatchesSearch(title) then
                        CommandPalette:AddAction({
                            title = title,
                            icon = C_Item.GetItemIconByID(itemID),
                            quality = C_Item.GetItemQualityByID(itemID),
                            cooldown = GenerateClosure(GetItemCooldown, itemID),
                            action = {
                                type = "item",
                                bag = containerIndex,
                                slot = slotIndex
                            }
                        })
                    end
                end
            end
        end
    end
    -- Inventory Items
    for slotIndex = 0, CONTAINER_BAG_OFFSET do
        local itemID = GetInventoryItemID("player", slotIndex)
        if itemID then
            local itemName = C_Item.GetItemNameByID(itemID)
            if itemName ~= nil then
                local title = string.format(L["Use Inventory Item: %s"], itemName)
                if IsUsableItem(itemID) and CommandPalette:MatchesSearch(title) then
                    CommandPalette:AddAction({
                        title = title,
                        icon = C_Item.GetItemIconByID(itemID),
                        quality = C_Item.GetItemQualityByID(itemID),
                        cooldown = GenerateClosure(GetItemCooldown, itemID),
                        action = {
                            type = "item",
                            item = slotIndex,
                        }
                    })
                end
            end
        end
    end
end)
