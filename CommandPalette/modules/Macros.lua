---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

---@param macroIndex number
---@return CommandPaletteAction
local function CreateMacroAction(macroIndex)
    local macroInfo = { GetMacroInfo(macroIndex) };
    local name = macroInfo[1];
    local icon = macroInfo[2];
    local body = macroInfo[3];
    return {
        name = format(L["Use Macro: %s"], name),
        icon = icon,
        tooltip = function()
            GameTooltip_SetTitle(GameTooltip, name);
            GameTooltip_AddNormalLine(GameTooltip, body);
        end,
        pickup = GenerateClosure(PickupMacro, macroIndex),
        action = {
            type = "macro",
            macro = macroIndex
        }
    };
end;

CommandPalette.RegisterModule(L["Macros"], function(self)
    local numAccountMacros, numCharacterMacros = GetNumMacros();

    for macroIndex = 1, numAccountMacros do
        self.CreateAction(CreateMacroAction(macroIndex));
    end;

    for macroIndex = MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + numCharacterMacros do
        self.CreateAction(CreateMacroAction(macroIndex));
    end;

    self.RegisterEvent("UPDATE_MACROS");
end);
