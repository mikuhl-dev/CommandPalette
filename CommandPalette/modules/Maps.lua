---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

local mapTypes = {
    [0] = true, -- Cosmic
    [1] = true, -- World
    [2] = true, -- Continent
    [3] = true, -- Zone
    [4] = true, -- Dungeon
};

---@param self CommandPaletteModule
---@param mapInfo UiMapDetails
local function CreateMapActions(self, mapInfo)
    local mapID = mapInfo.mapID;

    -- This being non-nil is required so the map frame does not error.
    if C_Map.GetMapArtLayers(mapID) == nil then
        return;
    end;

    -- Filter out non-major maps.
    if not mapTypes[mapInfo.mapType] then
        return;
    end;

    local name = mapInfo.name;

    -- Rename the map if this map is a member in a group.
    local uiMapGroupID = C_Map.GetMapGroupID(mapID);
    if uiMapGroupID ~= nil then
        local membersInfo = C_Map.GetMapGroupMembersInfo(uiMapGroupID);
        for _, member in pairs(membersInfo or {}) do
            if member.mapID == mapID then
                if member.name ~= name then
                    name = format("%s (%s)", member.name, name);
                end;
                break;
            end;
        end;
    end;

    -- Add map.
    self.CreateAction({
        name = format(L["Open Map: %s"], name),
        icon = 137176,
        action = {
            type = "map",
            _map = function()
                ShowUIPanel(WorldMapFrame);
                WorldMapFrame:SetMapID(mapID);
            end,
        }
    });

    -- Add all child maps.
    local childrenInfo = C_Map.GetMapChildrenInfo(mapID);
    for _, childInfo in pairs(childrenInfo or {}) do
        CreateMapActions(self, childInfo);
    end;
end;

CommandPalette.RegisterModule(L["Maps"], function(self)
    CreateMapActions(self, C_Map.GetMapInfo(946));
end);
