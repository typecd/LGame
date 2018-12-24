-- 如果该插件需要依赖其他插件请按<>中的格式写：<--"@plugin=UserInfo">
-- 从这里开始填写需要依赖的插件 --
-- 插件的配置文件 在该配置文件填写配置数据和常量
-- 其他文件通过require的方式使用该配置文件
local UserInfoConfig = require("module/UserInfo/sub/UserInfoConfig")
-- [DEFAULT_CONFIG：默认配置数据]
-- [DEFAULT_CONFIG：用户可以通过查看该配置来查找自己可以传入的值]
-- [DEFAULT_CONFIG：该配置会被用户传入的数据覆盖，从而达到定制的目的]
UserInfoConfig.DEFAULT_CONFIG = {
    -- 基本数据
    HEAD = {

    }
    ,
    NAME      = "test",                -- 用户当前名称
    ICON      = "head1.png",           -- 用户当前头像
    IFRAME    = "headFrame1.png",      -- 用户当前头像框
    TITLE     = "rich_1.png",          -- 用户当前称号
    CURRENCY  = 0,                     -- 用户货币 金币 积分
    LEVEL     = 1,                     -- 用户当前等级
    EXP       = 0,                     -- 用户当前经验
    PP        = 10,                    -- 用户当前体力

    -- 扩展数据
    ALREADY_ACHIEVEMENT_NUM = 0,       -- 用户成就获得个数
    EXCHANGE = 0,     
}
-- 自动引用平台帮助函数用于合并table
local HelperTools    = require("baseEx/HelperTools")

-- 从这里填写需要额外require的文件 --
-- 插件模块的接口模版写法
local UserInfo = class("UserInfo")

-- required
-- 用户调用该函数注册
-- config [用户传入的自定义UserInfoConfig.DEFAULT_CONFIG里面的值]
function UserInfo.register(config)
    HelperTools.assingTableValue(UserInfoConfig.DEFAULT_CONFIG, config)
    local obj = UserInfo.new()
    -- 操作权限的限制
    UserInfo.limitOperate()
    return obj
end

-- 构造函数
function UserInfo:ctor( ... )
    -- 读入本地存储的数据
    local readjson = CCUserDefault:sharedUserDefault():getStringForKey("USERDATA")
    if readjson and readjson ~= "" then
        -- 解析数据
        readjson = json.decode(readjson)
        -- 更新表
        for k, v in pairs(readjson) do
            UserInfoConfig.DEFAULT_CONFIG[k] = v
        end
    end
end

-- 权限限制函数
function UserInfo.limitOperate( ... )
    -- 代码对UserInfo使用方式的限制手段【不要修改】
    -- 查找key
    UserInfo.__index = function(mytable,key)
        local findValue = UserInfoConfig.DEFAULT_CONFIG[key]
        if findValue then
            return findValue
        else
            local r = rawget(mytable,key)
            if r then
                return r
            end        
        end
        return UserInfo[key]
    end
    -- 用于限制通过UserInfo.xxx = 的方式赋值
    UserInfo.__newindex = function( mytable,key,value )
        error(string.format("[ERROR] 禁止使用的赋值方法 UserInfo.%s = 或者 UserInfo['%s'] =,请使用setUserInfoByKey"
            ,key,key))
    end
end

-- required
-- 用户调用该函数显示插件主界面
function UserInfo:showUI(...)
    print("I have no ui")
end

-- optional
-- 插件开发者可以在这里任意扩展插件对外提供的接口

-- 设置用戶數據的接口只有一种
--[[
    setUserInfoByKey({
     PP = 100,
     CURRENCY = 100
    })
]]
function UserInfo:setUserInfoByKey( data )
    for k, v in pairs(data) do
        UserInfoConfig.DEFAULT_CONFIG[k] = v
        EventManager:getInstance():dispatch("UPDATE_" .. k, v)
    end
    CCUserDefault:sharedUserDefault():setStringForKey("USERDATA", json.encode(UserInfoConfig.DEFAULT_CONFIG))
end

-- 讀取用戶數據接口有两种
-- 1.getUserInfoByKey("PP")
-- 2.UserInfo.PP
function UserInfo:getUserInfoByKey( key )
    if key then
        return UserInfoConfig.DEFAULT_CONFIG[key]
    end
end

return UserInfo
