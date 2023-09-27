---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Pet Actions"], function(self)
    for i = 1, NUM_PET_ACTION_SLOTS, 1 do
        local petActionInfo = { GetPetActionInfo(i) };
        local name = petActionInfo[1];
        local texture = petActionInfo[2];
        if name ~= nil then
            self.CreateAction({
                name = format(L["Use Pet Action: %s"], _G[name] or name),
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

    self.RegisterUnitEvent("UNIT_PET", "player");
end);
