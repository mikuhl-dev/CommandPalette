local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Toys"], {
    OnEnable = function()
        frame:RegisterEvent("NEW_TOY_ADDED");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        C_ToyBox.SetFilterString("");
        C_ToyBoxInfo.SetDefaultFilters();

        actions = {};

        local numToys = C_ToyBox.GetNumToys();
        for i = 1, numToys do
            local itemId = C_ToyBox.GetToyFromIndex(i);
            if PlayerHasToy(itemId) then
                local toyInfo = { C_ToyBox.GetToyInfo(itemId) };
                local name = toyInfo[2];
                local icon = toyInfo[3];
                if name ~= nil then
                    table.insert(actions, {
                        name = string.format(L["Use Toy: %s"], name),
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

        return actions;
    end,
});
