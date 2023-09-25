---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Titles"], function(self)
    local numTitles = GetNumTitles();
    for titleID = 0, numTitles do
        if IsTitleKnown(titleID) or titleID == 0 then
            local titleName = GetTitleName(titleID) or PLAYER_TITLE_NONE;
            coroutine.yield({
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

    self.RegisterEvent("KNOWN_TITLES_UPDATE");
end);
