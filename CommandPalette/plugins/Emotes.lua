local _, addon = ...;

local L = addon.L;

local cached = false;
local emotes = {};

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    if not cached then
        ChatFrame_ImportAllListsToHash();

        for command in pairs(hash_EmoteTokenList) do
            emotes[string.lower(command)] = true;
        end;

        cached = true;
    end;

    for command in pairs(emotes) do
        local title = string.format(L["Use Emote: %s"], command);
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
