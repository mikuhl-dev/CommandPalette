local _, addon = ...;

local L = addon.L;

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    for _, equipmentSetID in ipairs(C_EquipmentSet.GetEquipmentSetIDs()) do
        local equipmentSetInfo = { C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID) };
        local name = equipmentSetInfo[1];
        local iconFileID = equipmentSetInfo[2];
        if name ~= nil then
            local title = string.format(L["Equip Equipment Set: %s"], name);
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = iconFileID,
                    action = {
                        type = "equipmentset",
                        equipmentset = name,
                    }
                });
            end;
        end;
    end;
end);
