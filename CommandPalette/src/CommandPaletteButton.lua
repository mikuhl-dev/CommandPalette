function MixinCommandPaletteButton(self)
    do -- Data
        local _data = nil;

        function self:SetActionData(data)
            if data ~= nil then
                self:SetText(data.name);
                self:SetIcon(data.icon);
                self:SetCooldown(data.cooldown);
                self:SetQuality(data.quality);
                self:SetAction(data.action);
                self:SetTooltip(data.tooltip);
                self:SetPickup(data.pickup);
            end;
            _data = data;
            self:UpdateHighlight();
        end;

        function self:GetActionData()
            return _data;
        end;
    end;

    function self:SetIcon(icon)
        local iconButton = self.IconButton;
        local iconButtonIcon = iconButton.icon;

        if type(icon) == "function" then
            -- Fixes the lag that some functions create when scrolling through the list very fast.
            iconButtonIcon:SetTexture(nil);
            icon(iconButtonIcon);
        else
            iconButtonIcon:SetTexture(icon or 136243);
        end;
    end;

    function self:SetCooldown(cooldown)
        local cooldownFrame = self.IconButton.cooldown;
        if cooldown then
            CooldownFrame_Set(cooldownFrame, cooldown());
        else
            CooldownFrame_Clear(cooldownFrame);
        end;
    end;

    function self:SetQuality(quality)
        local iconButton = self.IconButton;
        local normalTexture = iconButton.NormalTexture;
        local border = iconButton.Border;
        if quality ~= nil then
            local color = ITEM_QUALITY_COLORS[quality];
            normalTexture:SetVertexColor(color.r, color.g, color.b);
            border:SetVertexColor(color.r, color.g, color.b);
            border:Show();
        else
            normalTexture:SetVertexColor(1, 1, 1);
            border:Hide();
        end;
    end;

    do -- Action
        local _action = {};

        function self:SetAction(action)
            for key in pairs(_action) do
                self:SetAttribute(key, nil);
            end;

            _action = action or {};

            -- https://github.com/Stanzilla/WoWUIBugs/issues/317#issuecomment-1510847497
            _action.pressAndHoldAction = true;
            _action.typerelease = _action.typerelease or _action.type;

            for key, value in pairs(_action) do
                self:SetAttribute(key, value);
            end;

            if self:GetAttribute("type") == "binding" then
                self:SetPassThroughButtons("BUTTON1");
            else
                self:SetPassThroughButtons();
            end;
        end;
    end;

    do -- Tooltip
        local _tooltip = nil;

        function self:SetTooltip(tooltip)
            _tooltip = tooltip;
        end;

        function self:ShowTooltip()
            if _tooltip ~= nil then
                GameTooltip:SetOwner(self.IconButton, "ANCHOR_RIGHT");
                _tooltip();
                GameTooltip:Show();
            end;
        end;
    end;

    do -- Pickup
        local _pickup = nop;

        function self:SetPickup(pickup)
            _pickup = pickup or nop;
        end;

        function self:Pickup()
            return _pickup();
        end;
    end;

    do -- Highlight
        function self:UpdateHighlight()
            local iconButton = self.IconButton;
            if self:IsVisible() and MouseIsOver(self) or CommandPalette.GetSelected() == self:GetActionData() then
                self:LockHighlight();
                iconButton:LockHighlight();
            else
                self:UnlockHighlight();
                iconButton:UnlockHighlight();
            end;
        end;

        self:HookScript("OnEnter", function()
            self:UpdateHighlight();
            if self:GetAttribute("type") == "binding" then
                SetOverrideBinding(self, true, "BUTTON1", self:GetAttribute("binding"));
            else
                ClearOverrideBindings(self);
            end;
        end);

        self:HookScript("OnLeave", function()
            self:UpdateHighlight();
            ClearOverrideBindings(self);
        end);

        hooksecurefunc(CommandPalette, "SetSelected", function()
            self:UpdateHighlight();
        end);
    end;

    do -- Icon Button
        local iconButton = self.IconButton;

        iconButton:HookScript("OnEnter", function()
            self:UpdateHighlight();
            self:ShowTooltip();
        end);

        iconButton:HookScript("OnLeave", function()
            self:UpdateHighlight();
            return GameTooltip:IsOwned(iconButton) and GameTooltip:Hide();
        end);

        iconButton:HookScript("OnDragStart", function()
            self:Pickup();
        end);
    end;

    self:HookScript("OnClick", function()
        local name = self:GetText();
        if name then
            CommandPalette.UpdateActionTimestamp(name);
        end;
        CommandPaletteFrame:Hide();
    end);

    self:HookScript("OnHide", function()
        ClearOverrideBindings(self);
    end);

    do -- Events
        local _events = {
            GLOBAL_MOUSE_DOWN = function(...)
                if self:IsVisible()
                    and MouseIsOver(self)
                    and self:GetAttribute("type") == "binding" then
                    self:SetButtonState("PUSHED");
                end;
            end,
            GLOBAL_MOUSE_UP = function(...)
                self:SetButtonState("NORMAL");
                if self:IsVisible()
                    and MouseIsOver(self)
                    and self:GetAttribute("type") == "binding" then
                    ExecuteFrameScript(self, "OnClick");
                end;
            end,
        };

        self:HookScript("OnEvent", function(_, event, ...)
            return _events[event] and _events[event](...);
        end);

        for event in pairs(_events) do
            self:RegisterEvent(event);
        end;
    end;

    return self;
end;
