local serpent = require "serpent"


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
local pb = require "pb"
local protoc = require "protoc"


local file, msg = io.open("../protos/test.proto", "r")
if file ~= nil then
    local str = file:read("*a")
    file:close()
    ngx.say(str)
else
   ngx.say("err, " .. msg)
end



-- encode lua table data into binary format in lua string and return-- local bytes = assert(pb.encode("Person", data))-- ngx.say(pb.tohex(bytes))-- -- and decode the binary data back into lua table-- local data2 = assert(pb.decode("Person", bytes))-- ngx.say(serpent.block(data2))