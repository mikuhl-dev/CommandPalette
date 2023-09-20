local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Mounts"], {
    OnEnable = function()
        frame:RegisterEvent("NEW_MOUNT_ADDED");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
            local mountInfo = { C_MountJournal.GetMountInfoByID(mountID) };
            local name = mountInfo[1];
            local spellID = mountInfo[2];
            local icon = mountInfo[3];
            local isUsable = mountInfo[5];

            if isUsable then
                table.insert(actions, {
                    name = string.format(L["Summon Mount: %s"], name),
                    icon = icon,
                    tooltip = GenerateClosure(GameTooltip.SetMountBySpellID, GameTooltip, spellID),
                    pickup = GenerateClosure(PickupSpell, spellID),
                    action = {
                        type = "script",
                        _script = function()
                            C_MountJournal.SummonByID(mountID);
                        end,
                    }
                });
            end;
        end;

        return actions;
    end,
});
