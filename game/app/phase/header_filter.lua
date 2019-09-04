--syntax: header_filter_by_lua_file <path-to-lua-script-file>
--context: http, server, location, location if
--phase: output-header-filter

--以此文件中的Lua代码定义输出头过滤器
--请注意，以下API函数目前在此上下文中被禁用:
--Output API functions (e.g., ngx.say and ngx.send_headers)
--Control API functions (e.g., ngx.redirect and ngx.exec)
--Subrequest API functions (e.g., ngx.location.capture and ngx.location.capture_multi)
--Cosocket API functions (e.g., ngx.socket.tcp and ngx.req.socket).

--例：ngx.header.Foo = "blah" (添加头部信息)

--当给定一个相对路径 如 foo/bar.lua 时，它们将被转换为绝对路径(拼上启动Nginx服务器时由-p PATH 传入的前缀路径)。