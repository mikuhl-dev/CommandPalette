local _, addon = ...;

local function index(_, key)
    return key;
end;

addon.L = setmetatable({}, { __index = index });
