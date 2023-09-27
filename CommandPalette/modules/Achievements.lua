---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Achievements"], function(self)
    for _, categoryID in pairs(GetCategoryList()) do
        local numAchievements = GetCategoryNumAchievements(categoryID, true);
        for i = 1, numAchievements do
            local achievementInfo = { GetAchievementInfo(categoryID, i) };
            local id = achievementInfo[1];
            local name = achievementInfo[2];
            local icon = achievementInfo[10];
            if name ~= nil then
                self.CreateAction({
                    name = format(L["Achievement: %s"], name),
                    icon = icon,
                    tooltip = GenerateClosure(GameTooltip.SetAchievementByID, GameTooltip, id),
                    action = {
                        type = "achievement",
                        _achievement = function()
                            AchievementFrame_LoadUI();
                            ShowUIPanel(AchievementFrame);
                            AchievementFrame_SelectAchievement(id);
                        end,
                    }
                });
            end;
        end;
    end;
end);
