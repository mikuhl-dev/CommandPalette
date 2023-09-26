---@class CommandPaletteAddon
local addon = select(2, ...);

local function index(_, key)
    return key;
end;

---@type table<string, string>
addon.L = setmetatable({}, { __index = index });

local L = addon.L;

(({
    deDE = function()
        --@localization(locale="deDE", format="lua_additive_table")@
    end,
    esES = function()
        --@localization(locale="esES", format="lua_additive_table")@
    end,
    esMX = function()
        --@localization(locale="esMX", format="lua_additive_table")@
    end,
    frFR = function()
        --@localization(locale="frFR", format="lua_additive_table")@
    end,
    itIT = function()
        --@localization(locale="itIT", format="lua_additive_table")@
    end,
    koKR = function()
        --@localization(locale="koKR", format="lua_additive_table")@
    end,
    ptBR = function()
        --@localization(locale="ptBR", format="lua_additive_table")@
    end,
    ruRU = function()
        --@localization(locale="ruRU", format="lua_additive_table")@
    end,
    zhCN = function()
        --@localization(locale="zhCN", format="lua_additive_table")@
    end,
    zhTW = function()
        --@localization(locale="zhTW", format="lua_additive_table")@
    end,
})[GetLocale()] or nop)();
