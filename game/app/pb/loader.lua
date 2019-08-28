local loader = {}

--未调通
function loader:loadByProtos(files)
    local function readFile(path)
        local file, msg = io.open(path, "r")
        if file ~= nil then
            local str = file:read("*a")
            file:close()
            return str, nil
        else
            return nil, msg
        end
    end

    local p = protoc.new()
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

    --指定 import查找路径
    --p.addpath()

    for i, path in ipairs(files) do
        local str, msg = readFile(path)
        if (not str) then
            ngx.log(ngx.ERR, "读取文件失败: ", msg)
            return
        end

        p:load(str)
    end
end

--已通
function loader:loadByBytes(file)
    local file, msg = io.open(file, "rb")
    if file ~= nil then
        local bytes = file:read("*a")
        pb.load(bytes)
        file:close()
    else
        ngx.log(ngx.ERR, "读取文件失败: ", msg)
        return
    end
end

return loader