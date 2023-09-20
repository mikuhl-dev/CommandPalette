local _, addon = ...;

local L = addon.L;

local frame = CreateFrame("Frame");

local actions = nil;

frame:SetScript("OnEvent", function()
    actions = nil;
end);

local function CreateMacroAction(macroIndex)
    local macroInfo = { GetMacroInfo(macroIndex) };
    local name = macroInfo[1];
    local icon = macroInfo[2];
    local body = macroInfo[3];
    return {
        name = string.format(L["Use Macro: %s"], name),
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

CommandPalette.RegisterModule(L["Macros"], {
    OnEnable = function()
        frame:RegisterEvent("UPDATE_MACROS");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        local numAccountMacros, numCharacterMacros = GetNumMacros();

        for macroIndex = 1, numAccountMacros do
            table.insert(actions, CreateMacroAction(macroIndex));
        end;

        for macroIndex = MAX_ACCOUNT_MACROS + 1, MAX_ACCOUNT_MACROS + numCharacterMacros do
            table.insert(actions, CreateMacroAction(macroIndex));
        end;

        return actions;
    end,
});
