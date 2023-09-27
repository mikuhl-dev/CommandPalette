---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Specializations"], function(self)
    local numSpecializations = GetNumSpecializations();
    for specializationIndex = 1, numSpecializations do
        local specializationInfo = { GetSpecializationInfo(specializationIndex) };
        local name = specializationInfo[2];
        local description = specializationInfo[3];
        local icon = specializationInfo[4];
        self.CreateAction({
            name = format(L["Activate Specialization: %s"], name),
            icon = icon,
            tooltip = function()
                GameTooltip_SetTitle(GameTooltip, name);
                GameTooltip_AddNormalLine(GameTooltip, description);
            end,
            action = {
                type = "specialization",
                _specialization = GenerateClosure(SetSpecialization, specializationIndex)
            }
        });
    end;
end);
