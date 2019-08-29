local pb = require "pb"

local register = {}

function register.register(path)
    local file, msg = io.open(path, "rb")
    if file ~= nil then
        local bytes = file:read("*a")
        pb.load(bytes)
        file:close()
    else
        ngx.log(ngx.ERR, "读取文件失败: ", msg)
        return
    end
end

return register