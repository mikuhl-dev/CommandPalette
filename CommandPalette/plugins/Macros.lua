local _, addon = ...;

local L = addon.L;

local function addMacroAction(macroIndex)
    local macroInfo = { GetMacroInfo(macroIndex) };
    local name = macroInfo[1];
    local icon = macroInfo[2];
    if name ~= nil then
        local title = string.format(L["Use Macro: %s"], name);
        if CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                icon = icon,
                action = {
                    type = "macro",
                    macro = macroIndex
                }
            });
        end;
    end;
end;

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    local numAccountMacros, numCharacterMacros = GetNumMacros();

    for macroIndex = 1, numAccountMacros do
        addMacroAction(macroIndex);
    end;

    for macroIndex = MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + numCharacterMacros do
        addMacroAction(macroIndex);
    end;
end);
