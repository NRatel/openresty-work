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
local prefix = ngx.config.prefix()  --"/home/nratel/openresty-work/game/"

local function readFile(path)
    local file, msg = io.open(prefix .. path, "r")
    if file ~= nil then
        local str = file:read("*a")
        file:close()
        return str, nil
    else
        return nil, msg
    end
end

local files = {
    -- "app/protos/entity/account.proto",
    "app/protos/msg/test.proto",
    "app/protos/msg/login.proto"
}

local p = protoc.new()

for i, path in ipairs(files) do
    local str, msg = readFile(path)
    if (not str) then
        ngx.log(ngx.ERR, "读取文件失败: ", msg)
        return
    end

    -- set some hooks
    p.unknown_module = function(self, module_name)
        ngx.log(ngx.ERR, "未知的模块: ", module_name)
        return
    end
    p.unknown_type = function(self, type_name)
        ngx.log(ngx.ERR, "未知的类型: ", type_name)
        return
    end
    -- ... and options
    p.include_imports = true
    p:load(str);
end

local data = {
    tdata = {
        username = "NRatel",
        password = "000000"
    }
}

local bytes = assert(pb.encode("msg.Login_C", data))
ngx.say(pb.tohex(bytes))
ngx.say("---------------------")
local data2 = assert(pb.decode("msg.Login_C", bytes))
ngx.say(serpent.block(data2))
