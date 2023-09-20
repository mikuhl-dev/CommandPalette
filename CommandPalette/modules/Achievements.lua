local _, addon = ...;

local L = addon.L;

local actions = nil;
local ticker = nil;

CommandPalette.RegisterModule(L["Achievements"], {
    OnEnable = function()
        actions = {};

        local resume = coroutine.wrap(function()
            for _, categoryID in pairs(GetCategoryList()) do
                local numAchievements = GetCategoryNumAchievements(categoryID, true);
                for i = 1, numAchievements do
                    local achievementInfo = { GetAchievementInfo(categoryID, i) };
                    local id = achievementInfo[1];
                    local name = achievementInfo[2];
                    local icon = achievementInfo[10];
                    if name ~= nil then
                        coroutine.yield({
                            name = string.format(L["Achievement: %s"], name),
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

        ticker = C_Timer.NewTicker(0, function(self)
            for _ = 1, 50 do
                local action = resume();
                if action ~= nil then
                    table.insert(actions, action);
                else
                    return self:Cancel();
                end;
            end;
        end);
    end,

    OnDisable = function()
        if ticker ~= nil then
            ticker:Cancel();
        end;
        actions = nil;
    end,

    GetActions = function()
        return actions;
    end
});
