---@class CommandPaletteAddon
local addon = select(2, ...);

do -- Async
    local Async = {};

    do -- Threads
        ---@type table<thread, AsyncTask>
        local _threads = {};

        ---@type cbObject|nil
        local _ticker = nil;

        function Async.GetTask()
            return _threads[coroutine.running()];
        end;

        local function _EnsureTicking()
            _ticker = _ticker or C_Timer.NewTicker(0, function(ticker)
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

        ---@param thread thread
        ---@param task AsyncTask|nil
        function Async.SetTask(thread, task)
            _threads[thread] = task;
            if task then
                _EnsureTicking();
            end;
        end;
    end;

    ---@param task function
    function Async.CreateTask(task)
        ---@class AsyncTask
        local self = {};

        local _thread = coroutine.create(task);

        do -- Cancel
            local _cancelled = false;

            function self.IsCancelled()
                return _cancelled;
            end;

            function self.Cancel()
                Async.SetTask(_thread, nil);
            end;
        end;

        do -- Pause
            local _paused = false;

            function self.IsPaused()
                return _paused;
            end;

            ---@param paused boolean
            function self.SetPaused(paused)
                if self.IsCancelled() then
                    return error(format("Cannot %s a cancelled AsyncTask", paused and "paused" or "unpause"));
                end;

                if paused then
                    Async.SetTask(_thread, nil);
                else
                    Async.SetTask(_thread, self);
                end;

                _paused = paused;
            end;
        end;

        Async.SetTask(_thread, self);

        return self;
    end;

    ---@param itemID number
    function Async.WaitForItemData(itemID)
        local task = Async.GetTask();
        if task == nil then
            return error("Can only be used inside an AsyncTask.");
        end;
        task.SetPaused(true);
        EventUtil.RegisterOnceFrameEventAndCallback("ITEM_DATA_LOAD_RESULT", function()
            task.SetPaused(false);
        end, itemID);
        C_Item.RequestLoadItemDataByID(itemID);
        coroutine.yield();
    end;

    addon.Async = Async;
end;
