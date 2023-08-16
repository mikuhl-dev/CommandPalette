local _, addon = ...

local L = addon.L

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    for tabIndex = 1, GetNumSpellTabs() do
        local spellTabInfo = { GetSpellTabInfo(tabIndex) }
        local offset = spellTabInfo[3]
        local numSpells = spellTabInfo[4]
        for spellIndex = offset + 1, offset + numSpells do
            local spellInfo = { GetSpellInfo(spellIndex, BOOKTYPE_SPELL) }
            local name = spellInfo[1]
            local icon = spellInfo[3]
            local spellID = spellInfo[7]
            if name ~= nil then
                local title = string.format(L["Cast Spell: %s"], name)
                if IsSpellKnown(spellID) and
                    IsUsableSpell(spellID) and
                    not IsPassiveSpell(spellID) and
                    CommandPalette:MatchesSearch(title) then
                    CommandPalette:AddAction({
                        title = title,
                        icon = icon,
                        cooldown = GenerateClosure(GetSpellCooldown, spellID),
                        action = {
                            type = "spell",
                            spell = spellID,
                        }
                    })
                end
            end
        end
    end
end)
