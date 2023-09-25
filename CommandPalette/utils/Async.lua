---@class CommandPaletteAddon
local addon = select(2, ...);

do -- Async
    local Async = {};

    local _threads = {};
    local _ticker = nil;

    ---@param task function
    function Async.Execute(task)
        local _thread = coroutine.create(task);
        _threads[_thread] = true;

        if _ticker == nil then
            _ticker = C_Timer.NewTicker(0, function(ticker)
                local start = GetTimePreciseSec();
                if next(_threads) == nil then
                    ticker:Cancel();
                    _ticker = nil;
                    return;
                end;
                while true do
                    for thread in pairs(_threads) do
                        local status = coroutine.status(thread);
                        if status == "suspended" then
                            local success, message = coroutine.resume(thread);
                            if not success then
                                CallErrorHandler(message);
                            end;
                        else
                            _threads[thread] = nil;
                        end;
                    end;
                    if GetTimePreciseSec() - start > 0.01 then
                        break;
                    end;
                end;
            end);
        end;

        return {
            Cancel = function()
                _threads[_thread] = nil;
            end
        };
    end;

    addon.Async = Async;
end;
