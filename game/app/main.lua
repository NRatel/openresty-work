local serpent = require "serpent"
local pb = require "pb"
local protoc = require "protoc"

--GET arg
local getArgs = ngx.req.get_uri_args()
for k, v in pairs(getArgs) do
    ngx.say("[GET ] key:", k, " v:", v)
end

--POST arg
ngx.req.read_body() -- 解析 body 参数之前一定要先读取 body
local postArgs = ngx.req.get_post_args()
for k, v in pairs(getArgs) do
    ngx.say("[POST ] key:", k, " v:", v)
end

--POST body
-----------------------------------------------------------------------
local prefix = "/home/nratel/openresty-work/game/app/"

ngx.say(ngx.config.prefix())

-- local function readFile(path)
--     local file, msg = io.open(prefix .. path, "r")
--     if file ~= nil then
--         local str = file:read("*a")
--         file:close()
--         return str, nil
--     else
--         return nil, msg
--     end
-- end

-- local files = {
--     "protos/entity/account.proto",
--     "protos/msg/account.proto"
-- }

-- for i, path in ipairs(files) do
--     local str, msg = readFile(path)
--     if (not str) then
--         ngx.log(ngx.ERR, "读取文件失败: ", msg)
--         return
--     end

--     local p = protoc.new()
--     -- set some hooks
--     p.unknown_module = function(self, module_name)
--         ngx.log(ngx.ERR, "未知的模块: ", module_name)
--         return 
--     end
--     p.unknown_type = function(self, type_name)
--         ngx.log(ngx.ERR, "未知的类型: ", type_name)
--         return 
--     end
--     -- ... and options
--     p.include_imports = true
--     p:load(str);
-- end

-- local data = {
--    account = "NRatel"
-- }
-- -- encode lua table data into binary format in lua string and return
-- local bytes = assert(pb.encode("Login_C", data))
-- ngx.say(pb.tohex(bytes))
-- ngx.say("---------------------")
-- -- local bytes = assert(pb.encode("Person", data))
-- -- ngx.say(pb.tohex(bytes))
-- -- and decode the binary data back into lua table
-- local data2 = assert(pb.decode("Login_C", bytes))
-- ngx.say(serpent.block(data2))
-- -- -- and decode the binary data back into lua table-- local data2 = assert(pb.decode("Person", bytes))-- ngx.say(serpent.block(data2))-- local file, msg = io.open("${prefix}/app/test.txt", "r")