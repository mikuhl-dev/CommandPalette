local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Equipment Sets"], {
    OnEnable = function()
        frame:RegisterEvent("EQUIPMENT_SETS_CHANGED");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        actions = {};

        for _, equipmentSetID in ipairs(C_EquipmentSet.GetEquipmentSetIDs()) do
            local equipmentSetInfo = { C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID) };
            local name = equipmentSetInfo[1];
            local iconFileID = equipmentSetInfo[2];
            table.insert(actions, {
                name = string.format(L["Equip Equipment Set: %s"], name),
                icon = iconFileID,
                tooltip = GenerateClosure(GameTooltip.SetEquipmentSet, GameTooltip, equipmentSetID),
                pickup = GenerateClosure(C_EquipmentSet.PickupEquipmentSet, equipmentSetID),
                action = {
                    type = "equipmentset",
                    equipmentset = name,
                }
            });
        end;

        return actions;
    end,
});
