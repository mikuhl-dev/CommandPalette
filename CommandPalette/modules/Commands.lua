---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

local function CreateCommandAction(command)
    command = string.lower(command);
    return {
        name = string.format(L["Use Command: %s"], command),
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
    };
end;

local _secureCommands = nil;
local function GetSecureCommands()
    if _secureCommands ~= nil then return _secureCommands; end;
    _secureCommands = {};
    for name, value in pairs(_G) do
        -- perf: string.byte faster than string.sub
        if string.byte(name) == 83 and      -- S
            string.byte(name, 2) == 76 and  -- L
            string.byte(name, 3) == 65 and  -- A
            string.byte(name, 4) == 83 and  -- S
            string.byte(name, 5) == 72 and  -- H
            string.byte(name, 6) == 95 then -- _
            if IsSecureCmd(value) then
                _secureCommands[value] = true;
            end;
        end;
    end;
    return _secureCommands;
end;

local module = CommandPalette.RegisterModule(L["Commands"], function(self)
    ChatFrame_ImportAllListsToHash();

    for command in pairs(hash_SlashCmdList) do
        coroutine.yield(CreateCommandAction(command));
    end;

    for command in pairs(GetSecureCommands()) do
        coroutine.yield(CreateCommandAction(command));
    end;
end);

hooksecurefunc("ChatFrame_ImportAllListsToHash", module.ClearActions);
