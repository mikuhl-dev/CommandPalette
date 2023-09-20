local _, addon = ...;

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

for i = 1, #units do
    table.insert(units, units[i] .. "target");
end;

CommandPalette.RegisterModule(L["Targets"], {
    GetActions = function()
        local actions = {};

        -- Gather names.
        local names = {};
        for _, unit in pairs(units) do
            if UnitExists(unit) then
                local name = UnitName(unit);
                if name ~= nil then
                    names[name] = names[name] or {};
                    table.insert(names[name], unit);
                end;
            end;
        end;

        -- Loop through names.
        for name, unitTokens in pairs(names) do
            local macrotext = string.format([[/targetexact %s]], name);
            table.insert(actions, {
                name = string.format(L["Target: %s"], name),
                icon = function(texture)
                    -- Try to find unit quickly.
                    for _, unitToken in pairs(unitTokens) do
                        if UnitName(unitToken) == name then
                            return SetPortraitTexture(texture, unitToken, true);
                        end;
                    end;
                    -- Try to find unit otherwise.
                    for _, unitToken in pairs(units) do
                        if UnitName(unitToken) == name then
                            return SetPortraitTexture(texture, unitToken, true);
                        end;
                    end;
                    -- Cannot find unit.
                    texture:SetTexture(134400);
                end,
                tooltip = function()
                    -- Try to find unit quickly.
                    for _, unitToken in pairs(unitTokens) do
                        if UnitName(unitToken) == name then
                            return GameTooltip:SetUnit(unitToken);
                        end;
                    end;
                    -- Try to find unit otherwise.
                    for _, unitToken in pairs(units) do
                        if UnitName(unitToken) == name then
                            return GameTooltip:SetUnit(unitToken);
                        end;
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

        return actions;
    end,
});
