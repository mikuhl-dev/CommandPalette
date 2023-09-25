---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;
local Async = addon.Async;

CommandPalette = {};

do -- Search
    do
        local _search = "";
        local _parts = {};

        function CommandPalette.SetSearch(search)
            _search = search;


            return CommandPalette.UpdateActions();
        end;

        function CommandPalette.GetSearch()
            return _search;
        end;
    end;

    function CommandPalette.ClearSearch()
        return CommandPalette.SetSearch("");
    end;
end;

do -- Loading
    ---@type string?
    local _loading = nil;

    ---@param loading string | false
    function CommandPalette.SetLoading(loading)
        if loading then
            _loading = string.format(L["Loading %s..."], loading);
        else
            _loading = nil;
        end;
    end;

    function CommandPalette.GetLoading()
        return _loading;
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

do -- Actions
    do
        local _actions = CreateDataProvider();

        do
            function CommandPalette.SetActions(actions)
                _actions.collection = actions or {};
                _actions:TriggerEvent(DataProviderMixin.Event.OnSizeChanged, false);
            end;

            function CommandPalette.GetActions()
                return _actions;
            end;
        end;

        function CommandPalette.ClearActions()
            return CommandPalette.SetActions(nil);
        end;
    end;

    do
        local _task = nil;

        function CommandPalette.UpdateActions()
            if _task ~= nil then return; end;
            _task = Async.Execute(function()
                -- Gather actions from all modules.
                local _moduleActions = {};
                for module in CommandPalette.EnumerateModules() do
                    if module.IsEnabled() then
                        if module.HasActions() then
                            CommandPalette.SetLoading(false);
                        else
                            CommandPalette.ClearActions();
                            CommandPalette.SetLoading(module.GetName());
                        end;
                        table.insert(_moduleActions, module.GetActions());
                    end;
                end;

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

                -- Gather all actions that match the search text.
                local _actions = {};
                do
                    local timestamps = CommandPalette.GetActionTimestamps();
                    for _, actions in ipairs(_moduleActions) do
                        for _, action in ipairs(actions) do
                            if matches(action.name) then
                                -- perf: cache timestamp for sort
                                action.timestamp = timestamps[action.name] or 0;
                                table.insert(_actions, action);
                            end;
                        end;
                    end;
                end;

                -- Hide loading spinner.
                CommandPalette.SetLoading(false);

                -- Sort actions based on when they were last used, otherwise, sort by name.
                table.sort(_actions, function(a, b)
                    if a.timestamp == b.timestamp then
                        return b.name > a.name;
                    end;
                    return a.timestamp > b.timestamp;
                end);

                -- Update the DataProvider.
                CommandPalette.SetActions(_actions);

                -- Reset the selection.
                CommandPalette.SetSelected(#_actions > 0 and _actions[1] or nil);

                _task = nil;
            end);
        end;
    end;
end;
