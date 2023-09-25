---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Heirlooms"], function(self)
    for _, itemID in pairs(C_Heirloom.GetHeirloomItemIDs()) do
        if C_Heirloom.PlayerHasHeirloom(itemID) then
            local heirloomInfo = { C_Heirloom.GetHeirloomInfo(itemID) };
            local name = heirloomInfo[1];
            local itemTexture = heirloomInfo[4];
            coroutine.yield({
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

    self.RegisterEvent("HEIRLOOMS_UPDATED");
end);
