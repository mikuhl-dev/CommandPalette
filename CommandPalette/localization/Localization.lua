---@class CommandPaletteAddon
local addon = select(2, ...);

local function index(_, key)
    return key;
end;

---@type table<string, string>
addon.L = setmetatable({}, { __index = index });
