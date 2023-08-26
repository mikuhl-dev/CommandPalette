local _, addon = ...;

local L = addon.L;

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    for _, bookType in pairs({ BOOKTYPE_SPELL, BOOKTYPE_PET }) do
        local isPet = bookType == BOOKTYPE_PET;
        local i = 1;
        while true do
            local spellBookItemName = { GetSpellBookItemName(i, bookType) };
            local spellName = spellBookItemName[1];
            local spellID = spellBookItemName[3];
            if spellName == nil then
                break;
            end;
            if spellID ~= nil then
                local title = string.format(L["Cast Spell: %s"], spellName);
                if IsSpellKnown(spellID, isPet) and
                    not IsPassiveSpell(i, bookType) and
                    CommandPalette:MatchesSearch(title) then
                    CommandPalette:AddAction({
                        title = title,
                        icon = GetSpellBookItemTexture(i, bookType),
                        cooldown = GenerateClosure(GetSpellCooldown, spellID),
                        action = {
                            type = "spell",
                            spell = spellID,
                        }
                    });
                end;
            end;
            i = i + 1;
        end;
    end;
end);
