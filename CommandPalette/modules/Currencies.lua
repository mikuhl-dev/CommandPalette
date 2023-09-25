---@class CommandPaletteAddon
local addon = select(2, ...);

local L = addon.L;

local function EnumerateCurrencies()
    local index = 0;
    local headerIndex = 1;
    local headerExpanded = C_CurrencyInfo.GetCurrencyListInfo(headerIndex).isHeaderExpanded;
    local numCurrencies = 0;
    return function()
        while true do
            index = index + 1;
            if index > C_CurrencyInfo.GetCurrencyListSize() then
                -- Reset remaining headers.
                C_CurrencyInfo.ExpandCurrencyList(headerIndex, headerExpanded);
                return nil;
            end;
            local currencyInfo = C_CurrencyInfo.GetCurrencyListInfo(index);
            if currencyInfo.isHeader then
                -- Reset previous header.
                C_CurrencyInfo.ExpandCurrencyList(headerIndex, headerExpanded);
                if not headerExpanded then
                    index = index - numCurrencies;
                end;
                -- Expand current header.
                headerIndex = index;
                headerExpanded = currencyInfo.isHeaderExpanded;
                numCurrencies = 0;
                C_CurrencyInfo.ExpandCurrencyList(index, true);
            else
                numCurrencies = numCurrencies + 1;
                return index, currencyInfo;
            end;
        end;
    end;
end;

CommandPalette.RegisterModule(L["Currencies"], function(self)
    for index, currencyInfo in EnumerateCurrencies() do
        local name = currencyInfo.name;
        local currencyLink = C_CurrencyInfo.GetCurrencyListLink(index);
        local currencyID = C_CurrencyInfo.GetCurrencyIDFromLink(currencyLink);
        coroutine.yield({
            name = string.format(L["View Currency: %s"], name),
            icon = currencyInfo.iconFileID,
            tooltip = GenerateClosure(GameTooltip.SetCurrencyByID, GameTooltip, currencyID),
            pickup = GenerateClosure(C_CurrencyInfo.PickupCurrency, currencyID),
            action = {
                type = "currency",
                _currency = function()
                    for index, currencyInfo in EnumerateCurrencies() do
                        if currencyInfo.name == name then
                            LoadAddOn("Blizzard_TokenUI");
                            HideUIPanel(CharacterFrame);
                            ToggleCharacter("TokenFrame", true);
                            local scrollBox = TokenFrame.ScrollBox;
                            local elementData = scrollBox:FindElementData(index);
                            if elementData == nil then return; end;
                            scrollBox:ScrollToElementData(elementData);
                            local button = scrollBox:FindFrame(elementData);
                            if button == nil then return; end;
                            button:Click();
                            break;
                        end;
                    end;
                end,
            }
        });
    end;

    self.RegisterEvent("CURRENCY_DISPLAY_UPDATE");
end);
