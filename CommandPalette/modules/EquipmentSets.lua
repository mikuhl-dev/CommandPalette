---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Equipment Sets"], function(self)
    for _, equipmentSetID in ipairs(C_EquipmentSet.GetEquipmentSetIDs()) do
        local equipmentSetInfo = { C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID) };
        local name = equipmentSetInfo[1];
        local iconFileID = equipmentSetInfo[2];
        self.CreateAction({
            name = format(L["Equip Equipment Set: %s"], name),
            icon = iconFileID,
            tooltip = GenerateClosure(GameTooltip.SetEquipmentSet, GameTooltip, equipmentSetID),
            pickup = GenerateClosure(C_EquipmentSet.PickupEquipmentSet, equipmentSetID),
            action = {
                type = "equipmentset",
                equipmentset = name,
            }
        });
    end;

    self.RegisterEvent("EQUIPMENT_SETS_CHANGED");
end);
