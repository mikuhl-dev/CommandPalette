---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

local units = {
    "player",
    "vehicle",
    "pet",
    "target",
    "focus",
    "npc",
    "questnpc",
    "mouseover",
    "anyenemy",
    "anyfriend",
    "anyinteract",
    "softenemy",
    "softfriend",
    "softinteract",
};

for i = 1, 4 do
    tinsert(units, "party" .. i);
end;

for i = 1, 5 do
    tinsert(units, "arena" .. i);
    tinsert(units, "boss" .. i);
end;

for i = 1, 40 do
    tinsert(units, "raid" .. i);
    tinsert(units, "raidpet" .. i);
    tinsert(units, "nameplate" .. i);
end;

for i = 1, #units do
    tinsert(units, units[i] .. "target");
end;

CommandPalette.RegisterModule(L["Targets"], function(self)
    -- Gather names.
    local names = {};
    for _, unit in pairs(units) do
        if UnitExists(unit) then
            local name = GetUnitName(unit, true);
            if name ~= nil then
                names[name] = names[name] or {};
                tinsert(names[name], unit);
            end;
        end;
    end;

    -- Loop through names.
    for name, unitTokens in pairs(names) do
        local macrotext = format([[/targetexact %s]], name);

        local function FindUnitToken()
            -- Try to find unit quickly.
            for _, unitToken in pairs(unitTokens) do
                if GetUnitName(unitToken, true) == name then
                    return unitToken;
                end;
            end;
            -- Try to find unit otherwise.
            for _, unitToken in pairs(units) do
                if GetUnitName(unitToken, true) == name then
                    return unitToken;
                end;
            end;
            return nil;
        end;

        self.CreateAction({
            name = format(L["Target: %s"], name),
            icon = function(texture)
                local unitToken = FindUnitToken();
                if unitToken then
                    SetPortraitTexture(texture, unitToken, true);
                else
                    texture:SetTexture(134400);
                end;
            end,
            tooltip = function()
                local unitToken = FindUnitToken();
                if unitToken then
                    GameTooltip:SetUnit(unitToken);
                end;
            end,
            pickup = function()
                local index = GetMacroIndexByName(macrotext);
                if index == 0 then
                    index = CreateMacro(macrotext, 136243, macrotext);
                end;
                PickupMacro(index);
            end,
            action = {
                type = "macro",
                macrotext = macrotext,
            }
        });
    end;

    self.RegisterEvent("GROUP_ROSTER_UPDATE");
    self.RegisterEvent("NAME_PLATE_CREATED");
    self.RegisterEvent("NAME_PLATE_UNIT_ADDED");
    self.RegisterEvent("NAME_PLATE_UNIT_REMOVED");
    self.RegisterEvent("PLAYER_FOCUS_CHANGED");
    self.RegisterEvent("PLAYER_SOFT_ENEMY_CHANGED");
    self.RegisterEvent("PLAYER_SOFT_FRIEND_CHANGED");
    self.RegisterEvent("PLAYER_SOFT_INTERACT_CHANGED");
    self.RegisterEvent("PLAYER_TARGET_CHANGED");
    self.RegisterEvent("RAID_ROSTER_UPDATE");
    self.RegisterEvent("VEHICLE_UPDATE");
    self.RegisterUnitEvent("UNIT_PET", "player");
end);
