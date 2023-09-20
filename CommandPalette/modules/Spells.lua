local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Spells"], {
    OnEnable = function()
        frame:RegisterEvent("SPELLS_CHANGED");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

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
                    table.insert(actions, {
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

        return actions;
    end,
});
