---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;
local Async = addon.Async;
local Search = addon.Search;

CommandPalette = {};

do -- Search
    do
        local _search = "";

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

    ---@param loading string|false
    function CommandPalette.SetLoading(loading)
        if loading then
            _loading = format(L["Loading %s..."], loading);
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

        function CommandPalette.SetActions(actions)
            _actions.collection = actions or {};
            _actions:TriggerEvent(DataProviderMixin.Event.OnSizeChanged, false);
        end;

        function CommandPalette.GetActions()
            return _actions;
        end;
    end;

    do
        local _task = nil;

        function CommandPalette.UpdateActions()
            _task = _task or Async.CreateTask(function()
                CommandPalette.SetLoading(L["Command Palette"]);

                local search = Search.CreateSearch(CommandPalette.GetSearch());
                local actions = {};
                local index = 1;
                for module in CommandPalette.EnumerateModules() do
                    if module.IsEnabled() then
                        CommandPalette.SetLoading(module.GetName());
                        for action in module.EnumerateActions() do
                            if search.Matches(action.name) then
                                actions[index] = action;
                                index = index + 1;
                            end;
                        end;
                    end;
                end;

                CommandPalette.SetLoading(L["Command Palette"]);

                do
                    local timestamps = CommandPalette.GetActionTimestamps();
                    sort(actions, function(a, b)
                        local aTimestamp = timestamps[a.name] or 0;
                        local bTimestamp = timestamps[b.name] or 0;
                        if aTimestamp == bTimestamp then
                            return b.name > a.name;
                        end;
                        return aTimestamp > bTimestamp;
                    end);
                end;

                CommandPalette.SetActions(actions);
                CommandPalette.SetSelected(#actions > 0 and actions[1] or nil);
                CommandPalette.SetLoading(false);

                _task = nil;
            end);
        end;
    end;
end;
