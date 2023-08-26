local _, addon = ...;

local L = addon.L;

BINDING_ICON_ACTIONPAGE1 = 237133;
BINDING_ICON_ACTIONPAGE2 = 237134;
BINDING_ICON_ACTIONPAGE3 = 237135;
BINDING_ICON_ACTIONPAGE4 = 237136;
BINDING_ICON_ACTIONPAGE5 = 237137;
BINDING_ICON_ACTIONPAGE6 = 237138;
BINDING_ICON_CHATBOTTOM = 450905;
BINDING_ICON_CHATPAGEDOWN = 450905;
BINDING_ICON_CHATPAGEUP = 450907;
BINDING_ICON_COMBATLOGBOTTOM = 450905;
BINDING_ICON_COMBATLOGPAGEDOWN = 450905;
BINDING_ICON_COMBATLOGPAGEUP = 450907;
BINDING_ICON_FOLLOWTARGET = 450907;
BINDING_ICON_JUMP = 450907;
BINDING_ICON_MASTERVOLUMEDOWN = 450905;
BINDING_ICON_MASTERVOLUMEUP = 450907;
BINDING_ICON_MOVEANDSTEER = 450907;
BINDING_ICON_MOVEBACKWARD = 450905;
BINDING_ICON_MOVEFORWARD = 450907;
BINDING_ICON_NEXTACTIONPAGE = 135769;
BINDING_ICON_NEXTACTIONPAGE = 135769;
BINDING_ICON_PITCHDOWN = 450905;
BINDING_ICON_PITCHUP = 450907;
BINDING_ICON_PREVIOUSACTIONPAGE = 135768;
BINDING_ICON_RAIDTARGET1 = 137001;
BINDING_ICON_RAIDTARGET2 = 137002;
BINDING_ICON_RAIDTARGET3 = 137003;
BINDING_ICON_RAIDTARGET4 = 137004;
BINDING_ICON_RAIDTARGET5 = 137005;
BINDING_ICON_RAIDTARGET6 = 137006;
BINDING_ICON_RAIDTARGET7 = 137007;
BINDING_ICON_RAIDTARGET8 = 137008;
BINDING_ICON_SITORSTAND = 450905;
BINDING_ICON_STARTAUTORUN = 450907;
BINDING_ICON_STOPAUTORUN = 450905;
BINDING_ICON_STRAFELEFT = 450906;
BINDING_ICON_STRAFERIGHT = 450908;
BINDING_ICON_TOGGLEAUTORUN = 450907;
BINDING_ICON_TOGGLERUN = 450907;
BINDING_ICON_TURNLEFT = 450906;
BINDING_ICON_TURNRIGHT = 450908;
BINDING_ICON_VEHICLEAIMDOWN = 450905;
BINDING_ICON_VEHICLEAIMUP = 450907;

local addonIcons = {};

C_Timer.After(0, function()
    local numAddons = GetNumAddOns();
    for addonIndex = 1, numAddons do
        local name, title = GetAddOnInfo(addonIndex);
        title = StripHyperlinks(title);
        addonIcons[title] = C_AddOns.GetAddOnMetadata(name, "IconTexture");
    end;
end);

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    local numBindings = GetNumBindings();
    local headerText = nil;
    local lastCategoryName = nil;
    for i = 1, numBindings do
        local bindingName, categoryName = GetBinding(i);

        local headerName = string.match(bindingName, "^HEADER_(.+)");
        if headerName ~= nil then
            if string.match(headerName, "^BLANK") then
                headerText = nil;
            else
                headerText = StripHyperlinks(_G["BINDING_HEADER_" .. headerName] or headerName);
            end;
        else
            local bindingText = StripHyperlinks(bindingName and _G["BINDING_NAME_" .. bindingName] or bindingName);
            local categoryText = StripHyperlinks(categoryName and _G[categoryName] or categoryName or OTHER);

            if headerText ~= nil and lastCategoryName ~= categoryName then
                headerText = nil;
            end;

            local title = categoryText .. ": ";
            if headerText ~= nil and headerText ~= categoryText then
                title = title .. headerText .. ": ";
            end;
            title = title .. bindingText;

            local addonIcon = addonIcons[headerText or ""] or addonIcons[categoryText or ""];

            if CommandPalette:MatchesSearch(title) then
                CommandPalette:AddAction({
                    title = title,
                    icon = _G["BINDING_ICON_" .. bindingName] or addonIcon,
                    binding = bindingName,
                });
            end;
        end;

        lastCategoryName = categoryName;
    end;
end);
