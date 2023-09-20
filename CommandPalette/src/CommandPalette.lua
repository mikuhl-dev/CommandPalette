local addonName, addon = ...;

local L = addon.L;

BINDING_HEADER_COMMANDPALETTE = L["Command Palette"];
BINDING_NAME_OPENCOMMANDPALETTE = L["Open Command Palette"];

local settingsCategory = Settings.RegisterVerticalLayoutCategory(L["Command Palette"]);
local modulesCategory = Settings.RegisterVerticalLayoutSubcategory(settingsCategory, L["Modules"]);

Settings.RegisterAddOnCategory(settingsCategory);

EventUtil.ContinueOnAddOnLoaded(addonName, function()
    do -- Keybindings
        local initializer = CreateSettingsListSectionHeaderInitializer(SETTINGS_KEYBINDINGS_LABEL);
        Settings.RegisterInitializer(settingsCategory, initializer);
    end;

    do -- Open Command Palette
        local bindingIndex = C_KeyBindings.GetBindingIndex("OPENCOMMANDPALETTE");
        local initializer = CreateKeybindingEntryInitializer(bindingIndex, true);
        Settings.RegisterInitializer(settingsCategory, initializer);
    end;

    do -- Danger Zone
        local initializer = CreateSettingsListSectionHeaderInitializer(L["Danger Zone"]);
        Settings.RegisterInitializer(settingsCategory, initializer);
    end;

    do -- Reset Usage
        local initializer = CreateSettingsButtonInitializer(L["Action Usage"], RESET, function(...)
            local timestamps = CommandPalette.GetActionTimestamps();
            for key in pairs(timestamps) do
                timestamps[key] = nil;
            end;
        end, L["Resets the order of actions in the Command Palette."]);
        Settings.RegisterInitializer(settingsCategory, initializer);
    end;
end);

CommandPalette = {};

do -- Hide/Show
    function CommandPalette.Show()
        return not InCombatLockdown() and CommandPaletteFrame:Show();
    end;

    function CommandPalette.Hide()
        return not InCombatLockdown() and CommandPaletteFrame:Hide();
    end;
end;

do -- Settings
    function CommandPalette.GetSettings()
        CommandPaletteSettings = CommandPaletteSettings or {};
        return CommandPaletteSettings;
    end;

    function CommandPalette.GetDisabledModules()
        local settings = CommandPalette.GetSettings();
        settings.disabledModules = settings.disabledModules or {};
        return settings.disabledModules;
    end;

    function CommandPalette.GetActionTimestamps()
        local settings = CommandPalette.GetSettings();
        settings.actionTimestamps = settings.actionTimestamps or {};
        return settings.actionTimestamps;
    end;
end;

do -- Modules
    do
        local _modules = {};

        function CommandPalette.RegisterModule(name, module)
            _modules[name] = module;

            local variable = "COMMAND_PALETTE_MODULE_" .. string.upper(name);

            local setting = Settings.RegisterAddOnSetting(modulesCategory, name, variable, "boolean", true);

            Settings.CreateCheckBox(modulesCategory, setting, string.format(L["Enables the %s module."], name));
            Settings.SetOnValueChangedCallback(variable, function(_, _, value)
                if value then
                    CommandPalette.EnableModule(name);
                else
                    CommandPalette.DisableModule(name);
                end;
            end);

            EventUtil.ContinueOnAddOnLoaded(addonName, function()
                local enabled = CommandPalette.IsModuleEnabled(name);
                if enabled then
                    CommandPalette.EnableModule(name);
                end;
                setting:SetValue(enabled);
            end);
        end;

        function CommandPalette.GetModule(name)
            return _modules[name];
        end;

        function CommandPalette.EnumerateModules()
            return pairs(_modules);
        end;
    end;

    function CommandPalette.EnableModule(name)
        CommandPalette.GetDisabledModules()[name] = nil;
        local module = CommandPalette.GetModule(name);
        return module and module.OnEnable and module.OnEnable();
    end;

    function CommandPalette.IsModuleEnabled(name)
        return not CommandPalette.GetDisabledModules()[name];
    end;

    function CommandPalette.DisableModule(name)
        CommandPalette.GetDisabledModules()[name] = true;
        local module = CommandPalette.GetModule(name);
        return module and module.OnDisable and module.OnDisable();
    end;
end;

do -- Timestamps
    function CommandPalette.GetActionTimestamp(name)
        return CommandPalette.GetActionTimestamps()[name] or 0;
    end;

    function CommandPalette.UpdateActionTimestamp(name)
        CommandPalette.GetActionTimestamps()[name] = time();
    end;
end;

do -- Search
    local _search = "";

    function CommandPalette.SetSearch(search)
        _search = search;
        CommandPalette.UpdateActions();
    end;

    function CommandPalette.GetSearch()
        return _search;
    end;
end;

do -- Actions
    do
        local _actions = CreateDataProvider();

        function CommandPalette.GetActions()
            return _actions;
        end;
    end;

    function CommandPalette.UpdateActions()
        -- Split the search text into parts.
        local parts = {};
        for part in string.gmatch(string.lower(CommandPalette.GetSearch()), "%S+") do
            table.insert(parts, part);
        end;

        -- Create a function that checks if all parts match the value.
        local function matches(value)
            value = strlower(value);
            for _, part in ipairs(parts or {}) do
                if not strfind(value, part, 1, true) then
                    return false;
                end;
            end;
            return true;
        end;

        -- Gather all actions from enabled modules where the search text matches the action name.
        local actions = {};
        for name, module in CommandPalette.EnumerateModules() do
            if CommandPalette.IsModuleEnabled(name) then
                for _, action in ipairs(module:GetActions()) do
                    if matches(action.name) then
                        table.insert(actions, action);
                    end;
                end;
            end;
        end;

        -- Sort actions based on when they were last used, otherwise, sort by name.
        table.sort(actions, function(a, b)
            local aTimestamp = CommandPalette.GetActionTimestamp(a.name);
            local bTimestamp = CommandPalette.GetActionTimestamp(b.name);
            if aTimestamp == bTimestamp then
                return b.name > a.name;
            end;
            return aTimestamp > bTimestamp;
        end);

        -- Update the DataProvider.
        local dataProvider = CommandPalette.GetActions();
        dataProvider:Flush();
        dataProvider:InsertTable(actions);

        -- Reset the selection.
        CommandPalette.SetSelected(#actions > 0 and actions[1] or nil);
    end;
end;

do -- Selection
    do
        local _selected = nil;

        function CommandPalette.SetSelected(selected)
            _selected = selected;

            local button = CommandPaletteSecureActionButton;
            button:SetActionData(selected);
            if button:GetAttribute("type") == "binding" then
                SetOverrideBinding(button, true, "ENTER", button:GetAttribute("binding"));
            else
                SetOverrideBindingClick(button, true, "ENTER", button:GetName(), "LeftButton");
            end;
        end;

        function CommandPalette.GetSelected()
            return _selected;
        end;
    end;

    function CommandPalette.OffsetSelected(offset)
        local dataProvider = CommandPalette.GetActions();
        local index = dataProvider:FindIndex(CommandPalette.GetSelected());
        local data = nil;
        if index ~= nil then
            index = index + offset;
            index = max(index, 1);
            index = min(index, dataProvider:GetSize());
            data = dataProvider:Find(index);
        end;
        CommandPalette.SetSelected(data);
    end;
end;
