---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

function MixinCommandPaletteFrame(self)
    local searchBox = self.SearchBox;
    local scrollBox = self.ScrollBox;
    local scrollBar = self.ScrollBar;
    local spinner = self.Spinner;

    self:SetTitle(L["Command Palette"]);

    tinsert(UISpecialFrames, self:GetName());

    ButtonFrameTemplate_HidePortrait(self);

    do -- Show
        local _show = self.Show;

        function self:Show()
            return not InCombatLockdown() and _show(self);
        end;
    end;

    do -- Hide
        local _hide = self.Hide;

        function self:Hide()
            return not InCombatLockdown() and _hide(self);
        end;
    end;

    do -- Search Box
        searchBox:Disable();

        searchBox:HookScript("OnShow", function()
            CommandPalette.ClearSearch();
        end);

        hooksecurefunc(CommandPalette, "SetSearch", function(search)
            searchBox:SetText(search);
        end);

        searchBox:HookScript("OnTextChanged", function()
            CommandPalette.SetSearch(searchBox:GetText());
        end);

        searchBox:HookScript("OnEscapePressed", function()
            self:Hide();
        end);

        searchBox:HookScript("OnHide", function()
            searchBox:Disable();
            ClearOverrideBindings(CommandPaletteSecureActionButton);
        end);

        do
            local _ticker = nil;

            searchBox:HookScript("OnKeyDown", function(_, key)
                if key == "UP" then
                    CommandPalette.OffsetSelected(-1);
                elseif key == "DOWN" then
                    CommandPalette.OffsetSelected(1);
                elseif key == "ENTER" then
                    if _ticker ~= nil then
                        _ticker:Cancel();
                    end;
                    _ticker = C_Timer.NewTicker(0, function()
                        if not IsKeyDown(key) then
                            if _ticker ~= nil then
                                _ticker:Cancel();
                            end;
                            ExecuteFrameScript(CommandPaletteSecureActionButton, "OnClick");
                        end;
                    end);
                end;
                searchBox:SetPropagateKeyboardInput(key == "ENTER");
            end);
        end;
    end;

    do -- Scroll Box
        local scrollView = CreateScrollBoxListLinearView(8, 8, 8, 8, 8);

        scrollView:SetElementInitializer("CommandPaletteButtonTemplate", function(frame, data)
            frame:SetActionData(data);
        end);

        ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, scrollView);

        scrollBox:SetDataProvider(CommandPalette.GetActions());

        scrollBox.ScrollTarget:SetPassThroughButtons("BUTTON1");

        hooksecurefunc(CommandPalette, "SetSelected", function(data)
            scrollBox:ScrollToElementData(data);
        end);
    end;

    do -- Spinner
        hooksecurefunc(CommandPalette, "SetLoading", function()
            local loading = CommandPalette.GetLoading();
            if loading then
                spinner:Show();
                spinner.Text:SetText(loading);
                searchBox:Disable();
                scrollBox:Hide();
            else
                spinner:Hide();
                searchBox:Enable();
                searchBox:SetFocus();
                scrollBox:Show();
            end;
        end);
    end;

    do -- Events
        local events = {
            PLAYER_REGEN_DISABLED = function(...)
                self:Hide();
            end,
        };

        self:HookScript("OnEvent", function(_, event, ...)
            return events[event] and events[event](...);
        end);

        for event in pairs(events) do
            self:RegisterEvent(event);
        end;
    end;

    return self;
end;
