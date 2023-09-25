---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Mounts"], function(self)
    for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
        local mountInfo = { C_MountJournal.GetMountInfoByID(mountID) };
        local name = mountInfo[1];
        local spellID = mountInfo[2];
        local icon = mountInfo[3];
        local isUsable = mountInfo[5];

        if isUsable then
            coroutine.yield({
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

    self.RegisterEvent("NEW_MOUNT_ADDED");
end);
