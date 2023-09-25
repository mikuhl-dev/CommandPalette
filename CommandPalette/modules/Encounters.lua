---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

local events = {
    "EJ_DIFFICULTY_UPDATE",
    "EJ_LOOT_DATA_RECIEVED",
    "PORTRAITS_UPDATED",
    "SEARCH_DB_LOADED",
    "UI_MODEL_SCENE_INFO_UPDATED",
    "UNIT_PORTRAIT_UPDATE",
};

CommandPalette.RegisterModule(L["Encounters"], function()
    -- Temporarily needed to allow us to browse the journal without interference.
    if EncounterJournal ~= nil then
        for _, event in pairs(events) do
            EncounterJournal:UnregisterEvent(event);
        end;
    end;

    local ignore = {};

    local numTiers = EJ_GetNumTiers();
    for tierIndex = 1, numTiers - 1 do
        local tierInfo = { EJ_GetTierInfo(tierIndex) };
        local tierName = tierInfo[1];

        coroutine.yield({
            name = string.format(L["View Dungeons: %s"], tierName),
            icon = 521753,
            action = {
                type = "encounter",
                _encounter = function()
                    EncounterJournal_LoadUI();
                    EJ_ContentTab_Select(EncounterJournal.dungeonsTab:GetID());
                    EncounterJournal_OpenJournal(nil, nil, nil, nil, nil, nil, tierIndex - 1);
                end,
            }
        });

        coroutine.yield({
            name = string.format(L["View Raids: %s"], tierName),
            icon = 521753,
            action = {
                type = "encounter",
                _encounter = function()
                    EncounterJournal_LoadUI();
                    EJ_ContentTab_Select(EncounterJournal.raidsTab:GetID());
                    EncounterJournal_OpenJournal(nil, nil, nil, nil, nil, nil, tierIndex - 1);
                end,
            }
        });

        EJ_SelectTier(tierIndex);

        for _, isRaid in pairs({ false, true }) do
            local instanceIndex = 1;
            while true do
                local instanceInfo = { EJ_GetInstanceByIndex(instanceIndex, isRaid) };

                local instanceID = instanceInfo[1];

                if instanceID == nil then
                    break;
                end;

                local instanceName = instanceInfo[2];

                if not ignore[instanceName] then
                    ignore[instanceName] = true;

                    local instanceImage = instanceInfo[7];

                    coroutine.yield({
                        name = string.format(isRaid and L["View Raid: %s"] or L["View Dungeon: %s"], instanceName),
                        icon = instanceImage,
                        action = {
                            type = "encounter",
                            _encounter = function()
                                EncounterJournal_LoadUI();
                                EncounterJournal_OpenJournal(nil, instanceID, nil, nil, nil, nil, tierIndex - 1);
                            end,
                        }
                    });

                    EJ_SelectInstance(instanceID);

                    for _, difficultyID in pairs({ 1, 2, 14, 15, 16, 17, 23, 24, 33 }) do
                        if EJ_IsValidInstanceDifficulty(difficultyID) then
                            EJ_SetDifficulty(difficultyID);

                            local encounterIndex = 1;
                            while true do
                                local encounterInfo = { EJ_GetEncounterInfoByIndex(encounterIndex) };

                                local encounterName = encounterInfo[1];

                                if encounterName == nil then
                                    break;
                                end;

                                if not ignore[encounterName] then
                                    ignore[encounterName] = true;

                                    local encounterDescription = encounterInfo[2];
                                    local encounterID = encounterInfo[3];

                                    local creatureInfo = { EJ_GetCreatureInfo(1, encounterID) };
                                    local displayInfo = creatureInfo[4];

                                    coroutine.yield({
                                        name = string.format(L["View Encounter: %s"], encounterName),
                                        icon = function(texture)
                                            SetPortraitTextureFromCreatureDisplayID(texture, displayInfo);
                                        end,
                                        tooltip = function()
                                            GameTooltip_SetTitle(GameTooltip, encounterName);
                                            GameTooltip_AddNormalLine(GameTooltip, encounterDescription);
                                        end,
                                        action = {
                                            type = "encounter",
                                            _encounter = function()
                                                EncounterJournal_LoadUI();
                                                EncounterJournal_OpenJournal(difficultyID, instanceID, encounterID,
                                                    nil, nil, nil, tierIndex - 1);
                                            end,
                                        }
                                    });
                                end;

                                encounterIndex = encounterIndex + 1;
                            end;
                        end;
                    end;
                end;

                instanceIndex = instanceIndex + 1;
            end;
        end;
    end;

    -- Put everything back after we are done.
    if EncounterJournal ~= nil then
        for _, event in pairs(events) do
            EncounterJournal:RegisterEvent(event);
        end;
    end;
end);
