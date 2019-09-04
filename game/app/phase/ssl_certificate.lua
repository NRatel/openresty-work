--syntax: ssl_certificate_by_lua_file <path-to-lua-script-file>
--context: server
--phase: right-before-SSL-handshake

--当Nginx准备启动下游 SSL (https) 连接的 SSL握手时，运行这段用户的Lua代码。
--它对于根据每个请求设置SSL证书链和相应的私钥特别有用。
--从远程(例如，使用cosocket API)以非阻塞方式加载此类握手配置也很有用。
--也可以在纯Lua中对每个请求进行OCSP装订处理。
--另一个典型的用例是在此上下文中进行SSL握手流量控制。例如，使用 lua-resty-limit-traffic 库。
--对于来自客户端的SSL握手请求，还可以做一些有趣的事情，比如拒绝 使用了SSLv3或低于选择的协议的旧SSL客户端。

--lua-rest-core 库 提供的 ngx.ssl 和 ngx.ocsp Lua模块在此上下文中特别有用。
--可以使用这两个Lua模块提供的Lua API来操作SSL证书链和当前已被启动的SSL连接的私钥。
--这个Lua处理程序只在Nginx必须启动一个完整的SSL握手时运行。
--用户Lua代码中的未捕获异常会立即中止当前SSL会话，所以，使用 ngx.exit 进行错误代码退出调用，类似于 ngx.ERROR。
--此Lua代码执行上下文支持挂起，所以，在此上下文中启用了可能挂起的 Lua API (如： cosockets, sleeping, "light threads")
--但是，请注意，您仍然需要配置ssl_certificate和ssl_certificate_key指令，即使您根本不使用这个静态证书和私钥。这是因为NGINX核心需要它们的外观，否则你在启动NGINX时会看到以下错误: nginx: [emerg] no ssl configured for the server

--当给定一个相对路径 如 foo/bar.lua 时，它们将被转换为绝对路径(拼上启动Nginx服务器时由-p PATH 传入的前缀路径)。