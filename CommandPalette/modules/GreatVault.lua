---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

CommandPalette.RegisterModule(L["Great Vault"], function(self)
    self.CreateAction({
        name = L["View: Great Vault"],
        icon = function(texture)
            texture:SetAtlas("pvpqueue-chest-dragonflight-greatvault-collect");
        end,
        action = {
            type = "greatvault",
            _greatvault = function()
                WeeklyRewards_ShowUI();
            end
        }
    });
end);
