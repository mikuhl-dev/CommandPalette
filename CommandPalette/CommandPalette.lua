local addonName, addon = ...

local L = addon.L

BINDING_HEADER_COMMANDPALETTE = L["Command Palette"]
BINDING_NAME_OPENCOMMANDPALETTE = L["Open Command Palette"]

local dataProvider = CreateDataProvider()
dataProvider:SetSortComparator(function(a, b)
    local aScore = CommandPaletteHistory[a.title] or 0
    local bScore = CommandPaletteHistory[b.title] or 0
    if aScore == bScore then
        return b.title > a.title
    end
    return aScore > bScore
end)

_CommandPalette = {
    scripts = {
        OnLoad = function(self)
            self:SetTitle(L["Command Palette"])

            ButtonFrameTemplate_HidePortrait(self)

            EventRegistry:RegisterCallback("EnumerateUnits.Update", function()
                self:UpdateActions()
            end, self)
        end,

        OnShow = function(self)
            self:SetSearch("")
            -- Needed because EditBox has a bug with some keybinds.
            -- Funnily enough, Blizzard does this for the Chat EditBox.
            C_Timer.After(0, function()
                self:SetSearch("")
            end)
        end,

        OnHide = function(self)
            ClearOverrideBindings(self)
        end,
    },

    methods = {
        TryShow = function(self)
            if not InCombatLockdown() then
                self:Show()
            end
        end,

        TryHide = function(self)
            if not InCombatLockdown() then
                self:Hide()
            end
        end,

        SetSearch = function(self, search)
            self.SearchBox:SetText(search)

            self.search = {}
            for part in string.gmatch(string.lower(search), "%S+") do
                table.insert(self.search, part)
            end

            self:UpdateActions()
            self:SetSelected(1)
        end,

        UpdateActions = function(self)
            if self:IsShown() then
                dataProvider:Flush()
                self.actions = {}
                EventRegistry:TriggerEvent("CommandPalette.UpdateActions")
                dataProvider:InsertTable(self.actions)
                self:SetSelected(self.selected or 1)
            end
        end,

        MatchesSearch = function(self, text)
            text = strlower(text)
            for _, part in ipairs(self.search or {}) do
                if not strfind(text, part, 1, true) then
                    return false
                end
            end
            return true
        end,

        AddAction = function(self, action)
            table.insert(self.actions, action)
        end,

        SetSelected = function(self, selected)
            selected = max(selected, 1)
            selected = min(selected, dataProvider:GetSize())
            self.selected = selected

            local scrollBox = self.ScrollBox
            local data = scrollBox:FindElementData(selected)
            if data ~= nil then
                scrollBox:ScrollToElementData(data)
                scrollBox:ForEachFrame(function(frame)
                    frame:UpdateHighlight()
                end)

                local button = CommandPaletteSecureActionButton
                button.historyKey = data.title
                button:SetAttributes(nil)
                button:SetBinding(nil, nil)
                if data.action ~= nil then
                    button:SetAttributes(data.action)
                    SetOverrideBindingClick(self, true, "ENTER", button:GetName(), "LeftButton")
                elseif data.binding ~= nil then
                    button:SetBinding("ENTER", data.binding)
                    button:UpdateBinding(true)
                end
            else
                ClearOverrideBindings(self)
            end
        end,
    },

    events = {
        PLAYER_REGEN_DISABLED = function(self)
            self:TryHide()
        end,
        ADDON_LOADED = function(_, name)
            if addonName == name then
                CommandPaletteHistory = CommandPaletteHistory or {}
            end
        end,
        GLOBAL_MOUSE_DOWN = function(self)
            if self:IsShown() and not MouseIsOver(self) then
                self:TryHide()
            end
        end,
    },
}

_CommandPaletteSearchBox = {
    scripts = {
        OnEscapePressed = function(self)
            self:ClearFocus()
            CommandPalette:TryHide()
        end,

        OnTextChanged = function(self)
            CommandPalette:SetSearch(self:GetText())
        end,

        OnKeyDown = function(self, key)
            if key == "UP" then
                CommandPalette:SetSelected(CommandPalette.selected - 1)
            elseif key == "DOWN" then
                CommandPalette:SetSelected(CommandPalette.selected + 1)
            elseif key == "ENTER" then
                local button = CommandPaletteSecureActionButton
                if button.bindingKey == key then
                    button:UpdateHistory()
                end
            end
            self:SetPropagateKeyboardInput(key == "ENTER")
        end,
    },
}

_CommandPaletteScrollBox = {
    scripts = {
        OnLoad = function(self)
            local view = CreateScrollBoxListLinearView(8, 8, 8, 8, 8)
            view:SetElementInitializer("CommandPaletteButtonTemplate", function(frame, data)
                frame:SetData(data)
            end)

            ScrollUtil.InitScrollBoxListWithScrollBar(self, CommandPalette.ScrollBar, view)
            self:SetDataProvider(dataProvider)

            -- Needed for CommandPaletteSecureActionButton Bindings
            self.ScrollTarget:SetPassThroughButtons("LeftButton", "MiddleButton", "RightButton")
        end,
    }
}

