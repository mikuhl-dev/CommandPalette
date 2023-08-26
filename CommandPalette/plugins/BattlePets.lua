local _, addon = ...;

local L = addon.L;

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    C_PetJournal.SetSearchFilter("");
    C_PetJournal.SetDefaultFilters();
    for i = 1, C_PetJournal.GetNumPets() do
        local petInfo = { C_PetJournal.GetPetInfoByIndex(i) };
        local petID = petInfo[1];
        local owned = petInfo[3];
        local customName = petInfo[4];
        local speciesName = petInfo[8];
        local icon = petInfo[9];

        local title = string.format(L["Summon Battle Pet: %s"], customName or speciesName);
        if owned and C_PetJournal.PetIsUsable(petID) and CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                icon = icon,
                action = {
                    type = "macro",
                    macrotext = string.format([[/run C_PetJournal.SummonPetByGUID("%s")]], petID),
                }
            });
        end;
    end;

    do -- Dismiss
        local title = L["Dismiss Battle Pet"];
        if CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                icon = 136095,
                action = {
                    type = "macro",
                    macrotext = [[/dismisspet]],
                }
            });
        end;
    end;

    do -- Random Pet
        local title = L["Summon Random Battle Pet"];
        if CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                icon = 652131,
                action = {
                    type = "macro",
                    macrotext = [[/randompet]]
                }
            });
        end;
    end;

    do -- Random Favorite
        local title = L["Summon Random Favorite Battle Pet"];
        if CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                icon = 652131,
                action = {
                    type = "macro",
                    macrotext = [[/randomfavoritepet]]
                }
            });
        end;
    end;
end);
