--syntax: body_filter_by_lua_file <path-to-lua-script-file>
--context: http, server, location, location if
--phase: output-body-filter

--以此文件中的Lua代码定义输出头过滤器
--输入数据块通过 ngx.arg[1](Lua字符串值)传递，标示响应体数据流结束的 “eof”标志 通过 ngx.arg[2](Lua布尔值) 传递。
--在后台，“eof”标志 只是Nginx链接缓冲区的 last_buf(用于主请求) 或 last_in_chain(用于子请求) 标志。(在v0.7.14发布之前，“eof”标志在子请求中根本不起作用。)
--输出数据流可以通过 return ngx.ERROR 立即中止。
--这将截断响应主体，通常会导致不完整且无效的响应。
--通过使用Lua字符串或Lua字符串表覆盖 ngx.arg[1], Lua代码可以将其自己修改后的输入数据块传递给下游的Nginx输出体过滤器。
--例：要转换响应体中的所有小写字母，ngx.arg[1] = string.upper(ngx.arg[1])
--当将nil或空Lua字符串值设置给 ngx.arg[1] 时，根本不会将数据块传递给下游的Nginx输出过滤器。
--同样，新的“eof”标志也可以通过将布尔值设置给ngx.arg[2]来指定。
--例：匹配到hello作为结束标志，if string.match(ngx.arg[1], "hello") then ngx.arg[2] = true return end
--    当主体过滤器看到一个包含单词“hello”的块时，它将立即将“eof”标志设置为true，从而导致截断但仍然有效的响应。

--当Lua代码可能更改响应体的长度时，需要始终清除头过滤器中的Content-Length响应头(如果有的话)，以执行流输出。 header_filter_by_lua_block { ngx.header.content_length = nil }

--注意，由于Nginx output filter当前实现的限制，以下API函数目前在此上下文中被禁用:
--Output API functions (e.g., ngx.say and ngx.send_headers)
--Control API functions (e.g., ngx.exit and ngx.exec)
--Subrequest API functions (e.g., ngx.location.capture and ngx.location.capture_multi)
--Cosocket API functions (e.g., ngx.socket.tcp and ngx.req.socket).

--对于单个请求，Nginx输出过滤器可能被调用多次，因为响应体可能以块的形式交付。
--因此，此指令中指定的Lua代码在单个HTTP请求的生命周期中也可能运行多次。

--当给定一个相对路径 如 foo/bar.lua 时，它们将被转换为绝对路径(拼上启动Nginx服务器时由-p PATH 传入的前缀路径)。

-------------------------------------------------------------------------------------------

--完成应答加密编码
