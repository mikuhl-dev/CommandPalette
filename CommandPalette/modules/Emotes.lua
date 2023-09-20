local _, addon = ...;

local L = addon.L;

local actions = nil;

hooksecurefunc("ChatFrame_ImportEmoteTokensToHash", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Emotes"], {
    OnEnable = function()
        actions = nil;
    end,

    OnDisable = function()
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        ChatFrame_ImportEmoteTokensToHash();

        actions = {};

        for command in pairs(hash_EmoteTokenList) do
            table.insert(actions, {
                name = string.format(L["Use Emote: %s"], string.lower(command)),
                pickup = function()
                    local index = GetMacroIndexByName(command);
                    if index == 0 then
                        index = CreateMacro(command, 136243, command);
                    end;
                    PickupMacro(index);
                end,
                action = {
                    type = "macro",
                    macrotext = command,
                }
            });
        end;

        return actions;
    end,
});
