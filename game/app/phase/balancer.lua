--syntax: balancer_by_lua_file <path-to-lua-script-file>
--context: upstream
--phase: content

--该指令将Lua代码当作upstream的均衡器运行。作用于任何由 upstream {} 配置块定义的 upstream 实体上
--生成的Lua负载均衡器可以与任何现有的 Nginx upstream模块(如 ngx_proxy 和 ngx_fastcgi) 一起工作。
--此外，Lua负载均衡器可以使用标准的 upstream 连接池机制，即，标准的 keepalive 指令。只需确保在单个 upstream {} 配置块中的 balancer_by_lua_block 指令之后使用 keepalive 指令。
--Lua负载均衡器可以完全忽略在 upstream {} 块中定义的服务器列表，并通过 lua-rest-core 库中的 ngx.balancer 模块从一个完全动态的服务器列表中选择peer(甚至根据每个请求进行更改)。
--当 Nginx upstream 机制在 proxy_next_upstream 指令等指令指定的条件下重试请求时，这个指令注册的Lua代码处理程序可能会在单个 downstream 请求中被多次调用。

--这个Lua代码执行上下文不支持挂起，因此可能挂起的 Lua API(如： cosockets, sleeping, "light threads")在这个上下文中被禁用。 
--通常可以通过在较早的阶段处理程序(如access_by_lua*)中执行此类操作，并通过 ngx.ctx表 将结果传递到该上下文中，来绕过此限制。

--当给定一个相对路径 如 foo/bar.lua 时，它们将被转换为绝对路径(拼上启动Nginx服务器时由-p PATH 传入的前缀路径)。