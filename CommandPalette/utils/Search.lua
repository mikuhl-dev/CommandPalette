---@class CommandPaletteAddon
local addon = select(2, ...);

do -- Search
    local Search = {};

    ---@param ... string
    function Search.CreateSearch(...)
        local self = {};

        local _words = {};

        for _, keyword in ipairs({ ... }) do
            for word in gmatch(strlower(keyword), "%S+") do
                _words[word] = true;
            end;
        end;

        function self.Matches(string)
            string = strlower(string);
            for word in pairs(_words) do
                if not strfind(string, word, nil, true) then
                    return false;
                end;
            end;
            return true;
        end;

        return self;
    end;

    addon.Search = Search;
end;
