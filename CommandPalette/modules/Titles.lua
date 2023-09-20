local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Titles"], {
    OnEnable = function()
        frame:RegisterEvent("KNOWN_TITLES_UPDATE");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        local numTitles = GetNumTitles();
        for titleID = 0, numTitles do
            if IsTitleKnown(titleID) or titleID == 0 then
                local titleName = GetTitleName(titleID) or PLAYER_TITLE_NONE;
                table.insert(actions, {
                    name = string.format(L["Set Title: %s"], titleName),
                    action = {
                        type = "script",
                        _script = function()
                            SetCurrentTitle(titleID);
                        end,
                    }
                });
            end;
        end;

        return actions;
    end,
});
