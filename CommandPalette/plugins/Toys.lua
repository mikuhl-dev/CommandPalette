local _, addon = ...;

local L = addon.L;

EventRegistry:RegisterCallback("CommandPalette.UpdateActions", function()
    -- Why does GetToyFromIndex use the filtered index? 😭
    C_ToyBox.SetFilterString("");
    C_ToyBoxInfo.SetDefaultFilters();
    local numToys = C_ToyBox.GetNumToys();
    for i = 1, numToys do
        local itemId = C_ToyBox.GetToyFromIndex(i);
        if PlayerHasToy(itemId) and C_ToyBox.IsToyUsable(itemId) then
            local toyInfo = { C_ToyBox.GetToyInfo(itemId) };
            local name = toyInfo[2];
            local icon = toyInfo[3];
            if name ~= nil then
                local title = string.format(L["Use Toy: %s"], name);
                if CommandPalette:MatchesSearch(title) then
                    CommandPalette:AddAction({
                        title = title,
                        icon = icon,
                        quality = C_Item.GetItemQualityByID(itemId),
                        cooldown = GenerateClosure(GetItemCooldown, itemId),
                        action = {
                            type = "toy",
                            toy = itemId,
                        }
                    });
                end;
            end;
        end;
    end;
end);
