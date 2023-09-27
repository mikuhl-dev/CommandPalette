---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Professions"], function(self)
    local professions = { GetProfessions() };
    for _, spellTabIndex in pairs(professions) do
        local professionInfo = { GetProfessionInfo(spellTabIndex) };
        local name = professionInfo[1];
        local icon = professionInfo[2];
        local spellOffset = professionInfo[6];
        local skillLineID = professionInfo[7];
        self.CreateAction({
            name = format(L["Open Profession: %s"], name),
            icon = icon,
            tooltip = GenerateClosure(GameTooltip.SetSpellBookItem, GameTooltip, spellOffset + 1,
                BOOKTYPE_SPELL),
            pickup = GenerateClosure(PickupSpellBookItem, spellOffset + 1, BOOKTYPE_SPELL),
            action = {
                type = "script",
                _script = function()
                    C_TradeSkillUI.OpenTradeSkill(skillLineID);
                end,
            }
        });
    end;

    self.RegisterEvent("SKILL_LINES_CHANGED");
end);
