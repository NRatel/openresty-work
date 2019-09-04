--syntax: set_by_lua_file $res <path-to-lua-script-file> [$arg1 $arg2 ...]
--context: server, server if, location, location if
--phase: rewrite

--可以将一些参数($arg1 $arg2 ...)从config传入lua，并把处理结果从Lua中返回给config($res)
--本Lua代码中可以调用 Nginx API for Lua，并可以从 ngx.arg 中取出传入的参数（ngx.arg是个列表，索引从1开始，并依次递增）

--当Nginx事件循环在代码执行过程中被阻塞时，这个指令被设计用来执行短的、快速运行的代码块。因此，应该避免耗时的代码队列。

--这个指令是通过在标准 ngx_http_rewrite_module的命令列表中注入定制命令来实现的。
--因为ngx_http_rewrite_module的命令不支持非阻塞I/O，所以，要求让出（yield）当前Lua“轻线程”的 Lua API不能在这个指令中工作。
--至少目前禁用了以下API
--Output API functions (e.g., ngx.say and ngx.send_headers)
--Control API functions (e.g., ngx.exit)
--Subrequest API functions (e.g., ngx.location.capture and ngx.location.capture_multi)
--Cosocket API functions (e.g., ngx.socket.tcp and ngx.req.socket).
--Sleeping API function ngx.sleep.

--此外，请注意，该指令一次只能向单个Nginx变量写出一个值。但是，可以使用 ngx.var.VARIABLE 来解决这个问题。

--这个指令可以与 ngx_http_rewrite_module、set-misc-nginx-module 和 array-var-nginx-module 模块的所有指令自由混合。
--所有这些指令都将按照它们在配置文件中出现的顺序运行。

--Nginx变量插值在这个指令的<path-to-lua-script-file>参数字符串中得到支持。但必须特别注意注射攻击。
--当给定一个相对路径 如 foo/bar.lua 时，它们将被转换为绝对路径(拼上启动Nginx服务器时由-p PATH 传入的前缀路径)。
--当打开Lua代码缓存时(默认情况下)，用户代码在第一个请求时加载一次并缓存，每次修改Lua源文件时都必须重新加载Nginx配置。
--可以在开发期间暂时禁用Lua代码缓存， 以避免每次都要重新加载Nginx配置。可在 nginx.conf 中关闭 lua_code_cache。