_CommandPaletteButton = {
    scripts = {
        OnLoad = function(self)
            self.IconButton:EnableMouse(false)
        end,

        OnEnter = function(self)
            self:UpdateHighlight()
        end,

        OnLeave = function(self)
            self:UpdateHighlight()
        end,
    },
    methods = {
        SetData = function(self, data)
            self.data = data
            self.historyKey = data.title

            self:SetTitle(data.title)
            self:SetIcon(data.icon)
            self:SetQuality(data.quality)
            self:SetAttributes(data.action)
            self:SetBinding("BUTTON1", data.binding)

            self:UpdateCooldown()
            self:UpdateHighlight()
        end,

        SetTitle = function(self, title)
            self:SetText(title)
        end,

        SetIcon = function(self, icon)
            local iconButton = self.IconButton
            local iconButtonIcon = iconButton.icon

            iconButtonIcon:SetTexCoord(0, 1, 0, 1)
            if type(icon) == "function" then
                icon(iconButtonIcon)
            else
                iconButtonIcon:SetTexture(icon or 136243)
            end
            iconButton:SetChecked(false)
        end,

        SetQuality = function(self, quality)
            local iconButton = self.IconButton
            local normalTexture = iconButton.NormalTexture
            local border = iconButton.Border
            if quality ~= nil then
                local color = ITEM_QUALITY_COLORS[quality]
                normalTexture:SetVertexColor(color.r, color.g, color.b)
                border:SetVertexColor(color.r, color.g, color.b)
                border:Show()
            else
                normalTexture:SetVertexColor(1, 1, 1)
                border:Hide()
            end
        end,

        UpdateCooldown = function(self)
            local frame = self.IconButton.cooldown
            local cooldown = self.data.cooldown
            if cooldown then
                CooldownFrame_Set(frame, cooldown())
            else
                CooldownFrame_Clear(frame)
            end
        end,

        UpdateHighlight = function(self)
            local index = dataProvider:FindIndex(self.data)
            local iconButton = self.IconButton
            if MouseIsOver(self) or CommandPalette.selected == index then
                self:LockHighlight()
                iconButton:LockHighlight()
            else
                self:UnlockHighlight()
                iconButton:UnlockHighlight()
            end
        end,
    },

    events = {
        SPELL_UPDATE_COOLDOWN = function(self, ...)
            self:UpdateCooldown()
        end,
    }
}

local buttonKeys = {
    BUTTON1 = "LeftButton",
    BUTTON2 = "RightButton",
    BUTTON3 = "MiddleButton",
    LeftButton = "BUTTON1",
    RightButton = "BUTTON2",
    MiddleButton = "BUTTON3",
}

_CommandPaletteSecureActionButton = {
    scripts = {

        OnEnter = function(self)
            self:UpdateBinding(true)
        end,

        OnClick = function(self)
            self:UpdateHistory()
        end,

        OnLeave = function(self)
            self:UpdateBinding(false)
        end,

        OnHide = function(self)
            self:UpdateBinding(false)
        end,
    },

    methods = {

        SetHistoryKey = function(self, key)
            self.historyKey = key
        end,

        UpdateHistory = function(self)
            CommandPaletteHistory[self.historyKey] = time()
            C_Timer.After(0, function()
                CommandPalette:TryHide()
            end)
        end,

        SetAttributes = function(self, attributes)
            for key in pairs(self.attributes or {}) do
                self:SetAttribute(key, nil)
            end
            self.attributes = attributes
            for key, value in pairs(self.attributes or {}) do
                self:SetAttribute(key, value)
            end
        end,

        SetBinding = function(self, key, binding)
            if key == nil or binding == nil then
                self.binding = nil
                self.bindingKey = nil
            else
                self.binding = binding
                self.bindingKey = key
            end
            self:UpdateBinding(MouseIsOver(self))
        end,

        UpdateBinding = function(self, enable)
            ClearOverrideBindings(self)
            self:SetPassThroughButtons()

            if enable then
                local binding = self.binding
                local key = self.bindingKey
                if binding ~= nil and key ~= nil then
                    SetOverrideBinding(self, true, key, binding)
                    local buttonKey = buttonKeys[key]
                    if buttonKey ~= nil then
                        self:SetPassThroughButtons(buttonKey)
                    end
                end
            end
        end,
    },

    events = {
        GLOBAL_MOUSE_DOWN = function(self, button)
            if MouseIsOver(self) then
                local bindingKey = self.bindingKey
                if bindingKey ~= nil then
                    local buttonKey = buttonKeys[bindingKey]
                    if buttonKey ~= nil and buttonKey == button then
                        self:UpdateHistory()
                    end
                end
            end
        end,
    }
}
