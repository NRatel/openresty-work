--syntax: log_by_lua_file <path-to-lua-script-file>
--context: http, server, location, location if
--phase: log

--在日志请求处理阶段运行此文件中的Lua代码。这并不替换当前的访问日志，而是在此之前运行。

--当给定一个相对路径 如 foo/bar.lua 时，它们将被转换为绝对路径(拼上启动Nginx服务器时由-p PATH 传入的前缀路径)。