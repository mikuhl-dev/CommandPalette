local _, addon = ...;

local L = addon.L;

local actions = nil;

local frame = CreateFrame("Frame");

frame:SetScript("OnEvent", function()
    actions = nil;
end);

CommandPalette.RegisterModule(L["Pet Actions"], {
    OnEnable = function()
        frame:RegisterUnitEvent("UNIT_PET", "player");
        actions = nil;
    end,

    OnDisable = function()
        frame:UnregisterAllEvents();
        actions = nil;
    end,

    GetActions = function()
        if actions ~= nil then return actions; end;

        actions = {};

        for i = 1, NUM_PET_ACTION_SLOTS, 1 do
            local petActionInfo = { GetPetActionInfo(i) };
            local name = petActionInfo[1];
            local texture = petActionInfo[2];
            if name ~= nil then
                table.insert(actions, {
                    name = string.format(L["Use Pet Action: %s"], _G[name] or name),
                    icon = _G[texture] or texture,
                    tooltip = GenerateClosure(GameTooltip.SetPetAction, GameTooltip, i),
                    pickup = GenerateClosure(PickupPetAction, i),
                    action = {
                        type = "pet",
                        action = i,
                    }
                });
            end;
        end;

        return actions;
    end,
});
