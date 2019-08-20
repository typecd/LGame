CONFIG = {}
-- 【BASE_IMAGE不要修改，自动适配开发框架和实际平台】
-- 【iphonex代码请直接使用if BA.IS_IPHONEX then的形式】
-- 【BA.IS_IPHONEX的值可以在hello.lua里修改】

-- 【CONFIG.REVIEW_PATH是小游戏的资源路径】
-- 【请小游戏开发人员按下面的方式组合资源路径：CONFIG.REVIEW_PATH .. a.png】
CONFIG.REVIEW_PATH   = BASE_IMAGE .. "review/"

CONFIG.IMG_PATH = CONFIG.REVIEW_PATH .. "chengyu/"
-- 【从这里可以自定义全局变量，比如CONFIG.A = "xxxx"】

local c = cc
local Node = c.Node

function Node:setx(x)
    if type(x) == "number" then
        self:setPositionX(x)
    end
end

function Node:getx()
    return self:getPositionX()
end

function Node:sety(y)
    if type(y) == "number" then
        self:setPositionY(y)
    end
end

function Node:gety()
    return self:getPositionY()
end

function Node:getSize()
    return self:getContentSize()
end

CONFIG.shuffle = function(t)
    math.randomseed(tostring(os.time()):reverse():sub(1,6));
    if not t then return end
    local cnt = #t
    for i=1,cnt do
        local j = math.random(i,cnt)
        t[i],t[j] = t[j],t[i]
    end
end


CONFIG.round = function(num) 
    if num >= 0 then return math.floor(num + .5) 
    else return math.ceil(num - .5) end
end


CONFIG.passGates = {};
CONFIG.unlockedGates = {};

CONFIG.gate = 1;  
CONFIG.saveName = "passGate";
CONFIG.totalScore = 0;
CONFIG.isNewRecord = false;
CONFIG.canPlayEffect = true;  -- 本地保存的数值为 代表开 非1代表关
CONFIG.canPlayMusic = true;   
CONFIG.unlockName = "unlocked_gates";
CONFIG.diamondKey = "diamond_key"

CONFIG.totalGate = 12 --- 总关数
CONFIG.currGate = 0 --- 当前关卡

-- 成语狂人
CONFIG.meanKey = "k_mean"
CONFIG.meanTags =  {} -- 购买成语解释的关卡 开局要加载数据
CONFIG.saveMeanTag = function() 
    local str = json.encode(CONFIG.meanTags);
    CCUserDefault:sharedUserDefault():setStringForKey(CONFIG.meanKey,str)
end
-- 成语狂人

CONFIG.passGate = function(gate,score)
    local has = false;
    local newRecord = false;
    for k, item in ipairs(CONFIG.passGates) do 
        if item.gate == gate then
            has = true;
            if item.score < score then
                item.score = score;
                newRecord = true;
            end
            break;
        end
    end
    if not has then
        table.insert(CONFIG.passGates,{
            gate = gate,
            score = score
        });
        if score > 0 then
            newRecord = true;
        else
            CONFIG.saveConfig();
        end
    end
    if newRecord then
        CONFIG.isNewRecord = newRecord;
        CONFIG.genTotalScore();
        CONFIG.saveConfig();
    end

    return newRecord;
end

CONFIG.genTotalScore = function()

    local score = 0;
    for k, item in ipairs(CONFIG.passGates) do 
        score = score + item.score;
    end
    CONFIG.totalScore = score;
    return score;
end


CONFIG.getPassGate = function(gate)
    for k, item in ipairs(CONFIG.passGates) do 
        if item.gate == gate then
            return item;
        end
    end
    return nil;
end


CONFIG.getMaxPassGate = function()
    local gate = 0;
    for k, item in ipairs(CONFIG.passGates) do 
        if item.gate > gate then
            gate = item.gate;
        end
    end
    return gate;
end


CONFIG.saveConfig = function() 
    local obj = {
        passGates = CONFIG.passGates
    }
    local str = json.encode(obj);
    CCUserDefault:sharedUserDefault():setStringForKey(CONFIG.saveName,str)

end


CONFIG.saveUnlockGates = function()
    local gateStr = json.encode(CONFIG.unlockedGates);
    CCUserDefault:sharedUserDefault():setStringForKey(CONFIG.unlockName,gateStr);
end


CONFIG.loadConfig = function() 
    print("loadConfig ... ")
    local str = CCUserDefault:sharedUserDefault():getStringForKey(CONFIG.saveName);
    if str ~= "" then
        local obj = json.decode(str);
        CONFIG.passGates = obj.passGates;
        CONFIG.genTotalScore();
        local gate = CONFIG.getMaxPassGate();
        if gate < CONFIG.totalGate then
            gate = gate + 1;
        end
        CONFIG.gate = gate;
    end

    local str_mean = CCUserDefault:sharedUserDefault():getStringForKey(CONFIG.meanKey)
    if str_mean ~= "" then
        CONFIG.meanTags = json.decode(str_mean)
    end

    CONFIG.diamond = CCUserDefault:sharedUserDefault():getIntegerForKey(CONFIG.diamondKey);

    -- 音效开关 
    local playEffect = CCUserDefault:sharedUserDefault():getIntegerForKey("sound_status")
    if playEffect == 0 then
        CONFIG.canPlayEffect = true
    else 
        CONFIG.canPlayEffect = playEffect == 1 
    end

    local playMusic = CCUserDefault:sharedUserDefault():getIntegerForKey("music_status") 
    if playMusic == 0 then
        CONFIG.canPlayMusic = true
    else
        CONFIG.canPlayMusic = playMusic == 1
    end
    

    print("effect and music ",CONFIG.canPlayEffect, CONFIG.canPlayMusic)

    -- 解锁关卡
    local gStr = CCUserDefault:sharedUserDefault():getStringForKey(CONFIG.unlockName)
    print(gStr)
    if gStr ~= "" then
        local gates = json.decode(gStr);
        CONFIG.unlockedGates = gates;
    end


end

CONFIG.saveEffect = function(value)
    if type(value) ~= "number" then
        print("CONF.saveEffect: value must be number")
        return 
    end
    CCUserDefault:sharedUserDefault():setIntegerForKey("sound_status", value);
end

CONFIG.saveMusic = function(value)
    if type(value) ~= "number" then
        print("CONF.saveMusic: value must be number")
        return 
    end
    CCUserDefault:sharedUserDefault():setIntegerForKey("music_status", value);
end


CONFIG.playEffect = function(name)
    if CONFIG.canPlayEffect then
        SoundUtil.playEffect(CONFIG.IMG_PATH .. "chengyu", name, false)
    end
end

CONFIG.playMusic = function()
    if CONFIG.canPlayMusic then
        SoundUtil.playMusic(CONFIG.IMG_PATH .. "chengyu", "mainTheme",true);
    else
        audio.stopMusic();
    end
end

CONFIG.createBMFont = function(str,fntFile, width)
    width = width == nil and -1 or width        
    local font = CCLabelBMFont:create(str,fntFile, width)
    return font
end



CONFIG.getExtraInfo = function(key) 
    if key == nil then return end
    key = "k_" .. key
    return CCUserDefault:sharedUserDefault():getIntegerForKey(key)
end

CONFIG.saveExtraInfo = function(key, value)
-- TODO
    if key == nil then return end
    local curr = CONFIG.getExtraInfo(key) + value
    key = "k_" .. key
    CCUserDefault:sharedUserDefault():setIntegerForKey(key, curr)
end


