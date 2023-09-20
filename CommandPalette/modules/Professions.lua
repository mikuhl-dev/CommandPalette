local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Professions"], {
    OnEnable = function()
        frame:RegisterEvent("SKILL_LINES_CHANGED");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        local professions = { GetProfessions() };
        for _, spellTabIndex in pairs(professions) do
            local professionInfo = { GetProfessionInfo(spellTabIndex) };
            local name = professionInfo[1];
            local icon = professionInfo[2];
            local spellOffset = professionInfo[6];
            local skillLineID = professionInfo[7];
            table.insert(actions, {
                name = string.format(L["Open Profession: %s"], name),
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

        return actions;
    end,
});
