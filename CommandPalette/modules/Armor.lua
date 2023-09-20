local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Armor"], {
    OnEnable = function()
        frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        for slotIndex = 0, CONTAINER_BAG_OFFSET do
            local itemID = GetInventoryItemID("player", slotIndex);
            if itemID then
                local itemName = C_Item.GetItemNameByID(itemID);
                if itemName ~= nil then
                    if GetItemSpell(itemID) ~= nil then
                        table.insert(actions, {
                            name = string.format(L["Use Armor: %s"], itemName),
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

        return actions;
    end,
});
