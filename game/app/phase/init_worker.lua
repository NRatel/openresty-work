--syntax: init_worker_by_lua_file <lua-file-path>
--context: http
--phase: starting-worker

--若主进程被启用，这个钩子在每个Nginx工作进程启动时运行。
--若主进程被禁用，这个钩子将在 init_by_lua 之后运行。

--这个钩子通常被用于创建 单工作重复发生的计时器(per-worker reoccurring timers) (通过 ngx.timer.at)，
--然后在其中做 后端健康检查 或 其他定时例行的工作。

--当给定一个相对路径 如 foo/bar.lua 时，它们将被转换为绝对路径(拼上启动Nginx服务器时由-p PATH 传入的前缀路径)。