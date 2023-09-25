---@class CommandPaletteAddon
local addon = select(2, ...);

do -- Modules
    ---@type table<CommandPaletteModule, true?>
    local _modules = {};

    ---@param _name string
    ---@param _updateFn fun(self: CommandPaletteModule)
    function CommandPalette.RegisterModule(_name, _updateFn)
        ---@class CommandPaletteModule
        local self = {};

        function self.GetName()
            return _name;
        end;

        do -- Actions
            local _actions = nil;

            function self.ClearActions()
                _actions = nil;
            end;

            function self.HasActions()
                return _actions ~= nil;
            end;

            function self.GetActions()
                if _actions == nil then
                    self:UnregisterAllEvents();
                    local resume = coroutine.wrap(_updateFn);
                    local actions = {};
                    while true do
                        local action = resume(self);
                        if action == nil then
                            break;
                        end;
                        table.insert(actions, action);
                        coroutine.yield();
                    end;
                    _actions = actions;
                end;
                return _actions;
            end;
        end;

        do -- Events
            local _frame = CreateFrame("Frame");
            _frame:SetScript("OnEvent", self.ClearActions);

            function self.UnregisterAllEvents()
                return _frame:UnregisterAllEvents();
            end;

            ---@param event WowEvent
            function self.RegisterEvent(event)
                return _frame:RegisterEvent(event);
            end;

            ---@param event WowEvent
            ---@param ... UnitId
            function self.RegisterUnitEvent(event, ...)
                return _frame:RegisterUnitEvent(event, ...);
            end;
        end;

        do -- Enable / Disable
            function self.Enable()
                CommandPalette.SetModuleDisabled(_name, false);
                self.UnregisterAllEvents();
                self.ClearActions();
            end;

            function self.Disable()
                CommandPalette.SetModuleDisabled(_name, true);
                self.UnregisterAllEvents();
                self.ClearActions();
            end;

            function self.IsEnabled()
                return not CommandPalette.IsModuleDisabled(_name);
            end;
        end;

        _modules[self] = true;

        CommandPalette.RegisterModuleSettings(self);

        return self;
    end;

    function CommandPalette.EnumerateModules()
        return pairs(_modules);
    end;
end;
