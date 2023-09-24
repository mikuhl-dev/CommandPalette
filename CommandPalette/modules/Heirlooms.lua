local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Heirlooms"], {
    OnEnable = function()
        frame:RegisterEvent("HEIRLOOMS_UPDATED");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        for _, itemID in pairs(C_Heirloom.GetHeirloomItemIDs()) do
            if C_Heirloom.PlayerHasHeirloom(itemID) then
                local heirloomInfo = { C_Heirloom.GetHeirloomInfo(itemID) };
                local name = heirloomInfo[1];
                local itemTexture = heirloomInfo[4];
                table.insert(actions, {
                    name = string.format(L["Create Heirloom: %s"], name),
                    icon = itemTexture,
                    quality = C_Item.GetItemQualityByID(itemID),
                    tooltip = GenerateClosure(GameTooltip.SetHeirloomByItemID, GameTooltip, itemID),
                    action = {
                        type = "heirloom",
                        _heirloom = GenerateClosure(C_Heirloom.CreateHeirloom, itemID)
                    }
                });
            end;
        end;

        return actions;
    end,
});
