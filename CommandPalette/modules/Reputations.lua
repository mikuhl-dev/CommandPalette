---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

local function EnumerateFactions()
    local index = 0;
    local headers = {};
    return function()
        while true do
            index = index + 1;
            if index > GetNumFactions() then
                -- Reset the remaining headers.
                if #headers > 0 then
                    for i = #headers, 1, -1 do
                        local header = headers[i];
                        if header.isCollapsed then
                            CollapseFactionHeader(header.index);
                        else
                            ExpandFactionHeader(header.index);
                        end;
                    end;
                end;
                return nil;
            end;
            local factionInfo = { GetFactionInfo(index) };
            local isHeader = factionInfo[9];
            local isCollapsed = factionInfo[10];
            local isChild = factionInfo[13];
            local header = headers[#headers];
            if isHeader then
                -- Reset the current header.
                if header ~= nil and not isChild then
                    headers[#header] = nil;
                    if header.isCollapsed then
                        CollapseFactionHeader(header.index);
                        index = index - header.numChildren;
                    else
                        ExpandFactionHeader(header.index);
                    end;
                end;
                -- Expand the current header.
                header = {
                    index = index,
                    isCollapsed = isCollapsed,
                    numChildren = 0,
                };
                table.insert(headers, header);
                ExpandFactionHeader(index);
            else
                header.numChildren = header.numChildren + 1;
                return index, factionInfo;
            end;
        end;
    end;
end;

CommandPalette.RegisterModule(L["Reputations"], function(self)
    for _, factionInfo in EnumerateFactions() do
        local name = factionInfo[1];
        local description = factionInfo[2];
        local standingID = factionInfo[3];
        local barMin = factionInfo[4];
        local barMax = factionInfo[5];
        local barValue = factionInfo[6];
        local atWarWith = factionInfo[7];
        local factionID = factionInfo[14];
        coroutine.yield({
            name = string.format(L["View Reputation: %s"], name),
            icon = 236681,
            tooltip = function()
                GameTooltip_SetTitle(GameTooltip, name);
                GameTooltip_AddNormalLine(GameTooltip, description);
                GameTooltip_AddBlankLinesToTooltip(GameTooltip, 1);
                GameTooltip:AddLine(NORMAL_FONT_COLOR:WrapTextInColorCode(STANDING .. ": ") ..
                    HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(_G["FACTION_STANDING_LABEL" .. standingID]));
                GameTooltip:AddLine(NORMAL_FONT_COLOR:WrapTextInColorCode(REPUTATION .. ": ") ..
                    HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(barValue - barMin .. " / " .. barMax - barMin));
                if atWarWith then
                    GameTooltip_AddBlankLinesToTooltip(GameTooltip, 1);
                    GameTooltip_AddErrorLine(GameTooltip, AT_WAR);
                end;
            end,
            action = {
                type = "reputation",
                _reputation = function()
                    for index, factionInfo in EnumerateFactions() do
                        if factionInfo[14] == factionID then
                            HideUIPanel(ReputationFrame);
                            ToggleCharacter("ReputationFrame", true);
                            local scrollBox = ReputationFrame.ScrollBox;
                            local elementData = scrollBox:FindElementData(index);
                            if elementData == nil then return; end;
                            scrollBox:ScrollToElementData(elementData);
                            local button = scrollBox:FindFrame(elementData);
                            if button == nil then return; end;
                            button:Click();
                            break;
                        end;
                    end;
                end,
            }
        });
    end;

    self.RegisterEvent("QUEST_LOG_UPDATE");
    self.RegisterEvent("UPDATE_FACTION");
    self.RegisterEvent("MAJOR_FACTION_RENOWN_LEVEL_CHANGED");
    self.RegisterEvent("MAJOR_FACTION_UNLOCKED");
end);
