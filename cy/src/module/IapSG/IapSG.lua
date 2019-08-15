-- 如果该插件需要依赖其他插件请按该格式写："--@plugin=UserInfo"
-- 从这里开始填写需要依赖的插件 --



-- 插件的配置文件 在该配置文件填写配置数据和常量
-- 其他文件通过require的方式使用该配置文件
local IapSGConfig   = require("module/IapSG/sub/IapSGConfig")
-- [DEFAULT_CONFIG：默认配置数据]
-- [DEFAULT_CONFIG：用户可以通过查看该配置来查找自己可以传入的值]
-- [DEFAULT_CONFIG：该配置会被用户传入的数据覆盖，从而达到定制的目的]
IapSGConfig.DEFAULT_CONFIG = {
    -- 商店界面的配置
    STORE = {
        -- 背景层的颜色，调节透明度
        LAYER_COLOR  = ccc4(0,0,0,100), 
        -- 背景图片,可以自定义或者覆盖原图
        BG           = "bg_shop.png",
        --关闭按钮
        CLOSE_BUTTON = {
            -- 关闭按钮的图片
            IMAGE = "btn_close.png",
            -- 按钮位置有三种
            -- "CENTER" 居中
            -- "RIGHT"  右上角
            -- ccp(xxx,xxx) 自定义
            POS   = "RIGHT",
            -- 点击非背景图区域是否关闭界面
            CLOSE_BY_TOUCH = false        
        },
        -- tableview的布局
        TABLE           = {
            -- tableview的大小
            TABLE_SIZE   = cc.size(900,310),
            -- cell 高度
            CELL_HEIGHT  = 303,
            -- 一行的列数
            COL          = 4,    
            -- 显示的单元数据
            CELL_DATA    = {
                {
                    -- 充值的编号
                    ITEM_NO  = 30,
                    -- 充值购买的物品数量
                    COUNT    = 60,
                    -- 按钮图标
                    IMAGE    = "btn_icon_01.png",
                },
                {
                    -- 充值的编号
                    ITEM_NO  = 60,
                    -- 充值购买的物品数量
                    COUNT    = 120,
                    -- 按钮图标
                    IMAGE    = "btn_icon_02.png",
                },
                {
                    -- 充值的编号
                    ITEM_NO  = 90,
                    -- 充值购买的物品数量
                    COUNT    = 200,
                    -- 按钮图标
                    IMAGE    = "btn_icon_03.png",
                },
                {
                    -- 充值的编号
                    ITEM_NO  = 120,
                    -- 充值购买的物品数量
                    COUNT    = 300,
                    -- 按钮图标
                    IMAGE    = "btn_icon_04.png",
                },                                                         
            }
        },
       
    },
    -- 购买失败配置
    FAIL_UI = {
        --背景颜色
        LAYER_COLOR  = ccc4(0,0,0,0), 
        --背景图片
        BG           = "bg_fail.png",
        --关闭按钮
        CLOSE_BUTTON = {
            IMAGE = "btn_fail_confirm.png",
            -- 按钮位置有三种
            -- "CENTER" 居中
            -- "RIGHT"  右上角
            -- ccp(xxx,xxx) 自定义
            POS   = "CENTER",
            -- 点击非背景图区域是否关闭界面
            CLOSE_BY_TOUCH = true        
        }
    },
    -- 购买成功配置
    SUCCESS_UI = {
        --字符串
        STR_HINT     = "恭喜您獲得鑰匙%d個",
        --字符位置
        STR_POS      = ccp(40,200),        
        --背景颜色
        LAYER_COLOR  = ccc4(0,0,0,0), 
        --背景图片
        BG           = "bg_success.png",
        --关闭按钮
        CLOSE_BUTTON = {
            IMAGE = "btn_success_confirm.png",
            -- 按钮位置有三种
            -- "CENTER" 居中
            -- "RIGHT"  右上角
            -- ccp(xxx,xxx) 自定义
            POS   = "CENTER",
            -- 点击非背景图区域是否关闭界面
            CLOSE_BY_TOUCH = true         
        }
    }
}
-- 自动引用平台帮助函数用于合并table
local HelperTools      = require("baseEx/HelperTools")

-- 从这里填写需要额外require的文件 --
local IapSGStorePop    = require("module/IapSG/sub/IapSGStorePop")


-- 插件模块的接口模版写法
local IapSG = class("IapSG")

-- required
-- 用户调用该函数注册
-- config [用户传入的自定义IapSGConfig.DEFAULT_CONFIG里面的值]
function IapSG.register( config )
    HelperTools.assingTableValue(IapSGConfig.DEFAULT_CONFIG,config)
    return IapSG.new()
end

-- required
-- 用户调用该函数显示插件主界面
function IapSG:showUI( ... )
    IapSGStorePop.show()
end

-- optional
-- 插件开发者可以在这里任意扩展插件对外提供的接口

return IapSG
