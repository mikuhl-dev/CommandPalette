---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Battle Pets"], function(self)
    C_PetJournal.ClearSearchFilter();
    C_PetJournal.SetDefaultFilters();

    for i = 1, C_PetJournal.GetNumPets() do
        local petInfo = { C_PetJournal.GetPetInfoByIndex(i) };
        local petID = petInfo[1];
        local customName = petInfo[4];
        local speciesName = petInfo[8];
        local icon = petInfo[9];

        if petID ~= nil then
            coroutine.yield({
                name = string.format(L["Summon Battle Pet: %s"], customName or speciesName),
                icon = icon,
                tooltip = GenerateClosure(GameTooltip.SetCompanionPet, GameTooltip, petID),
                pickup = GenerateClosure(C_PetJournal.PickupPet, petID),
                action = {
                    type = "script",
                    _script = function()
                        C_PetJournal.SummonPetByGUID(petID);
                    end,
                }
            });
        end;
    end;

    self.RegisterEvent("NEW_PET_ADDED");
    self.RegisterEvent("PET_JOURNAL_PET_DELETED");
    self.RegisterEvent("PET_JOURNAL_PET_RESTORED");
    self.RegisterEvent("PET_JOURNAL_PET_REVOKED");
end);
