---@type string, CommandPaletteAddon
local addonName, addon = ...;

local L = addon.L;

BINDING_HEADER_COMMANDPALETTE = L["Command Palette"];
BINDING_NAME_OPENCOMMANDPALETTE = L["Open Command Palette"];

function CommandPalette.ContinueOnAddOnLoaded(callback)
    return EventUtil.ContinueOnAddOnLoaded(addonName, callback);
end;

do -- Settings
    local function _GetSettings()
        CommandPaletteSettings = CommandPaletteSettings or {};
        return CommandPaletteSettings;
    end;

    do -- Disabled Modules
        local function _GetDisabledModules()
            local settings = _GetSettings();
            settings.disabledModules = settings.disabledModules or {};
            return settings.disabledModules;
        end;

        ---@param name string
        function CommandPalette.IsModuleDisabled(name)
            return _GetDisabledModules()[name] == true;
        end;

        ---@param name string
        ---@param disabled boolean
        function CommandPalette.SetModuleDisabled(name, disabled)
            if disabled then
                _GetDisabledModules()[name] = true;
            else
                _GetDisabledModules()[name] = nil;
            end;
        end;
    end;

    do -- Action Timestamps
        function CommandPalette.GetActionTimestamps()
            local settings = _GetSettings();
            settings.actionTimestamps = settings.actionTimestamps or {};
            return settings.actionTimestamps;
        end;

        function CommandPalette.ClearActionTimestamps()
            local settings = _GetSettings();
            settings.actionTimestamps = {};
        end;

        ---@param name string
        function CommandPalette.UpdateActionTimestamp(name)
            CommandPalette.GetActionTimestamps()[name] = time();
        end;
    end;

    do -- Debug Mode
        function CommandPalette.IsDebugMode()
            local settings = _GetSettings();
            return settings.debugMode or false;
        end;

        function CommandPalette.SetDebugMode(debugMode)
            local settings = _GetSettings();
            settings.debugMode = debugMode;
        end;
    end;
end;

do -- Settings Category
    local _settingsCategory = Settings.RegisterVerticalLayoutCategory(L["Command Palette"]);
    Settings.RegisterAddOnCategory(_settingsCategory);

    CommandPalette.ContinueOnAddOnLoaded(function()
        do -- Keybindings
            local initializer = CreateSettingsListSectionHeaderInitializer(SETTINGS_KEYBINDINGS_LABEL);
            Settings.RegisterInitializer(_settingsCategory, initializer);
        end;

        do -- Open Command Palette
            local bindingIndex = C_KeyBindings.GetBindingIndex("OPENCOMMANDPALETTE");
            local initializer = CreateKeybindingEntryInitializer(bindingIndex, true);
            Settings.RegisterInitializer(_settingsCategory, initializer);
        end;

        do -- Danger Zone
            local initializer = CreateSettingsListSectionHeaderInitializer(L["Danger Zone"]);
            Settings.RegisterInitializer(_settingsCategory, initializer);
        end;

        do -- Reset Usage
            local initializer = CreateSettingsButtonInitializer(L["Action Usage"], RESET,
                CommandPalette.ClearActionTimestamps, L["Resets the order of actions in the Command Palette."], true);
            Settings.RegisterInitializer(_settingsCategory, initializer);
        end;

        do -- Debug Mode
            local name = "Debug Mode";
            local variable = "COMMAND_PALETTE_SETTING_DEBUG_MODE";
            local setting = Settings.RegisterAddOnSetting(_settingsCategory, name, variable, "boolean", false);
            setting:SetValue(CommandPalette.IsDebugMode());

            Settings.CreateCheckBox(_settingsCategory, setting, format("Enables Debug Mode", name));
            Settings.SetOnValueChangedCallback(variable, function(_, _, value)
                CommandPalette.SetDebugMode(true);
            end);
        end;
    end);

    do -- Modules Category
        local _modulesCategory = Settings.RegisterVerticalLayoutSubcategory(_settingsCategory, L["Modules"]);

        ---@param module CommandPaletteModule
        function CommandPalette.RegisterModuleSettings(module)
            CommandPalette.ContinueOnAddOnLoaded(function()
                local name = module.GetName();

                local variable = "COMMAND_PALETTE_MODULE_" .. strupper(name);

                local setting = Settings.RegisterAddOnSetting(_modulesCategory, name, variable, "boolean", true);

                local enabled = module.IsEnabled();
                if enabled then
                    module.Enable();
                end;
                setting:SetValue(enabled);

                Settings.CreateCheckBox(_modulesCategory, setting, format(L["Enables the %s module."], name));
                Settings.SetOnValueChangedCallback(variable, function(_, _, value)
                    if value then
                        module:Enable();
                    else
                        module:Disable();
                    end;
                end);
            end);
        end;
    end;
end;
