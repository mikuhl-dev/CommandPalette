local _, addon = ...;

local L = addon.L;

local cached = false;
local secureCommands = {};

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    ChatFrame_ImportAllListsToHash();

    for command in pairs(hash_SlashCmdList) do
        local title = string.format(L["Use Command: %s"], string.lower(command));
        if CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                action = {
                    type = "macro",
                    macrotext = command,
                }
            });
        end;
    end;

    if not cached then
        for name, value in pairs(_G) do
            -- perf: string.byte faster than string.sub
            if string.byte(name) == 83 and      -- S
                string.byte(name, 2) == 76 and  -- L
                string.byte(name, 3) == 65 and  -- A
                string.byte(name, 4) == 83 and  -- S
                string.byte(name, 5) == 72 and  -- H
                string.byte(name, 6) == 95 then -- _
                if IsSecureCmd(value) then
                    secureCommands[value] = true;
                end;
            end;
        end;
        cached = true;
    end;

    for command in pairs(secureCommands) do
        local title = string.format(L["Use Command: %s"], command);
        if CommandPalette:MatchesSearch(title) then
            CommandPalette:AddAction({
                title = title,
                action = {
                    type = "macro",
                    macrotext = command,
                }
            });
        end;
    end;
end);
