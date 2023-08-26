local _, addon = ...;

local L = addon.L;

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    local numTitles = GetNumTitles();
    for titleID = 0, numTitles do
        if IsTitleKnown(titleID) or titleID == 0 then
            local titleName = GetTitleName(titleID) or "No Title";
            local title = "Set Title: " .. titleName;
            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    action = {
                        type = "macro",
                        macrotext = string.format([[/run SetCurrentTitle(%d)]], titleID),
                    }
                });
            end;
        end;
    end;
end);
