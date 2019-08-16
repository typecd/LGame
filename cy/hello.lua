require('extern')
require('math')

-- 先處理lua和資源的搜尋路徑
-- 由於模塊和小遊戲的開發會在相對路徑下面
-- 直接將搜尋路徑都寫好可以確保檔案在搜尋的時候不會出現錯誤
local function addSearchPath(searchPath)
    return string.format("%s;%s?.lua;", package.path, searchPath);
end
local luaSearchPath = {
    "src/",-- 基礎類別
};
local resourceSearchPath = {
    "res/",
};
for _, path in pairs(luaSearchPath) do
    package.path = addSearchPath(path);
end
for _, path in pairs(resourceSearchPath) do
    CCFileUtils:sharedFileUtils():addSearchPath(path);
end

CONFIG_SCREEN_WIDTH_ORI  = 1136
CONFIG_SCREEN_HEIGHT_ORI = 640

require('base/Require')

-- 适配IPHONE—X
BA = {}
BA.IS_IPHONEX = false

-- 适配平台的代码
local function dummy( ... )
    -- print("I am a dummy function!Ignore Me")
end
setShaderGray = dummy
addBarToTable = dummy

-- settings for bba.log(...)
DEBUG_LOG = true
DUMP_TRACE = true
-- 

COLOR = {}
COLOR.WHITE = display.COLOR_WHITE

BASE_IMAGE     = "base/images/"
BASE_NUMBER    = ""
BASE_SOUND     = ""

PayToolsLua = {}
function PayToolsLua:iosPay(itemNo,cb)
    local result = true

    if math.random() > 0.5 then
        result = false 
    end

    scheduler.performWithDelayGlobal(function( ... )
            if cb then
                cb(result)
            end
    end,0.5)

end

function left(x)
    return display.width - CONFIG_SCREEN_WIDTH + (x or 0);
end

function right(x)
    return CONFIG_SCREEN_WIDTH - (x or 0);
end

function top(y)
    return CONFIG_SCREEN_HEIGHT - (y or 0);
end

function centerX(x)
    return CONFIG_SCREEN_WIDTH/2 + (x or 0);
end

function centerY(y)
    return CONFIG_SCREEN_HEIGHT/2 + (y or 0);
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    -- run
    local sceneGame = CCScene:create()
    local reviewLayer = require("src/ReviewLayer").create()
    sceneGame:addChild(reviewLayer);
    CCDirector:sharedDirector():runWithScene(sceneGame)
end

xpcall(main, __G__TRACKBACK__)
