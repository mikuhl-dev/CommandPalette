---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

local module = CommandPalette.RegisterModule(L["Emotes"], function(self)
    ChatFrame_ImportEmoteTokensToHash();

    for command in pairs(hash_EmoteTokenList) do
        self.CreateAction({
            name = format(L["Use Emote: %s"], strlower(command)),
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
end);

hooksecurefunc("ChatFrame_ImportEmoteTokensToHash", module.ClearActions);
