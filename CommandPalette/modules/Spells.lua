---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Spells"], function(self)
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
            if spellID ~= nil and IsSpellKnown(spellID, isPet) and not IsPassiveSpell(i, bookType) then
                coroutine.yield({
                    name = string.format(L["Cast Spell: %s"], spellName),
                    icon = GetSpellBookItemTexture(i, bookType),
                    cooldown = GenerateClosure(GetSpellCooldown, spellID),
                    tooltip = GenerateClosure(GameTooltip.SetSpellByID, GameTooltip, spellID),
                    pickup = GenerateClosure(PickupSpell, spellID),
                    action = {
                        type = "spell",
                        spell = spellID,
                    }
                });
            end;
            i = i + 1;
        end;
    end;

    self.RegisterEvent("SPELLS_CHANGED");
end);
