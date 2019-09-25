--syntax: init_by_lua_file <path-to-lua-script-file>
--context: http
--phase: loading-config

--当 Nginx 接收到 HUP 信号并开始重新加载配置文件时，Lua VM 也将被重新创建，此时，init_by_lua 将在新的 Lua VM 上再次运行。
--如果 lua_code_cache 指令被关闭(默认为 on )， init_by_lua 处理程序将在每次请求时运行，因为在这种特殊模式下，总是为每个请求创建一个独立的 Lua VM。

--通常，你可以通过这个钩子在服务器启动时预加载 Lua模块，并利用现代操作系统的写中复制(COW)优化。
--你还可以在此阶段初始化 lua_shared_dict shm 存储（可以添加标志，使其只执行一次初始化）

--由于在此上下文中Lua代码 在 Nginx 派生其工作进程(如果有的话)之前运行，因此这里加载的数据或代码将享受许多操作系统在所有工作进程中提供的“写中复制”(COW)特性，从而节省大量内存。
--不要在这个上下文中初始化你自己的Lua全局变量，因为使用Lua全局变量会影响性能，并可能导致全局名称空间污染(有关详细信息，请参阅Lua变量作用域一节)。
--不要使用标准的Lua函数 module() 定义Lua模块，因为它会污染全局命名空间。
--推荐的方法是，使用Lua模块文件和调用require()加载自己的模块文件。
--require() 在 Lua注册表中的全局表 package.loaded 中缓存了已加载的lua模块，因此你的模块只会为整个 Lua VM 实例加载一次。

--在此上下文中，只支持一小部分用于Lua的 Nginx API。将来可能会随用户要求新增
--Logging APIs: ngx.log and print,
--Shared Dictionary API: ngx.shared.DICT.

--基本上，在此上下文中，你可以安全地使用执行阻塞I/O的Lua库，因为在服务器启动期间阻塞主进程是完全可以的。
--甚至Nginx内核在配置加载阶段也会阻塞I/O(至少在解析上游主机名时是这样)。

--你应该非常小心 在此上下文中的Lua代码中的潜在安全漏洞，因为Nginx主进程通常是在root账户下运行的。

--当给定一个相对路径 如 foo/bar.lua 时，它们将被转换为绝对路径(拼上启动Nginx服务器时由-p PATH 传入的前缀路径)。

