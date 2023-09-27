---@class CommandPaletteAddon
local addon = select(2, ...);

do -- Logger
    local Logger = {};

    function Logger.Log(...)
        if CommandPalette.IsDebugMode() then
            print("[Command Palette]", ...);
        end;
    end;

    addon.Logger = Logger;
end;
