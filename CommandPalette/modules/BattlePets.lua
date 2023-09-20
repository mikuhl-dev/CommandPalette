local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Battle Pets"], {
    OnEnable = function()
        frame:RegisterEvent("NEW_PET_ADDED");
        frame:RegisterEvent("PET_JOURNAL_PET_DELETED");
        frame:RegisterEvent("PET_JOURNAL_PET_RESTORED");
        frame:RegisterEvent("PET_JOURNAL_PET_REVOKED");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        C_PetJournal.ClearSearchFilter();
        C_PetJournal.SetDefaultFilters();

        actions = {};

        for i = 1, C_PetJournal.GetNumPets() do
            local petInfo = { C_PetJournal.GetPetInfoByIndex(i) };
            local petID = petInfo[1];
            local customName = petInfo[4];
            local speciesName = petInfo[8];
            local icon = petInfo[9];

            if petID ~= nil then
                table.insert(actions, {
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

        return actions;
    end,
});
