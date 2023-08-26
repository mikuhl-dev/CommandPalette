local units = {
    "player",
    "target",
    "focus",
    "pet",
    "vehicle",
    "softenemy",
    "softfriend",
    "softinteract",
};

for i = 1, 4 do
    table.insert(units, "party" .. i);
end;

for i = 1, 5 do
    table.insert(units, "arena" .. i);
    table.insert(units, "boss" .. i);
end;

for i = 1, 40 do
    table.insert(units, "raid" .. i);
    table.insert(units, "raidpet" .. i);
    table.insert(units, "nameplate" .. i);
end;


local cache = nil;

function EnumerateUnits()
    if cache ~= nil then return cache; end;

    local found = {};

    for _, unit in pairs(units) do
        if UnitExists(unit) then
            local name = UnitName(unit);
            if name ~= nil and found[name] == nil then
                found[name] = unit;
            end;
            unit = unit .. "target";
            name = UnitName(unit);
            if name ~= nil and found[name] == nil then
                found[name] = unit;
            end;
        end;
    end;

    cache = found;

    C_Timer.After(0, function()
        cache = nil;
    end);

    return found;
end;

local updated = false;
local function triggerUpdate()
    if updated then return; end;

    updated = true;

    EventRegistry:TriggerEvent("EnumerateUnits.Update");

    C_Timer.After(0, function()
        updated = false;
    end);
end;

local frame = CreateFrame("Frame");
frame:SetScript("OnEvent", triggerUpdate);
frame:RegisterEvent("GROUP_JOINED");
frame:RegisterEvent("GROUP_LEFT");
frame:RegisterEvent("GROUP_ROSTER_UPDATE");
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
frame:RegisterEvent("PLAYER_FOCUS_CHANGED");
frame:RegisterEvent("PLAYER_SOFT_ENEMY_CHANGED");
frame:RegisterEvent("PLAYER_SOFT_FRIEND_CHANGED");
frame:RegisterEvent("PLAYER_SOFT_INTERACT_CHANGED");

for _, unit in ipairs(units) do
    local frame = CreateFrame("Frame");
    frame:SetScript("OnEvent", triggerUpdate);
    frame:RegisterUnitEvent("UNIT_PET", unit);
    frame:RegisterUnitEvent("UNIT_TARGET", unit);
end;
