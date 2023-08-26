local _, addon = ...;

local L = addon.L;

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    local professions = { GetProfessions() };
    for _, spellTabIndex in pairs(professions) do
        local professionInfo = { GetProfessionInfo(spellTabIndex) };
        local name = professionInfo[1];
        local icon = professionInfo[2];
        local skillLineID = professionInfo[7];
        local title = string.format(L["Open Profession: %s"], name);
        if CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                icon = icon,
                action = {
                    type = "macro",
                    macrotext = string.format([[/run C_TradeSkillUI.OpenTradeSkill(%d)]], skillLineID),
                }
            });
        end;
    end;
end);
