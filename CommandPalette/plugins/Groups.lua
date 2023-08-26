local _, addon = ...;

local L = addon.L;

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
        local title = L["Ready Check"];
        if CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                action = {
                    type = "macro",
                    macrotext = [[/readycheck]],
                }
            });
        end;
    end;
end);
