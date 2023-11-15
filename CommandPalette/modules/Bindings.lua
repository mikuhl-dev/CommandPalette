---@class CommandPaletteAddon
local addon = select(2, ...);

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

local _addonIcons = nil;
local function GetAddonIcon(addonName)
    addonName = strlower(addonName);

    if _addonIcons ~= nil then
        return _addonIcons[addonName];
    end;

    _addonIcons = {};

    local numAddons = GetNumAddOns();
    for addonIndex = 1, numAddons do
        local name, title = GetAddOnInfo(addonIndex);
        title = StripHyperlinks(title);
        _addonIcons[strlower(title)] = C_AddOns.GetAddOnMetadata(name, "IconTexture");
    end;

    return _addonIcons[addonName];
end;

CommandPalette.RegisterModule(L["Bindings"], function(self)
    local numBindings = GetNumBindings();
    local headerText = nil;
    local lastCategoryName = nil;
    for i = 1, numBindings do
        local bindingName, categoryName = GetBinding(i);

        local headerName = strmatch(bindingName, "^HEADER_(.+)");
        if headerName ~= nil then
            if strmatch(headerName, "^BLANK") then
                headerText = nil;
            else
                headerText = StripHyperlinks(tostring(_G["BINDING_HEADER_" .. headerName] or headerName));
            end;
        else
            local bindingText = StripHyperlinks(tostring(bindingName and _G["BINDING_NAME_" .. bindingName] or
                bindingName or ""));
            local categoryText = StripHyperlinks(tostring(categoryName and _G[categoryName] or categoryName or OTHER));

            if headerText ~= nil and lastCategoryName ~= categoryName then
                headerText = nil;
            end;

            local name = categoryText .. ": ";
            if headerText ~= nil and headerText ~= categoryText then
                name = name .. headerText .. ": ";
            end;
            name = name .. bindingText;

            local addonIcon = GetAddonIcon(headerText or "") or GetAddonIcon(categoryText or "");

            self.CreateAction({
                name = name,
                icon = _G["BINDING_ICON_" .. bindingName] or addonIcon,
                action = {
                    type = "binding",
                    binding = bindingName,
                    pressAndHoldAction = true,
                    typerelease = "bindingrelease",
                }
            });
        end;

        lastCategoryName = categoryName;
    end;

    self.RegisterEvent("ADDON_LOADED");
end);
