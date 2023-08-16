function CommandPaletteMixin_OnLoad(mixin)
    local parent = mixin:GetParent()
    mixin:SetParent()
    -- Scripts
    if mixin.scripts then
        for name, script in pairs(mixin.scripts) do
            parent:HookScript(name, script)
        end
    end
    -- Events
    if mixin.events then
        for name, _ in pairs(mixin.events) do
            parent:RegisterEvent(name)
        end
        parent:HookScript("OnEvent", function(self, event, ...)
            local func = mixin.events[event]
            if func then func(self, ...) end
        end)
    end
    -- Attributes
    if mixin.attributes then
        parent:HookScript("OnAttributeChanged", function(self, key, value)
            local func = mixin.attributes[key]
            if func then func(self, value) end
        end)
    end
    -- Methods
    if mixin.methods then
        for name, method in pairs(mixin.methods) do
            parent[name] = method
        end
    end
end
