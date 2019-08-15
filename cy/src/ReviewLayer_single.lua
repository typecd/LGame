local CONFIG = {}
local PLUGIN_INS = {}
-- 【BASE_IMAGE不要修改，自动适配开发框架和实际平台】
-- 【iphonex代码请直接使用if BA.IS_IPHONEX then的形式】
-- 【BA.IS_IPHONEX的值可以在hello.lua里修改】
-- 【CONFIG.REVIEW_PATH是小游戏的资源路径】
-- 【请小游戏开发人员按下面的方式组合资源路径：CONFIG.REVIEW_PATH .. a.png】
CONFIG.REVIEW_PATH   = BASE_IMAGE .. "review/"
IMG_PATH = CONFIG.REVIEW_PATH .. "cryHero/"
-- 【从这里可以自定义全局变量，比如CONFIG.A = "xxxx"】
CONFIG.shuffle = function(t)
    math.randomseed(tostring(os.time()):reverse():sub(1,6));
    if not t then return end
    local cnt = #t
    for i=1,cnt do
        local j = math.random(i,cnt)
        t[i],t[j] = t[j],t[i]
    end
end
CONFIG.copyArr = function(t)
    local newTable = {}
    for k, v in pairs(t) do 
        newTable[k] = v
    end
    return newTable
end
CONFIG.round = function(num) 
    if num >= 0 then return math.floor(num + .5) 
    else return math.ceil(num - .5) end
end
-- CONFIG.layerArr = {}
-- CONFIG.addLayer = function(layer)
--     for k, v in ipairs(CONFIG.layerArr) do 
--         v:setButtonEnabled(false)
--     end
--     table.insert(CONFIG.layerArr,layer)
-- end
-- CONFIG.removeLayer = function()
--     table.remove(CONFIG.layerArr);
--     local layer = CONFIG.layerArr[#CONFIG.layerArr]
--     layer:setButtonEnabled(true);
-- end
CONFIG.R = {
    bg = IMG_PATH .. "bg.png",
    block_1_7 = "#block_1_7.png",
    block_10_1 = "#block_10_1.png",
    block_10_5 = "#block_10_5.png",
    block_11_6 = "#block_11_6.png",
    block_2_5 = "#block_2_5.png",
    block_3_7 = "#block_3_7.png",
    block_10_2 = "#block_10_2.png",
    block_2_3 = "#block_2_3.png",
    block_6_3 = "#block_6_3.png",
    block_7_4 = "#block_7_4.png",
    block_10_3 = "#block_10_3.png",
    block_2_2 = "#block_2_2.png",
    block_3_6 = "#block_3_6.png",
    block_4_7 = "#block_4_7.png",
    block_8_3 = "#block_8_3.png",
    block_9_3 = "#block_9_3.png",
    block_5_6 = "#block_5_6.png",
    block_9_4 = "#block_9_4.png",
    block_9_5 = "#block_9_5.png",
    block_11_4 = "#block_11_4.png",
    block_12_4 = "#block_12_4.png",
    block_2_6 = "#block_2_6.png",
    block_5_1 = "#block_5_1.png",
    block_7_2 = "#block_7_2.png",
    block_7_3 = "#block_7_3.png",
    block_100_2 = "#block_100_2.png",
    block_12_2 = "#block_12_2.png",
    block_12_7 = "#block_12_7.png",
    block_2_7 = "#block_2_7.png",
    block_8_6 = "#block_8_6.png",
    block_1_2 = "#block_1_2.png",
    block_1_4 = "#block_1_4.png",
    block_1_5 = "#block_1_5.png",
    block_12_3 = "#block_12_3.png",
    block_3_1 = "#block_3_1.png",
    block_4_4 = "#block_4_4.png",
    block_11_1 = "#block_11_1.png",
    block_3_5 = "#block_3_5.png",
    block_5_5 = "#block_5_5.png",
    block_7_5 = "#block_7_5.png",
    block_8_4 = "#block_8_4.png",
    block_8_5 = "#block_8_5.png",
    block_1_3 = "#block_1_3.png",
    block_4_3 = "#block_4_3.png",
    block_6_2 = "#block_6_2.png",
    block_3_4 = "#block_3_4.png",
    block_8_1 = "#block_8_1.png",
    block_9_2 = "#block_9_2.png",
    block_1_1 = "#block_1_1.png",
    block_11_2 = "#block_11_2.png",
    block_5_2 = "#block_5_2.png",
    block_5_7 = "#block_5_7.png",
    block_6_1 = "#block_6_1.png",
    block_7_1 = "#block_7_1.png",
    block_1_6 = "#block_1_6.png",
    block_2_4 = "#block_2_4.png",
    block_4_6 = "#block_4_6.png",
    block_5_3 = "#block_5_3.png",
    block_6_5 = "#block_6_5.png",
    block_8_2 = "#block_8_2.png",
    block_8_7 = "#block_8_7.png",
    block_10_4 = "#block_10_4.png",
    block_12_1 = "#block_12_1.png",
    block_3_2 = "#block_3_2.png",
    block_4_2 = "#block_4_2.png",
    block_6_4 = "#block_6_4.png",
    block_7_6 = "#block_7_6.png",
    block_100_3 = "#block_100_3.png",
    block_11_7 = "#block_11_7.png",
    block_12_5 = "#block_12_5.png",
    block_2_1 = "#block_2_1.png",
    block_5_4 = "#block_5_4.png",
    block_9_1 = "#block_9_1.png",
    block_9_6 = "#block_9_6.png",
    block_10_6 = "#block_10_6.png",
    block_11_3 = "#block_11_3.png",
    block_12_6 = "#block_12_6.png",
    block_3_3 = "#block_3_3.png",
    block_4_1 = "#block_4_1.png",
    block_4_5 = "#block_4_5.png",
    block_100_1 = "#block_100_1.png",
    block_11_5 = "#block_11_5.png",
    block_6_6 = "#block_6_6.png",
    wrap_top_left = "#wrap_top_left.png",
    button_light1 = "#button_light1.png",
    button_setting2 = "#button_setting2.png",
    button_star1 = "#button_star1.png",
    end_star3 = "#end_star3.png",
    setting_sound = "#setting_sound.png",
    star = "#star.png",
    tip_bg = "#tip_bg.png",
    wrap_bottom_left = "#wrap_bottom_left.png",
    button_gate1 = "#button_gate1.png",
    end_bg = "#end_bg.png",
    end_star2 = "#end_star2.png",
    wrap_top_left2 = "#wrap_top_left2.png",
    button_light2 = "#button_light2.png",
    setting_music = "#setting_music.png",
    wrap_bottom = "#wrap_bottom.png",
    block_bg = "#block_bg.png",
    button_restart2 = "#button_restart2.png",
    gate_lock = "#gate_lock.png",
    wrap_right = "#wrap_right.png",
    gate_pad_pass = "#gate_pad_pass.png",
    holder = "#holder.png",
    wrap_left = "#wrap_left.png",
    end_ad = "#end_ad.png",
    gate_pad_lock = "#gate_pad_lock.png",
    start_play_bg = "#start_play_bg.png",
    button_home1 = "#button_home1.png",
    wrap_top_right2 = "#wrap_top_right2.png",
    score_bg = "#score_bg.png",
    setting_select = "#setting_select.png",
    setting_select_bg = "#setting_select_bg.png",
    button_next2 = "#button_next2.png",
    end_star1 = "#end_star1.png",
    gate_left = "#gate_left.png",
    button_star2 = "#button_star2.png",
    gate_frame = "#gate_frame.png",
    wrap_bottom_right = "#wrap_bottom_right.png",
    wrap_top_right = "#wrap_top_right.png",
    button_rank2 = "#button_rank2.png",
    gate_pad_red = "#gate_pad_red.png",
    gate_right = "#gate_right.png",
    button_home2 = "#button_home2.png",
    setting_bg = "#setting_bg.png",
    star2 = "#star2.png",
    wrap_bottom_left2 = "#wrap_bottom_left2.png",
    wrap_top = "#wrap_top.png",
    button_bg = "#button_bg.png",
    button_gate2 = "#button_gate2.png",
    button_next1 = "#button_next1.png",
    start_play = "#start_play.png",
    button_close1 = "#button_close1.png",
    button_close2 = "#button_close2.png",
    button_rank1 = "#button_rank1.png",
    wrap_bottom_right2 = "#wrap_bottom_right2.png",
    button_restart1 = "#button_restart1.png",
    button_setting1 = "#button_setting1.png",
    end_stars = "#end_stars.png",
    btn_shop = "#btn_shop.png",
    gate_unlock = "#gate_unlock.png",
    key = "#key.png",
    logo = "#logo.png",
    shadow_5_6 = "#shadow_5_6.png",
    shadow_7_1 = "#shadow_7_1.png",
    shadow_9_4 = "#shadow_9_4.png",
    shadow_9_5 = "#shadow_9_5.png",
    shadow_1_1 = "#shadow_1_1.png",
    shadow_12_6 = "#shadow_12_6.png",
    shadow_5_5 = "#shadow_5_5.png",
    shadow_6_4 = "#shadow_6_4.png",
    shadow_9_1 = "#shadow_9_1.png",
    shadow_100_3 = "#shadow_100_3.png",
    shadow_11_4 = "#shadow_11_4.png",
    shadow_11_5 = "#shadow_11_5.png",
    shadow_3_6 = "#shadow_3_6.png",
    shadow_4_4 = "#shadow_4_4.png",
    shadow_5_7 = "#shadow_5_7.png",
    shadow_6_2 = "#shadow_6_2.png",
    shadow_8_2 = "#shadow_8_2.png",
    shadow_1_6 = "#shadow_1_6.png",
    shadow_1_7 = "#shadow_1_7.png",
    shadow_12_5 = "#shadow_12_5.png",
    shadow_4_6 = "#shadow_4_6.png",
    shadow_6_6 = "#shadow_6_6.png",
    shadow_8_1 = "#shadow_8_1.png",
    shadow_8_5 = "#shadow_8_5.png",
    shadow_8_6 = "#shadow_8_6.png",
    shadow_1_5 = "#shadow_1_5.png",
    shadow_12_4 = "#shadow_12_4.png",
    shadow_4_3 = "#shadow_4_3.png",
    shadow_7_2 = "#shadow_7_2.png",
    shadow_9_6 = "#shadow_9_6.png",
    shadow_100_1 = "#shadow_100_1.png",
    shadow_11_1 = "#shadow_11_1.png",
    shadow_12_2 = "#shadow_12_2.png",
    shadow_3_1 = "#shadow_3_1.png",
    shadow_4_7 = "#shadow_4_7.png",
    shadow_5_3 = "#shadow_5_3.png",
    shadow_7_4 = "#shadow_7_4.png",
    shadow_8_3 = "#shadow_8_3.png",
    shadow_10_3 = "#shadow_10_3.png",
    shadow_100_2 = "#shadow_100_2.png",
    shadow_2_4 = "#shadow_2_4.png",
    shadow_7_5 = "#shadow_7_5.png",
    shadow_9_3 = "#shadow_9_3.png",
    shadow_10_6 = "#shadow_10_6.png",
    shadow_11_3 = "#shadow_11_3.png",
    shadow_12_3 = "#shadow_12_3.png",
    shadow_3_4 = "#shadow_3_4.png",
    shadow_1_2 = "#shadow_1_2.png",
    shadow_10_2 = "#shadow_10_2.png",
    shadow_12_1 = "#shadow_12_1.png",
    shadow_6_1 = "#shadow_6_1.png",
    shadow_1_4 = "#shadow_1_4.png",
    shadow_10_4 = "#shadow_10_4.png",
    shadow_10_5 = "#shadow_10_5.png",
    shadow_12_7 = "#shadow_12_7.png",
    shadow_2_5 = "#shadow_2_5.png",
    shadow_2_7 = "#shadow_2_7.png",
    shadow_4_2 = "#shadow_4_2.png",
    shadow_1_3 = "#shadow_1_3.png",
    shadow_11_7 = "#shadow_11_7.png",
    shadow_4_5 = "#shadow_4_5.png",
    shadow_6_5 = "#shadow_6_5.png",
    shadow_8_4 = "#shadow_8_4.png",
    shadow_3_2 = "#shadow_3_2.png",
    shadow_5_4 = "#shadow_5_4.png",
    shadow_8_7 = "#shadow_8_7.png",
    shadow_10_1 = "#shadow_10_1.png",
    shadow_11_2 = "#shadow_11_2.png",
    shadow_3_5 = "#shadow_3_5.png",
    shadow_3_7 = "#shadow_3_7.png",
    shadow_4_1 = "#shadow_4_1.png",
    shadow_5_1 = "#shadow_5_1.png",
    shadow_7_6 = "#shadow_7_6.png",
    shadow_9_2 = "#shadow_9_2.png",
    shadow_2_2 = "#shadow_2_2.png",
    shadow_2_6 = "#shadow_2_6.png",
    shadow_6_3 = "#shadow_6_3.png",
    shadow_7_3 = "#shadow_7_3.png",
    shadow_11_6 = "#shadow_11_6.png",
    shadow_2_1 = "#shadow_2_1.png",
    shadow_2_3 = "#shadow_2_3.png",
    shadow_3_3 = "#shadow_3_3.png",
    shadow_5_2 = "#shadow_5_2.png",
    sounds_bg_mp3 = "bg",
    sounds_block_drop_mp3 = "block_drop",
    sounds_click_mp3 = "click",
    sounds_win_mp3 = "win",
    sounds_win2_mp3 = "win2",
    num1_fnt = IMG_PATH .. "num1.fnt",
    num2_fnt = IMG_PATH .. "num2.fnt",
}
CONFIG.passGates = {};
CONFIG.unlockedGates = {};
CONFIG.gate = 1;
CONFIG.saveName = "block";
CONFIG.cs = "block012";
CONFIG.totalScore = 0;
CONFIG.isNewRecord = false;
CONFIG.canPlayEffect = true;
CONFIG.canPlayMusic = true;
CONFIG.unlockName = "unlocked_gates";
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
    local str = CCUserDefault:sharedUserDefault():getStringForKey(CONFIG.saveName);
    if str ~= "" then
        local obj = json.decode(str);
        CONFIG.passGates = obj.passGates;
        CONFIG.genTotalScore();
        local gate = CONFIG.getMaxPassGate();
        if gate < CONFIG.gateData:getLength() then
            gate = gate + 1;
        end
        CONFIG.gate = gate;
    end
    -- 音效开关
    CONFIG.canPlayEffect = CCUserDefault:sharedUserDefault():getBoolForKey("sound_status")
    CONFIG.canPlayMusic = CCUserDefault:sharedUserDefault():getBoolForKey("music_status")
    -- 解锁关卡
    local gStr = CCUserDefault:sharedUserDefault():getStringForKey(CONFIG.unlockName)
    print(gStr)
    if gStr ~= "" then
        local gates = json.decode(gStr);
        CONFIG.unlockedGates = gates;
    else
        for i = 1,30 do 
        table.insert(CONFIG.unlockedGates,i);
        end
        CONFIG.saveUnlockGates();
    end
end
CONFIG.playEffect = function(path,name,loop)
    if CONFIG.canPlayEffect then
        SoundUtil.playEffect(path, name,loop)
    end
end
CONFIG.playMusic = function()
    if CONFIG.canPlayMusic then
        SoundUtil.playMusic(IMG_PATH .. "cry", CONFIG.R.sounds_bg_mp3,true);
        print("play 403")
    else
        audio.stopMusic();
    end
end
local EventManager = class("EventManager")
function EventManager:getInstance()
    if self._instance == nil then
        self._instance = EventManager.new();
    end
    return self._instance;
end
function EventManager:ctor()
    self.eventTable = {};
end
function EventManager:add(eventKey, func, object)
    self.eventTable[eventKey] = self.eventTable[eventKey] or {};
    if self._isNotExist(self.eventTable[eventKey], object) then
        table.insert(self.eventTable[eventKey], {
            scope = object,
            func = func
        });
    end
end
function EventManager:remove(eventKey, object)
    assert(eventKey);
    assert(object);
    local event = self.eventTable[eventKey];
    if not event then
        return;
    end
    for i = #event, 1, -1 do
        if event[i].scope == object then
            table.remove(event, i);
        end
    end
end
function EventManager:removeByFunc(func)
    assert(func);
    for _, v in pairs(self.eventTable) do
        for i = #v, 1, -1 do
            if v[i].func == func then
                table.remove(v, i);
            end
        end
    end
end
-- 清除对象的所有回调
function EventManager:removeAll(object)
    assert(object);
    for _, v in pairs(self.eventTable) do
        for i = #v, 1, -1 do
            if v[i].scope == object then
                table.remove(v, i);
            end
        end
    end
end
function EventManager:clean()
    self.eventTable = {};
end
-- 派发事件
function EventManager:dispatch(eventKey, ...)
    assert(eventKey);
    local event = self.eventTable[eventKey];
    if not event then
        return;
    end;
    for _, v in pairs(event) do
        if v.scope then
            v.func(v.scope, eventKey, ...);
        else
            v.func(eventKey, ...);
        end
    end
end
function EventManager._isNotExist(target, scope)
    for _, v in pairs(target) do
        if v.scope == scope then
            return false;
        end
    end
    return true;
end
local BlockData = class("BlockData");
function BlockData:getInstance()
    if BlockData.instance == nil then
        BlockData.instance = BlockData.new()
    end
    return BlockData.instance
end
function BlockData:ctor()
    self._datas = {};
    self._cache = {};
    self:init();
end
function BlockData:init()
    local list = {};
    table.insert(list,"1,1,1");
    table.insert(list,"111,1");
    table.insert(list,"10,11,1");
    table.insert(list,"110,011");
    table.insert(list,"01,01,11,01");
    table.insert(list,"0011,111");
    table.insert(list,"010,11,011");
    table.insert(self._datas,{type = 1,list = list});
    list = {};
    table.insert(list,"01,01,11");
    table.insert(list,"0010,1111");
    table.insert(list,"01,11,1,1");
    table.insert(list,"111,01,01");
    table.insert(list,"110,1,111");
    table.insert(list,"100,111,01");
    table.insert(list,"011,11,1");
    table.insert(self._datas,{type = 2,list = list});
    list  = {};
    table.insert(list,"111,001");
    table.insert(list,"01,11,01,01");
    table.insert(list,"1100,0111");
    table.insert(list,"100,111,1");
    table.insert(list,"010,011,11");
    table.insert(list,"001,101,111");
    table.insert(list,"100,110,011");
    table.insert(self._datas,{type = 3,list = list});
    list  = {};
    table.insert(list,"1,1,1,1,1");
    table.insert(list,"111,001,001");
    table.insert(list,"011,11");
    table.insert(list,"100,111");
    table.insert(list,"01,01,11,01,01");
    table.insert(list,"11,01,11");
    table.insert(list,"100,101,111");
    table.insert(self._datas,{type = 4,list = list});
    list  = {};
    table.insert(list,"11111");
    table.insert(list,"01,11");
    table.insert(list,"111,1,1");
    table.insert(list,"10,11,01");
    table.insert(list,"11111,001");
    table.insert(list,"111,101");
    table.insert(list,"011,001,111");
    table.insert(self._datas,{type = 5,list = list});
    list  = {};
    table.insert(list,"11,11");
    table.insert(list,"11");
    table.insert(list,"10,11");
    table.insert(list,"01,11,01");
    table.insert(list,"0111,11");
    table.insert(list,"110,011,010");
    table.insert(self._datas,{type = 6,list = list});
    list  = {};
    table.insert(list,"11,1,1");
    table.insert(list,"001,001,111");
    table.insert(list,"00100,11111");
    table.insert(list,"1111,01");
    table.insert(list,"111,001,011");
    table.insert(list,"010,111,001");
    table.insert(self._datas,{type = 7,list = list});
    list  = {};
    table.insert(list,"1111");
    table.insert(list,"11,1");
    table.insert(list,"010,111");
    table.insert(list,"01,11,1");
    table.insert(list,"101,111");
    table.insert(list,"10,1,11,01");
    table.insert(list,"111,1,11");
    table.insert(self._datas,{type = 8,list = list});
    list  = {};
    table.insert(list,"1,1,1,1");
    table.insert(list,"11,01");
    table.insert(list,"100,1,111");
    table.insert(list,"10,1,11,1,1");
    table.insert(list,"11,1,11");
    table.insert(list,"111,101,001");
    table.insert(self._datas,{type = 9,list = list});
    list  = {};
    table.insert(list,"001,111");
    table.insert(list,"001,111,001");
    table.insert(list,"1110,0011");
    table.insert(list,"111,101,1");
    table.insert(list,"011,11,01");
    table.insert(list,"110,011,001");
    table.insert(self._datas,{type = 10,list = list});
    list  = {};
    table.insert(list,"1,1");
    table.insert(list,"11,01,01");
    table.insert(list,"111,01");
    table.insert(list,"0100,1111");
    table.insert(list,"1111,001");
    table.insert(list,"10,11,01,01")
    table.insert(list,"001,111,01");
    table.insert(self._datas,{type = 11,list = list});
    list  = {};
    table.insert(list,"1");
    table.insert(list,"10,1,11");
    table.insert(list,"010,01,111");
    table.insert(list,"01,01,11,1");
    table.insert(list,"010,111,01");
    table.insert(list,"010,111,1");
    table.insert(list,"001,011,11");
    table.insert(self._datas,{type = 12,list = list});
    list  = {};
    table.insert(list,"111");
    table.insert(list,"10,11,1,1");
    table.insert(list,"10,1,11,1");
    table.insert(self._datas,{type = 100,list = list});
end
function BlockData:getBlockData(type,index)
    local name = type .."_".. index;
    for k,v in ipairs(self._cache) do 
        if v.name == name then 
            -- print("exit ",name)
            return v.map;
        end
    end
    local data = "";
    for k,v in ipairs(self._datas) do 
        if v.type == type then
            data = v.list[index];
            break;
        end
    end
    print("data -- ",data )
    if not data then
        return nil
    end
    local arr = string.split(data,","); --- {10,1,11,1}
    -- bba.printTable(arr)
    local len = string.len(arr[1]); 
    local map = {};
    for k,v in ipairs(arr) do 
        local mapRow = {};
        for j=1,len do ---111 len=3 #v=3
            if j > #v then 
                table.insert(mapRow,0);
            else
                table.insert(mapRow,tonumber(string.sub(v,j,j)))
            end
        end
        table.insert(map,mapRow);
    end
    -- bba.printTable(map)
    table.insert(self._cache,{name = name,map = map});
    return map;
end
local GateData = class("GateData")
function GateData:ctor()
    self._datas = {}
    self._cache = {}
    self:init();
end
function GateData:init()
    table.insert(self._datas,"4,3|8,3,1,1;8,2,3,1;11,1,3,3;0,0,4,2");
    table.insert(self._datas,"5,3|6,3,1,2;4,4,2,1;11,3,4,1");
    table.insert(self._datas,"4,4|9,5,1,1;12,5,1,2;10,1,3,2");
    table.insert(self._datas,"4,4|1,1,1,1;8,2,1,2;100,1,4,2;5,2,2,3;0,0,1,4;0,0,2,3;0,0,3,2;0,0,4,1");
    table.insert(self._datas,"6,4|7,1,1,1;6,4,1,3;12,5,3,1;5,2,5,2;0,0,1,3;0,0,3,3;0,0,2,2;0,0,4,4");
    table.insert(self._datas,"6,4|4,3,1,1;6,1,2,3;1,3,3,1;12,7,4,2;0,0,3,2;0,0,4,3;0,0,5,2");
    table.insert(self._datas,"6,5|100,1,1,2;6,4,2,1;12,5,2,3;11,3,5,2;0,0,2,3;0,0,4,3");
    table.insert(self._datas,"4,5|7,1,1,1;11,3,2,2;8,5,3,2;0,0,4,1;0,0,4,5;4,2,1,3");
    table.insert(self._datas,"6,3|8,3,1,1;5,3,3,1;9,2,4,2;0,0,5,2;100,1,6,1");
    table.insert(self._datas,"5,3|9,1,1,1;8,2,1,2;1,1,2,3;0,0,3,2;8,3,4,1");
    table.insert(self._datas,"10,9|8,3,8,1;6,3,7,3;9,2,7,4;6,2,9,4;6,3,8,6;3,7,7,7;1,5,4,5;12,5,1,5");
    table.insert(self._datas,"6,6|6,6,1,1;7,1,4,2;12,5,2,3;11,1,3,6;1,1,4,5");
    table.insert(self._datas,"7,6|11,2,1,1;9,1,4,2;11,3,3,3;4,4,4,3;11,2,4,5;12,1,7,6");
    table.insert(self._datas,"7,7|3,1,4,1;2,1,1,3;6,3,4,4;11,1,6,4;4,4,3,5");
    table.insert(self._datas,"9,7|100,2,1,1;4,1,5,1;4,6,1,2;4,4,2,4;9,2,1,4;11,2,2,6;1,4,4,5");
    table.insert(self._datas,"6,6|12,7,1,1;12,7,4,3;9,2,3,5;1,3,1,4;1,4,4,1;6,3,3,3");
    table.insert(self._datas,"9,5|100,3,1,1;12,1,5,1;12,1,4,2;5,4,1,2;7,1,2,4;0,0,5,4;9,1,6,4");
    table.insert(self._datas,"8,7|4,3,1,1;9,1,2,3;6,4,5,3;6,3,7,3;7,1,5,5;3,1,4,5");
    table.insert(self._datas,"5,7|11,3,2,1;8,1,1,2;5,4,3,3;5,4,2,4;1,3,1,6;12,1,2,5");
    table.insert(self._datas,"5,8|8,5,1,1;2,1,1,3;12,2,2,5;11,1,4,4;8,4,3,7;1,1,1,6;11,1,2,7");
    table.insert(self._datas,"7,8|10,1,1,2;4,4,1,5;7,1,3,4;12,2,4,5;1,4,6,3;5,4,4,1;8,4,4,7");
    table.insert(self._datas,"8,5|8,4,1,1;2,1,1,2;9,1,1,4;1,3,4,3;10,3,7,1;5,4,6,4;6,2,8,1");
    table.insert(self._datas,"8,6|100,1,1,1;3,1,1,4;8,1,2,1;1,1,2,5;3,6,3,4;3,1,4,1;9,1,5,1;100,3,5,2;3,1,7,4;100,1,8,3");
    table.insert(self._datas,"8,6|1,2,1,1;2,2,1,2;5,7,1,4;1,2,4,3;10,1,4,4;11,3,6,4;10,1,7,4;4,3,7,2;8,2,7,1");
    table.insert(self._datas,"8,6|11,2,1,1;9,1,2,1;7,2,2,3;11,2,1,5;3,2,4,5;12,2,6,5;4,4,4,2");
    table.insert(self._datas,"8,6|7,4,1,1;6,3,2,1;8,1,4,1;4,3,4,4;3,2,5,5;8,2,7,3;5,2,7,4;6,1,7,1;10,1,1,3;100,1,5,1");
    table.insert(self._datas,"8,6|5,3,1,1;8,1,2,2;3,1,1,4;3,2,3,1;11,3,4,4;9,1,5,1;1,2,7,2;7,2,6,3;9,1,5,6;6,3,4,3");
    table.insert(self._datas,"8,6|1,2,1,1;10,1,1,2;9,1,1,5;11,1,1,6;11,1,3,6;12,1,4,4;2,7,5,3;6,3,7,2;12,1,7,4");
    table.insert(self._datas,"8,6|7,4,1,1;1,3,2,1;1,2,4,2;6,1,1,5;9,2,3,5;10,1,4,3;7,1,6,1;4,4,7,2;2,1,6,5;11,1,6,5");
    table.insert(self._datas,"8,6|6,6,1,1;10,6,1,3;9,2,1,5;12,2,2,1;1,6,4,1;12,7,3,4;9,1,5,6;1,1,6,5");
    table.insert(self._datas,"5,6|1,1,1,1;2,1,1,2;8,2,1,4;5,2,1,5;8,3,3,3;9,2,3,5;6,1,4,1;8,1,5,3;11,1,1,2");
    table.insert(self._datas,"5,6|6,1,1,1;8,2,1,3;6,4,2,3;12,2,1,5;11,1,1,6;1,1,3,1;6,3,3,2;6,1,4,5;100,1,5,2");
    table.insert(self._datas,"5,6|1,2,1,1;11,3,1,4;8,2,2,3;6,4,2,1;5,2,2,5;11,1,4,1;11,4,4,2;3,1,4,4;12,1,3,4");
    table.insert(self._datas,"5,6|6,1,1,2;4,4,2,1;8,2,1,4;6,4,2,4;1,1,2,6;8,2,4,1;5,2,4,2;4,4,4,4");
    table.insert(self._datas,"5,6|12,1,1,1;12,6,1,1;6,2,1,3;9,2,1,5;9,2,2,4;8,4,3,1;8,2,3,3;4,3,4,3;1,1,3,6");
    table.insert(self._datas,"5,6|6,1,1,1;6,2,1,3;4,3,1,4;4,3,3,3;10,1,2,1;8,3,4,1;5,2,4,4;11,1,2,6;12,1,5,6");
    table.insert(self._datas,"5,6|9,2,1,1;1,3,2,1;5,2,4,1;7,1,3,3;1,2,1,3;5,2,3,4;100,1,5,4;11,1,3,6;10,1,1,4");
    table.insert(self._datas,"5,6|9,2,1,1;1,1,2,1;11,1,4,2;3,5,1,2;11,3,1,4;10,1,2,4;3,1,4,3;11,1,4,6;12,1,5,1");
    table.insert(self._datas,"5,6|6,3,1,1;8,2,3,1;8,3,4,1;7,1,2,3;9,5,3,4;9,2,4,5;6,4,1,5;8,1,1,2");
    table.insert(self._datas,"5,6|9,2,1,1;11,1,2,1;6,4,3,1;1,3,1,3;11,2,1,4;8,2,4,5;5,2,3,3;1,1,1,6");
    -- 40
    table.insert(self._datas,"6,5|6,1,2,1;9,2,1,2;2,1,1,3;1,1,2,5;3,1,4,1;3,5,4,3;9,2,5,1");
    table.insert(self._datas,"7,5|11,6,1,1;12,2,3,1;7,4,1,2;8,2,2,4;1,3,3,3;2,1,3,4;6,2,6,1;100,1,6,3");
    table.insert(self._datas,"6,5|9,2,1,2;6,2,2,1;6,3,1,4;6,1,3,3;11,1,3,2;12,1,4,1;9,2,5,1;1,2,5,3;12,1,6,4;12,1,4,5");
    table.insert(self._datas,"6,5|8,2,1,1;5,2,2,1;1,2,1,3;6,2,2,4;11,3,3,3;100,1,4,1;11,1,5,3;6,3,5,1;2,1,4,4");
    table.insert(self._datas,"6,5|6,3,1,1;6,1,2,3;1,1,3,1;4,3,5,1;4,4,3,2;9,1,1,5;6,2,5,4;100,1,6,3");
    table.insert(self._datas,"6,5|4,4,1,1;11,5,1,2;11,3,3,1;11,1,4,1;1,1,2,5;5,2,3,3;5,2,5,1;6,1,5,4");
    table.insert(self._datas,"6,5|2,5,1,1;6,2,1,3;2,1,1,4;100,1,2,2;8,2,4,1;8,3,5,1;6,3,4,3;5,2,5,4;6,2,4,4");
    table.insert(self._datas,"6,5|7,1,1,1;12,5,1,2;9,2,1,4;6,2,3,4;8,4,3,1;5,2,5,1;1,1,4,3;7,1,4,4;11,1,5,5");
    table.insert(self._datas,"6,5|9,2,1,1;9,2,3,2;12,2,2,1;11,1,1,3;6,2,1,4;6,2,5,1;8,2,2,4;1,1,3,5;12,2,4,4;10,1,5,1");
    table.insert(self._datas,"6,5|9,2,2,1;11,1,3,1;1,1,4,2;8,2,1,3;6,3,3,3;11,6,2,4;8,2,5,3");
    table.insert(self._datas,"6,6|100,1,1,2;9,2,2,1;7,1,4,2;1,1,3,1;10,1,1,3;8,4,2,5;10,1,4,4;6,2,3,3;12,1,4,4;4,4,5,3");
    table.insert(self._datas,"7,6|8,2,2,1;4,3,1,3;6,4,1,5;8,3,3,4;8,1,5,3;11,3,3,2;11,1,4,1;2,1,4,1;6,2,6,3;12,1,1,3");
    table.insert(self._datas,"6,6|1,2,1,2;5,4,2,1;5,2,4,2;1,1,4,1;8,2,2,3;3,2,1,5;6,3,4,5;8,3,5,3;8,2,3,4");
    table.insert(self._datas,"6,6|8,2,1,1;8,3,2,1;6,2,1,3;8,4,1,4;9,1,1,6;1,1,4,1;6,1,5,2;4,3,5,4;12,1,6,6;100,1,4,3");
    table.insert(self._datas,"6,6|11,1,1,1;11,1,3,1;100,1,1,2;1,6,1,3;6,4,2,5;4,4,2,2;9,2,4,3;10,1,5,1;100,1,6,4");
    table.insert(self._datas,"6,6|1,1,1,1;12,5,1,2;12,1,1,2;100,1,1,4;9,2,2,5;11,1,3,4;100,1,6,3;12,2,4,1;8,3,4,2;6,4,4,5");
    table.insert(self._datas,"6,6|9,2,1,1;6,3,2,1;7,4,1,3;1,1,2,3;6,3,4,2;6,1,5,5;12,2,2,5;9,1,3,4;100,1,6,1");
    table.insert(self._datas,"6,6|6,3,1,1;3,1,1,2;7,1,1,5;11,1,2,6;11,3,4,4;10,1,5,4;8,3,4,1;1,2,3,1;100,1,6,1;0,0,2,3;0,0,3,4;0,0,4,3;0,0,5,4");
    table.insert(self._datas,"6,6|100,1,1,1;8,2,2,3;8,4,2,4;12,2,4,5;8,2,5,1;5,4,4,3;2,1,2,1;1,1,1,6");
    table.insert(self._datas,"6,6|9,1,1,1;12,1,1,2;2,7,1,2;7,1,2,4;9,2,1,5;1,1,3,3;8,4,4,1;100,1,6,2;1,7,4,4;11,2,3,5");
    --60
    table.insert(self._datas,"5,7|3,1,1,3;8,1,2,1;11,1,4,1;9,2,3,1;8,2,3,3;12,5,3,4;8,6,1,6;6,2,5,6;100,1,5,2");
    table.insert(self._datas,"5,7|11,1,1,1;3,1,1,3;6,1,2,2;11,1,2,4;2,6,3,1;12,1,5,1;8,4,3,4;9,2,3,6;6,3,4,6;5,2,1,6");
    table.insert(self._datas,"5,7|1,4,3,1;4,3,1,2;5,2,2,3;5,2,4,3;6,2,1,5;1,3,2,5;1,1,2,7;0,0,2,6;0,0,4,6;6,2,5,5");
    table.insert(self._datas,"5,7|9,2,1,1;1,1,2,1;5,4,1,3;3,1,1,5;6,1,2,5;6,4,3,6;1,4,4,4;8,2,3,2;10,1,4,1");
    table.insert(self._datas,"5,7|1,1,2,1;6,1,1,2;9,2,1,4;7,1,3,2;4,4,2,4;4,4,4,3;11,5,4,4;5,4,1,6");
    table.insert(self._datas,"5,7|6,3,1,1;1,4,1,2;11,3,1,4;11,1,3,5;12,2,3,4;100,1,3,1;6,1,4,2;7,1,3,6;5,2,1,6");
    table.insert(self._datas,"5,7|11,1,1,1;6,1,1,2;100,1,1,4;7,1,2,4;5,2,1,6;1,4,3,5;4,4,4,5;8,3,4,2;2,7,3,1");
    table.insert(self._datas,"5,7|11,2,1,1;12,2,2,1;1,2,1,3;11,4,2,3;4,3,1,5;9,1,2,7;6,2,4,3;6,1,4,5;8,1,5,1");
    table.insert(self._datas,"5,7|1,3,1,1;6,2,1,2;6,4,1,3;6,3,1,5;6,2,1,6;9,1,2,7;2,7,3,4;5,2,4,5;8,4,3,1;2,1,3,2");
    table.insert(self._datas,"5,7|6,2,1,1;8,2,2,1;1,1,1,3;1,2,1,4;7,1,2,5;1,5,1,6;6,3,4,6;12,5,3,1;12,1,5,1");
    table.insert(self._datas,"7,5|6,3,1,1;8,1,1,2;12,5,2,2;6,2,4,1;8,4,3,4;100,1,5,1;3,1,6,1;6,1,6,4");
    table.insert(self._datas,"7,5|1,1,1,1;3,1,1,3;8,3,2,3;4,4,6,1;12,6,3,1;8,2,5,2;11,2,5,4;6,2,4,4");
    table.insert(self._datas,"7,5|5,6,1,1;9,2,1,4;11,1,2,4;12,5,2,1;1,3,4,1;1,1,4,3;8,4,3,4;11,1,5,5;12,1,7,5;12,1,7,3;12,1,7,1");
    table.insert(self._datas,"7,5|6,2,1,1;1,7,2,1;8,6,4,1;10,1,4,2;6,3,6,3;9,2,3,4;8,2,2,3;100,1,1,3;5,2,5,4");
    table.insert(self._datas,"7,5|11,1,1,1;1,1,1,2;0,0,1,3;1,3,2,3;1,5,2,4;8,2,1,4;6,3,3,1;2,4,5,2;1,3,5,1;9,2,6,4");
    table.insert(self._datas,"7,5|8,2,1,1;8,4,1,2;8,2,1,4;11,1,2,5;6,3,3,4;6,3,3,1;2,1,3,2;9,2,6,2;11,1,6,1;5,4,5,4");
    table.insert(self._datas,"7,5|9,2,1,1;7,1,3,1;9,2,4,2;12,3,5,1;9,2,3,4;1,3,1,3;11,1,1,5;2,1,4,3;1,1,5,5");
    table.insert(self._datas,"7,5|7,1,1,1;1,2,2,2;9,2,1,4;11,3,3,3;100,1,4,1;6,2,5,1;11,1,6,1;6,4,5,2;8,4,4,4;11,1,6,5");
    table.insert(self._datas,"7,5|11,1,1,1;4,7,1,2;8,2,1,3;6,3,3,1;8,2,4,4;1,1,1,5;10,1,4,1;11,3,6,2;6,3,6,1;2,1,5,4");
    table.insert(self._datas,"7,5|5,4,1,1;3,1,1,2;1,1,2,3;5,2,2,4;5,2,4,3;8,4,5,4;10,1,6,1;4,6,4,1");
    -- 80
    table.insert(self._datas,"6,7|6,1,2,1;100,1,1,2;11,3,2,3;11,2,1,5;12,5,3,2;3,7,4,1;8,1,5,4;100,1,6,4;2,1,2,6;11,1,3,5");
    table.insert(self._datas,"6,7|12,2,1,1;10,2,1,2;11,6,3,3;9,2,4,1;11,1,5,1;100,3,2,5;11,1,2,6;1,1,1,7;6,4,4,6");
    table.insert(self._datas,"6,7|9,2,2,1;1,1,1,3;11,1,2,4;2,6,1,5;6,3,3,5;1,2,5,5;9,2,4,3;7,6,4,1");
    table.insert(self._datas,"6,7|10,3,1,3;3,1,2,2;100,1,3,1;6,2,4,1;4,3,4,2;100,1,3,5;11,3,4,5;6,1,5,4;12,1,6,3");
    table.insert(self._datas,"6,7|9,1,1,1;10,1,1,2;100,1,1,5;3,1,3,3;3,4,4,4;3,5,3,1;10,1,5,1;3,2,3,6;11,3,2,5");
    table.insert(self._datas,"6,7|6,2,1,1;6,1,2,3;11,2,2,1;6,1,5,1;7,1,4,3;1,1,3,5;11,2,2,5;9,2,1,6;8,2,5,6;6,3,5,4;12,1,6,7");
    table.insert(self._datas,"6,7|11,2,1,1;12,2,2,1;1,4,5,1;9,1,1,3;11,1,1,4;3,6,2,4;1,1,1,5;9,2,1,6;2,1,3,6;11,3,5,3;6,2,6,5");
    table.insert(self._datas,"6,7|4,4,1,1;100,1,1,2;6,4,1,4;12,2,2,6;4,3,3,1;12,1,3,1;12,5,3,3;12,1,5,5;11,2,1,6;100,1,6,5;2,2,5,1");
    table.insert(self._datas,"6,7|5,1,1,1;6,2,1,6;5,6,2,3;9,2,2,1;9,1,3,1;9,5,4,2;3,6,2,4;7,4,5,3;100,1,6,5;9,1,2,7");
    table.insert(self._datas,"6,7|1,3,1,1;4,6,1,2;7,5,1,5;4,4,1,4;6,6,3,4;11,2,4,3;9,5,4,1;9,2,5,2;5,2,5,5;1,1,4,7");
    -- 90
    table.insert(self._datas,"7,6|100,1,1,1;3,1,1,4;1,1,2,1;7,5,2,2;9,5,3,2;6,3,5,1;10,1,6,1;2,5,5,4;2,1,4,5;1,3,2,5");
    table.insert(self._datas,"7,6|1,1,3,1;8,2,1,1;8,1,2,2;9,3,3,2;1,2,6,1;2,2,6,2;6,4,5,5;1,3,3,5;11,2,1,5");
    table.insert(self._datas,"7,6|3,1,1,1;7,1,1,4;6,1,3,2;4,1,2,1;3,1,5,2;10,1,6,1;7,2,5,4;12,5,3,4;1,1,1,6");
    table.insert(self._datas,"7,6|6,1,1,2;6,2,3,1;9,2,1,4;12,7,2,2;4,3,3,4;4,3,5,4;12,1,5,4;100,1,5,1;8,2,6,2;100,1,7,3");
    table.insert(self._datas,"7,6|10,4,1,1;6,3,2,2;6,3,1,4;5,7,1,4;9,2,4,2;100,2,4,1;100,1,7,2;6,2,6,2;7,1,4,4;5,2,4,5;6,1,6,5");
    table.insert(self._datas,"7,6|12,1,1,1;8,4,1,1;8,6,4,1;12,1,7,1;11,2,5,2;11,1,6,4;8,2,4,4;1,3,5,5;6,1,2,3;6,3,3,2;10,3,1,3;11,2,3,5;12,1,7,6;12,1,1,6");
    table.insert(self._datas,"7,6|6,2,2,1;12,7,1,2;11,1,1,5;1,5,1,5;8,3,3,3;8,2,5,4;6,4,5,5;9,3,5,3;100,2,3,1;2,1,5,1");
    table.insert(self._datas,"7,6|9,2,2,1;6,1,1,3;4,3,2,4;7,6,3,2;11,1,5,1;1,4,5,2;8,3,6,1;100,1,7,4;11,1,5,6;1,1,4,5");
    table.insert(self._datas,"7,6|100,2,1,1;11,5,1,2;11,1,1,6;3,4,2,3;12,3,3,1;11,3,6,1;10,2,3,4;5,2,6,3;6,6,5,4;12,1,2,5");
    table.insert(self._datas,"7,6|11,1,1,1;6,2,1,2;4,2,2,2;100,1,1,4;7,1,2,5;8,2,3,2;12,1,4,3;5,1,5,2;3,4,5,1;3,1,6,4;8,1,7,2");
    -- 100
    table.insert(self._datas,"6,8|1,2,1,1;6,1,1,4;3,1,1,6;9,2,2,6;2,7,2,1;8,4,3,2;4,4,5,1;1,4,5,3;12,3,3,5;10,1,5,6;5,2,3,7");
    table.insert(self._datas,"6,8|10,1,1,1;8,2,1,4;8,3,2,4;8,2,3,1;7,6,3,2;3,1,5,1;2,1,4,4;1,2,5,6;6,1,3,7;12,1,4,6;4,4,1,6");
    table.insert(self._datas,"6,8|100,2,2,1;8,2,1,2;8,2,1,7;5,2,3,2;5,2,5,1;4,3,1,3;1,7,4,3;5,2,5,6;12,5,2,4;12,7,3,5;9,1,2,8;12,1,2,6");
    table.insert(self._datas,"6,8|7,1,1,2;100,3,3,1;10,5,3,2;8,5,4,4;8,1,6,2;4,2,2,3;11,2,1,5;11,1,2,7;9,1,3,8;2,1,4,6");
    table.insert(self._datas,"6,8|8,2,1,1;4,3,1,2;11,2,1,5;6,2,1,7;8,2,2,7;5,2,3,1;6,1,5,1;2,3,2,3;2,1,2,4;10,2,4,4;12,1,6,3;9,5,4,7;12,1,5,8");
    table.insert(self._datas,"6,8|9,1,2,1;1,3,1,2;11,5,1,3;8,3,1,6;12,5,2,3;5,3,3,6;3,5,4,1;12,1,4,3;6,1,5,4;12,1,4,5;12,2,4,7;11,1,4,8");
    table.insert(self._datas,"6,8|5,3,1,1;9,6,2,2;5,6,2,5;3,6,2,6;4,7,3,3;7,1,4,1;6,3,5,2;1,2,5,6;6,2,6,7;100,1,1,6");
    table.insert(self._datas,"6,8|1,1,1,1;3,4,1,2;8,1,1,3;10,5,1,6;11,1,2,8;2,2,2,3;3,1,4,1;6,1,5,1;4,3,5,3;8,3,5,5;11,1,5,8;8,2,4,7;12,1,4,6");
    table.insert(self._datas,"6,8|11,2,1,1;100,3,2,1;8,3,5,1;9,5,3,3;8,1,2,3;5,1,1,3;10,1,2,5;1,1,1,8;11,2,4,7;12,5,4,5;6,2,4,4;12,1,6,7");
    table.insert(self._datas,"6,8|11,5,1,1;8,1,1,5;6,1,2,4;6,6,2,1;6,2,5,1;7,2,4,1;10,2,3,4;1,4,5,4;12,2,4,7;11,3,2,6;12,1,5,8;12,1,6,4");
    table.insert(self._datas,"8,6|8,2,1,3;6,1,2,4;5,2,2,1;8,3,3,2;3,4,4,1;4,3,6,1;2,1,5,3;9,1,5,5;3,2,3,5;8,1,8,1;11,1,7,6");
    table.insert(self._datas,"8,6|11,2,1,1;12,2,1,3;4,4,1,4;6,2,1,5;8,3,3,4;11,3,4,1;1,2,7,1;2,2,5,1;1,4,5,4;10,1,7,2;6,1,7,5;12,1,2,1");
    table.insert(self._datas,"8,6|1,2,1,1;4,3,1,3;5,2,1,5;3,4,2,2;10,2,3,3;2,4,5,1;1,1,6,1;12,3,5,3;12,1,6,3;11,2,6,5;12,1,5,6;8,1,8,2");
    table.insert(self._datas,"8,6|8,1,1,2;6,6,2,1;11,5,2,3;12,5,3,3;10,2,5,3;7,1,5,2;9,1,5,1;5,2,7,2;4,4,7,4;1,1,5,6");
    table.insert(self._datas,"8,6|2,1,1,2;2,7,3,3;8,3,4,4;11,1,1,4;1,2,6,3;6,4,4,1;12,1,4,1;5,2,7,3;12,1,4,6");
    table.insert(self._datas,"8,6|11,3,1,2;8,2,2,1;6,3,3,2;10,6,3,3;1,7,1,4;12,1,2,6;2,4,5,2;6,1,6,1;10,1,7,2;3,1,6,4;11,1,7,5");
    table.insert(self._datas,"8,6|7,1,1,1;5,3,2,2;6,2,1,3;11,2,1,5;10,2,2,3;6,4,4,5;6,1,4,3;1,3,4,1;4,3,6,1;1,4,6,4;6,1,7,3");
    table.insert(self._datas,"8,6|100,1,1,1;9,1,2,1;12,6,3,2;8,2,2,2;9,2,1,5;6,6,2,4;6,4,4,5;1,3,6,5;12,5,5,2;11,1,6,1;8,3,7,1;12,1,8,6");
    table.insert(self._datas,"8,6|5,3,1,1;7,5,1,4;3,5,2,1;8,4,4,2;8,6,3,4;11,2,4,5;12,1,2,5;9,1,5,1;4,4,7,2;6,2,6,3;6,1,7,5");
    table.insert(self._datas,"8,6|100,1,1,1;12,1,2,1;7,1,2,2;6,1,1,4;11,1,1,6;5,6,3,3;2,5,5,1;7,6,4,3;10,3,6,2;8,1,8,2;1,1,5,6");
    table.insert(self._datas,"7,8|3,4,1,1;3,1,1,2;2,1,1,4;8,2,1,6;6,4,1,7;9,5,3,6;11,2,4,7;6,1,5,4;1,6,6,4;2,5,4,1;4,6,3,2;12,1,7,3");
    table.insert(self._datas,"7,8|1,1,1,1;1,2,2,2;6,2,1,4;5,2,3,2;1,3,4,1;1,7,5,2;6,5,6,5;6,3,3,6;10,1,4,6;1,1,1,8;3,1,2,5;6,1,3,4");
    table.insert(self._datas,"7,8|11,1,1,1;8,2,1,2;10,3,2,3;1,2,1,6;7,1,2,7;3,1,3,2;11,1,4,3;1,7,4,1;6,3,6,1;8,1,7,3;8,5,5,4;8,2,4,5;7,1,5,7;11,1,6,8");
    table.insert(self._datas,"7,8|1,1,1,1;1,4,1,2;1,2,2,5;4,2,1,6;4,3,3,5;3,4,2,2;5,2,4,2;1,1,4,4;12,2,5,1;9,2,6,2;6,1,5,5;5,2,6,6;11,2,5,7");
    table.insert(self._datas,"7,8|100,1,1,1;100,2,2,1;4,4,6,1;9,3,4,2;7,2,4,5;1,4,2,2;6,2,2,4;100,1,1,6;6,5,2,5;11,2,3,7;9,2,4,3;8,2,4,5;10,1,6,6");
    table.insert(self._datas,"7,8|5,6,1,1;6,1,1,4;5,6,1,6;2,1,2,1;1,3,3,3;6,2,3,4;6,4,3,5;12,2,2,7;4,6,5,7;4,4,5,5;10,1,5,2;9,5,5,1;8,1,7,3");
    table.insert(self._datas,"7,8|1,1,1,1;8,1,1,3;11,2,2,2;9,6,2,4;6,4,1,7;4,7,3,2;12,2,3,5;100,2,3,7;100,3,4,1;8,3,6,2;9,2,6,4;3,6,5,6");
    table.insert(self._datas,"7,8|100,1,2,1;6,1,1,4;12,6,2,5;9,2,2,7;10,4,4,6;10,4,3,1;12,2,3,4;12,4,4,1;11,1,5,3;10,1,6,2;4,4,6,5;5,4,5,7");
    table.insert(self._datas,"7,8|1,6,2,1;11,5,1,3;12,1,2,6;6,1,3,4;4,2,3,6;10,6,4,2;2,7,4,5;12,7,5,5;3,7,5,2;1,1,4,1;6,2,7,1;5,2,6,7");
    table.insert(self._datas,"7,8|8,1,1,3;5,3,2,2;1,1,2,1;9,2,3,3;6,3,4,3;4,2,2,5;11,1,2,8;3,2,4,7;8,2,3,5;5,2,4,5;7,1,5,1;11,4,6,3;12,1,6,5");
    table.insert(self._datas,"8,7|8,2,1,1;8,4,1,2;4,4,1,4;7,5,1,5;12,2,3,1;12,5,3,2;3,3,3,4;11,7,5,2;12,1,7,2;5,2,7,3;1,2,5,5;8,4,6,5");
    table.insert(self._datas,"8,7|1,2,1,1;100,1,1,5;5,1,2,2;5,2,2,6;4,4,3,1;11,5,3,2;100,1,4,5;10,5,5,1;12,5,5,3;11,2,5,5;3,6,6,5;8,5,7,1");
    table.insert(self._datas,"8,7|10,4,1,1;2,1,2,1;12,5,2,3;11,3,2,5;5,2,3,6;6,3,4,5;8,3,4,2;9,1,5,1;9,2,6,2;8,5,7,2;2,4,6,4;1,1,5,7;6,3,7,6");
    table.insert(self._datas,"8,7|5,6,1,1;10,4,1,4;3,2,2,1;9,4,3,3;4,5,2,4;3,6,5,4;7,2,6,5;11,4,7,1;100,3,4,1");
    table.insert(self._datas,"8,7|100,3,1,1;10,2,1,2;11,1,1,5;8,2,1,6;1,4,3,5;3,4,3,3;1,7,4,1;6,1,5,4;7,1,5,6;1,1,6,7;11,5,7,2;100,1,8,1");
    table.insert(self._datas,"8,7|9,1,1,1;100,2,1,2;11,3,1,3;10,2,2,3;10,2,4,1;1,3,4,4;10,1,6,3;7,1,4,6;1,5,5,6;8,1,8,3");
    table.insert(self._datas,"8,7|1,2,1,3;11,2,2,1;9,1,3,1;8,3,2,3;6,2,2,5;9,2,1,6;4,2,4,3;5,6,5,2;10,1,6,1;6,5,7,3;10,1,7,5;6,1,4,6");
    table.insert(self._datas,"8,7|11,3,1,3;11,2,2,2;4,3,2,4;1,6,3,4;6,4,4,6;8,2,5,4;3,5,4,1;7,1,3,1;8,3,6,2;1,6,7,3;6,2,6,5");
    table.insert(self._datas,"8,7|9,1,1,1;7,1,1,2;2,1,2,2;6,1,2,4;6,2,1,6;12,3,2,5;2,2,4,2;9,2,5,6;8,4,6,1;5,4,6,3;3,1,6,4;11,1,7,5");
    table.insert(self._datas,"8,7|3,3,1,2;100,1,1,4;11,3,3,3;4,4,3,1;11,1,5,1;2,1,5,1;10,3,5,3;11,2,6,3;9,2,4,5;1,1,3,7;5,2,6,6");
    table.insert(self._datas,"7,7|10,1,1,2;11,1,1,5;7,1,1,6;7,5,3,2;100,1,4,1;4,4,5,2;3,5,5,4;4,6,5,6;3,6,2,5");
    table.insert(self._datas,"7,7|8,1,1,1;1,2,2,1;1,1,3,2;12,2,4,1;10,1,6,1;9,1,2,4;100,1,1,5;11,3,2,5;2,1,4,5;9,1,3,7;6,3,6,4;6,2,7,6");
    table.insert(self._datas,"7,7|11,3,2,1;9,2,1,3;8,5,3,4;100,1,5,4;6,1,6,4;11,2,5,2;100,2,3,1;11,1,3,3;1,1,1,5;9,2,2,6;1,1,4,7");
    table.insert(self._datas,"7,7|9,2,1,2;1,3,2,1;0,0,2,2;10,1,2,3;11,1,1,4;2,4,1,5;11,1,2,7;5,3,4,2;4,7,5,1;6,6,5,3;8,2,4,5;6,4,4,6;6,2,7,5;0,0,6,6");
    table.insert(self._datas,"7,7|9,4,1,1;5,4,1,2;11,2,1,3;6,1,1,5;6,2,3,5;10,4,4,2;3,5,5,2;8,1,7,4;2,5,4,5;2,1,3,6");
    table.insert(self._datas,"7,7|1,1,1,1;11,3,1,2;3,5,2,1;9,3,2,4;12,5,4,2;1,3,5,1;6,2,7,2;12,6,5,4;10,1,6,5;5,2,4,6");
    table.insert(self._datas,"7,7|9,2,1,1;3,1,2,3;7,1,1,6;1,5,2,6;3,7,2,1;9,2,3,3;12,6,5,2;12,5,4,4;6,1,6,6;100,2,4,1");
    table.insert(self._datas,"7,7|3,1,1,1;9,3,1,4;11,2,2,6;2,1,4,5;3,4,3,3;9,5,5,4;7,1,3,1;6,2,2,1;2,1,4,1;2,1,5,6");
    table.insert(self._datas,"7,7|11,2,1,1;100,3,2,1;1,1,3,3;1,1,5,2;11,1,6,1;9,4,2,4;9,2,1,6;12,5,2,5;10,1,4,5;6,1,6,6");
    table.insert(self._datas,"7,7|6,2,1,1;4,3,2,1;4,6,1,3;5,3,1,5;5,4,2,6;6,1,4,1;11,3,4,3;12,5,4,5;7,6,5,2;4,4,6,5;100,1,7,1");
end
function GateData:getData(gate)
    if gate > #self._datas then
        print("no gate",gate)
        return nil;
    end
    for k,v in ipairs(self._cache) do 
        if v.gate == gate then
            return self:copyCacheItem(v);
        end
    end
    local index = gate;
    local dataStr = self._datas[index];
    local arr =  string.split(dataStr, "|");
    local rcs = string.split(arr[1],",");
    local row = tonumber(rcs[1]);
    local col = tonumber(rcs[2]);
    local map = {};
    for i = 1,row do 
        local rowLine = {};
        for j=1,col do 
            table.insert(rowLine,0);
        end
        table.insert(map,rowLine);
    end
    -- print("arr[1]",arr[2])
    local blocks = {};
    local rawList = string.split(arr[2],";");
    for k,v in ipairs(rawList) do 
        local item = string.split(v,",");
        local type = tonumber(item[1])
        local index = tonumber(item[2])
        local row = tonumber(item[3])
        local col = tonumber(item[4])
        if type == 0 and index == 0 then 
            map[row][col] = 2;
        else
            local map2 = BlockData.getInstance():getBlockData(type,index);
            self:fillMap(map,map2,row,col);
            local stru = {};
            stru.type = type;
            stru.index = index;
            stru.row = row;
            stru.col = col;
            stru.map = map2;
            stru.rowGrids = #map2;
            stru.colGrids = #map2[1];
            table.insert(blocks,stru);
        end
    end
    local obj = {
        gate = gate,
        map = map,
        blocks = blocks,
    }
    table.insert(self._cache,obj);
    -- bba.printTable(self._cache)
    return self:copyCacheItem(obj);
end
function GateData:copyCacheItem(item) 
    local newBlocks = {};
    for k,v in ipairs(item.blocks) do
        table.insert(newBlocks,clone(v));
    end
    return {
        map = clone(item.map),
        blocks = newBlocks;
    };
end
function GateData:fillMap(map,map2,row,col)
    for k,v in ipairs(map2) do 
        for i,t in ipairs(v) do 
            if t == 1 then
                map[k + row - 1][i + col - 1] = 1;
            end
        end
    end
end
function GateData:getLength()
    return #self._datas;
end
local LayerBase = class("LayerBase",function() 
    return display.newLayer()
end)
function LayerBase:ctor()
    self.btnArr = {};
end
function LayerBase:addButton(btn)
    table.insert(self.btnArr,btn);
end
function LayerBase:setButtonEnabled(enable)
    for i = #self.btnArr, 1, -1 do 
        local btn = self.btnArr[i];
        if not tolua.isnull(btn) then
            btn:setTouchEnabled(enable)
        else
            table.remove(self.btnArr,i);
        end
    end
end
local BackGroud = class("BackGroud",function() 
    return display.newSprite(CONFIG.R.bg)
end)
function BackGroud:ctor(parent)
    if BA.IS_IPHONEX then
        self:setScaleX(1.22);
    end
    self:addTo(parent)
    self:pos(display.cx,display.cy)
end
local GameMap = class("GameMap",function() 
    return display.newNode()
end)
--[[ type{
    1: 小图
    2: 大图 
}]]
function GameMap:ctor(mapData,type)
    self._map = {};
    self._items = {};
    self._blocks = {};
    self._itemWidth = 50;
    for k,v in ipairs(mapData) do 
        local newLine = {};
        for j = 1, #v do 
            local d = v[j];
            if d == 1 then
                d = -1;
            end
            table.insert(newLine, d);
        end
        table.insert(self._map, newLine);
    end
    local row = #mapData;
    local col = #mapData[1];
    for i = 1,row do 
        local rowLine = mapData[i];
        table.insert(rowLine,0);
        table.insert(rowLine,1,0);
        if i == row then
            local rowLine0 = {};
            local rowLineLast = {};
            for j=1,col+2 do 
                table.insert(rowLine0,0);
                table.insert(rowLineLast,0);
            end
            table.insert(mapData,rowLineLast);
            table.insert(mapData,1,rowLine0);
        end 
    end
    self._mapData = mapData;
    local allRow = row+2;
    local allCol = col+2;
    if type == 1 then
        self._startX =  0 - ((col - 1) / 2 + 0.5) * self._itemWidth - 100;
        self._startY = 180;
    elseif type == 2 then
        self._startX =  display.cx 
        self._startY =  display.cy + self._itemWidth * allRow/2 + 50;
    end
    for i = 1,allRow do
        local rowLine_2 = self._mapData[i];
        for j=1,allCol do 
            local a_1 = rowLine_2[j];
            if a_1 == 1 or a_1 == 2 then
                local name = CONFIG.R.block_bg;
                if a_1 == 2 then
                    name = CONFIG.R.holder;
                end
                local p = self:getPos(i,j);
                local item = display.newSprite(name);
                item:setAnchorPoint(ccp(0,0));
                item:setPosition(p);
                item["row"] = i;
                item["col"] = j;
                item:addTo(self)
                table.insert(self._items,item);
            end
        end
    end
    for i = 1,allRow do 
        local prev = 0;
        local lastAdd = 0;   ---- 原值 -1；
        for j = 1,allCol do 
            local a = self._mapData[i][j];
            if prev ~= a and prev*a == 0 then
                local index = j;
                if prev == 0 then
                    index = j-1;
                end
                if index ~= lastAdd then
                    self:handlerBlank(i,index,2);
                    lastAdd = index;
                end
            end
            prev = a;
        end
    end
    for j = 1,allCol do 
        local prev = 0;
        local lastAdd = 0;
        for i = 1,allRow do 
            local a = self._mapData[i][j];
            if prev ~= a and prev*a == 0 then
                local index = i;
                if prev == 0 then
                    index = i-1;
                end
                if index ~= lastAdd then
                    self:handlerBlank(index,j,1);
                    lastAdd = index;
                end
            end
            prev = a;
        end
    end
end
function GameMap:getPos(row,col)
    local x = col * self._itemWidth + self._startX;
    local y = self._startY - row * self._itemWidth;
    return ccp(x,y)
end
function GameMap:handlerBlank(row,col,type)
    local allRow = #self._mapData;
    local allCol = #self._mapData[1];
    if type == 1 then
        if row ~= allRow and self._mapData[row + 1][col] ~= 0 then
            self:addWrap(row,col,"top");
            if col == 1 or self._mapData[row + 1][col-1] == 0 then
                self:addWrap(row,col,"top_left");
            end
            if col == allCol or self._mapData[row + 1][col + 1] == 0 then
                self:addWrap(row,col,"top_right");
            end
            if col ~= 1 and self._mapData[row][col - 1] ~= 0 and self._mapData[row + 1][col-1] ~= 0 then
                self:addWrap(row,col,"bottom_left2");
            end
            if col ~= allCol and self._mapData[row][col+1] ~= 0 and self._mapData[row+1][col+1] ~= 0 then
                self:addWrap(row,col,"bottom_right2");
            end
        end 
        if  row ~= 1 and self._mapData[row - 1][col] ~= 0  then
            self:addWrap(row,col,"bottom");
            if col == 1 or self._mapData[row - 1][col - 1] == 0 then
                self:addWrap(row,col,"bottom_left");
            end
            if col == allCol or self._mapData[row - 1][col + 1] == 0 then
                self:addWrap(row,col,"bottom_right");
            end
            if col ~= 1 and self._mapData[row][col-1] ~=0 and self._mapData[row - 1][col - 1] ~= 0 then 
                self:addWrap(row,col,"top_left2");
            end
            if col ~= allCol and self._mapData[row][col+1] ~= 0 and self._mapData[row - 1][col+1] ~= 0 then
                self:addWrap(row,col,"top_right2");
            end
        end
    elseif type == 2 then
        if col ~= allCol and self._mapData[row][col+1] ~= 0 then
            self:addWrap(row,col,"left");
        end
        if col ~= 1 and self._mapData[row][col-1] ~= 0 then
            self:addWrap(row,col,"right");
        end
    end
end
function GameMap:addWrap(row,col,type)
    local p = self:getPos(row,col);
    local x = p.x;
    local y = p.y;
    local cap = 1;
    local cap2  = 15;
    local half = 25;
    local bitmap ;
    if type == "top" then
        bitmap = display.newSprite(CONFIG.R.wrap_top);
        x = x + half;
        y = y + bitmap:getContentSize().height/2;
    elseif type == "bottom" then
        bitmap = display.newSprite(CONFIG.R.wrap_bottom);
        x = x + half;
        y = y + half * 2 - 8;
    elseif type == "left" then
        bitmap = display.newSprite(CONFIG.R.wrap_left);
        x = x + self._itemWidth - 8;
        y = y + half;
    elseif type == "right" then
        bitmap = display.newSprite(CONFIG.R.wrap_right);
        x = x + 8;
        y = y + half;
    elseif type == "top_left" then
        bitmap = display.newSprite(CONFIG.R.wrap_top_left);
        x = x - 4;
        y = y + 4;
    elseif type == "top_right" then
        bitmap = display.newSprite(CONFIG.R.wrap_top_right);
        x = x + 4 + half * 2 ;
        y = y + 4 ;
    elseif type == "bottom_left" then
        bitmap = display.newSprite(CONFIG.R.wrap_bottom_left);
        x = x - 4 ;
        y = y + half * 2 - 4;
    elseif type == "bottom_right" then
        bitmap = display.newSprite(CONFIG.R.wrap_bottom_right);
        x = x + half * 2 + 4;
        y = y + half * 2 - 4;
    elseif type == "top_left2" then
        bitmap = display.newSprite(CONFIG.R.wrap_top_left2);
        x = x + half - 14;
        y = y + half + 14;
    elseif type == "top_right2" then
        bitmap = display.newSprite(CONFIG.R.wrap_top_right2);
        x = x + half * 2 - 11;
        y = y + half * 2 - 11;
    elseif type == "bottom_left2" then
        bitmap = display.newSprite(CONFIG.R.wrap_bottom_left2);
        x = x + half - 14;
        y = y + half - 14;
    elseif type == "bottom_right2" then
        bitmap = display.newSprite(CONFIG.R.wrap_bottom_right2);
        x =x + half * 2 - 11;
        y =y + half - 14;
    end
    bitmap:pos(x,y);
    self:addChild(bitmap);
end
function GameMap:passGate() 
    print("无内容")
end
function GameMap:checkBlock(block) 
    local hit = false;
    local p = ccp(block:getPosition());
    p = self:convertToNodeSpace(p)
    p.x = p.x - self._startX;
    p.y = self._startY - p.y - block.height;
    -- bba.printTable(block:map())
    local row = CONFIG.round(p.y / self._itemWidth);
    local col = CONFIG.round(p.x / self._itemWidth) - 1;
    local row2 = row + #block:map() - 1;
    local col2 = col + #block:map()[1] - 1;
    if row >= 1 and row2 <= #self._map and col >= 1 and col2 <= #self._map[1] then
        hit = true;
    end 
    self:changeMap(block, 2)
    local canPut = false;
    if hit then
        block.row = row;
        block.col = col;
        if self:checkCanPut(block) then
            canPut = true;
            block:setPositionX((col + 1) * self._itemWidth + self._startX );
            block:setPositionY(self._startY - row * self._itemWidth - block.height);
            self:changeMap(block, 1);
            if not table.indexof(self._blocks, block) then
                table.insert(self._blocks, block);
                EventManager:getInstance():dispatch("newOne");
            end
            CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_block_drop_mp3,false)
        end
    end
    if not canPut then
        table.removebyvalue(self._blocks, block); 
    end
    return canPut;
end
function GameMap:changeMap(block, type)
    local index = table.indexof(self._blocks, block)
    if type == 2 and not index then
        return;
    end
    local map = block:map();
    local row = block.row;
    local col = block.col;
    for i = 1, #map do 
        local rowLine = map[i];
        for j = 1, #rowLine do 
            local d = rowLine[j];
            if d == 1 then
                local value = 1;
                if type == 2 then
                    value = -1;
                end
                self._map[row + i - 1][col + j - 1] = value;
            end
        end
    end
end
function GameMap:checkCanPut(block) 
    local allRow = #self._map;
    local allCol = #self._map[1];
    local map = block:map();
    local row = block.row;
    local col = block.col;
    if (#map + row - 1 > allRow) or (#map[1] + col - 1 > allCol) then
        return false;
    end
    for i, v in ipairs(map) do 
        for j, d in ipairs(v) do 
            if d == 1 then
                local d2 = self._map[row + i - 1][col + j - 1];
                if d2 ~= -1 then
                    return false;
                end
            end
        end
    end
    return true;
end
local Block = class("Block",function() 
    return display.newLayer()
end)
function Block:ctor(type,index,originBlock,enable)
    if enable == nil then
        enable = true;
    end
    self.dragScale = 1;
    self._startPos = ccp(0,0);
    self._stagePos = ccp(0,0);
    self._type = type;
    self._index = index;
    self._originBlock = originBlock;
    local name = "";
    if type == 0 and index == 0 then
        name = CONFIG.R.holder;
        self._map = {{1}};
    else
        name = CONFIG.R["block_"..type.."_"..index];
        self._map = BlockData:getInstance():getBlockData(type,index);
    end
    self._bitmap = display.newSprite(name);
    self._bitmap:setAnchorPoint(ccp(0,0))
    -- print("size:",self._bitmap:getContentSize().width,self._bitmap:getContentSize().height);
    -- self._bitmap:pos(5,5);
    self:setContentSize(self._bitmap:getContentSize()) 
    self:addChild(self._bitmap,1)
    -- local bound = display.newColorLayer(ccc4(0,0,255,100));
    -- bound:setContentSize(self._bitmap:getContentSize())
    -- bound:addTo(self)
    self.height = self._bitmap:getContentSize().height
    self.width = self._bitmap:getContentSize().width
end
function Block:showShadow()
    local name = CONFIG.R["shadow_"..self._type.."_"..self._index]
    local shadow = display.newSprite(name)
    shadow:setAnchorPoint(ccp(0,0))
    self:addChild(shadow,0);
    self.height = shadow:getContentSize().height
    self.width =shadow:getContentSize().width
    self:setContentSize(shadow:getContentSize()) 
    self._bitmap:pos(5,5);
end
function Block:show()
    self._bitmap:setVisible(true)
end
function Block:hide()
    self._bitmap:setVisible(false)
end 
function Block:type()
    return self._type;
end
function Block:index()
    return self._index;
end
function Block:map()
    return self._map;
end
function Block:copyBlock()
    if not self:isCopy() then
        self._copyBlock = Block.new(self._type,self._index,self);
        self._copyBlock.rightRow = self.rightRow;
        self._copyBlock.rightCol = self.rightCol;
    end
    return self._copyBlock;
end
function Block:originBlock()
    return self._originBlock;
end
function Block:isCopy()
    return self._originBlock ~= nil;
end
function Block:isHolder()
    return self._type == 0 and self._index == 0;
end
function Block:isHide()
    return not self._bitmap:isVisible();
end
local TopBar = class("TopBar",function()
    return display.newSprite(CONFIG.R.score_bg)
end)
function TopBar:ctor()
    local star = display.newSprite(CONFIG.R.star);
    star:pos(30,29);
    star:addTo(self);
    local scoreLabel = CCLabelBMFont:create("", CONFIG.R.num1_fnt);
    self:add(scoreLabel);
    scoreLabel:pos(88,29);
    self.scoreLabel = scoreLabel;
    scoreLabel:scale(0.8);
    self:updateScore();
end
function TopBar:updateScore()
    print("updateScore ",CONFIG.totalScore)
    self.scoreLabel:setString(CONFIG.totalScore);
end
local UnlockLayer = class("UnlockLayer",function() 
    return display.newLayer()
end)
function UnlockLayer.show(parent,gate)
    local layer = UnlockLayer.new(gate);
    layer:addTo(parent,21);
end 
function UnlockLayer:ctor(gate)
    self._gate = gate;
    local bg = display.newSprite(CONFIG.R.end_bg);
    bg:center()
    bg:addTo(self)
    local label = display.newTTFLabel({
        text = "花費5個鑰匙解鎖關卡",
        size = 40,
        color = ccc3(109,31,0),
    })
    label:addTo(bg);
    label:pos(275,300);
    local btn_unlock = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.gate_unlock,
        delegate = self,
        callback = self.buttonHandler,
        tag = "unlock",
    })
    btn_unlock:addTo(bg);
    btn_unlock:pos(275,120);
    local btn_close = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_close1,
        delegate = self,
        callback = self.buttonHandler,
        tag = "close",
    });
    btn_close:addTo(bg);
    btn_close:pos(510,450);
    local key_label = display.newTTFLabel({
        text = PLUGIN_INS.UserInfo.CURRENCY.."/5",
        size = 30,
        color = ccc3(109,31,0)
    })
    key_label:addTo(bg);
    key_label:pos(275,50);
    self:registerScriptTouchHandler(function(event,x,y)
        if event == "began" then
            return true;
        end
    end,false,-127,true)
    self:setTouchEnabled(true);
end
function UnlockLayer:buttonHandler(tag)
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if tag == "unlock" then
        print("currency ",PLUGIN_INS.UserInfo.CURRENCY)
        if PLUGIN_INS.UserInfo.CURRENCY >= 5 then
            CONFIG.gate = self._gate;
            table.insert(CONFIG.unlockedGates,CONFIG.gate);
            CONFIG.saveUnlockGates();
            PLUGIN_INS.UserInfo:setUserInfoByKey({
                CURRENCY = PLUGIN_INS.UserInfo.CURRENCY - 5
            })
            CONFIG.changeScene("gameScene", self:getParent());
        else
            Toast:showToast("鑰匙不足,鑰匙不足請先購買鑰匙。");
        end
    elseif tag == "close" then
        self:removeFromParentAndCleanup(true);
    end
end
local EndWin = class("EndWin",function() 
    return display.newColorLayer(ccc4(0,0,0,120))
end)
function EndWin:ctor()
    -- CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_win2_mp3,false);
    local bg = display.newSprite(CONFIG.R.end_bg);
    bg:center();
    bg:addTo(self);
    local stars = display.newSprite(CONFIG.R.end_stars);
    stars:addTo(bg);
    stars:pos(265,320);
    local pos = {
        ccp(120, 300),
        ccp(265, 350),
        ccp(400, 300),
    }
    self._starList = {};
    for i = 1, 3 do 
        local star = display.newSprite(CONFIG.R["end_star"..i]);
        star:setVisible(false);
        star:addTo(bg);
        star:setPosition(pos[i]);
        table.insert(self._starList,star);
    end
    local next = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_next1,
        delegate = self,
        callback = self.buttonHandler,
        tag = "next",
    })
    next:addTo(bg);
    next:pos(400, 120);
    self._next = next;
    next:setVisible(false);
    local restart = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_restart1,
        delegate = self,
        callback = self.buttonHandler,
        tag = "restart",
    })
    restart:addTo(bg);
    restart:pos(120,120);
    self._restart = restart;
    restart:setVisible(false);
    local btn_gate = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_gate1,
        callback = self.buttonHandler,
        delegate = self,
        tag = "gate",
    })
    btn_gate:addTo(bg)
    btn_gate:pos(255,120);
    self._btn_gate = btn_gate;
    btn_gate:setVisible(false);
    self._starIndex = 0;
    self:showStar();
    self:registerScriptTouchHandler(function(event,x,y) 
        -- print(event)
        if event == "began" then
            return true;
        elseif event == "moved" then
        elseif event == "ended" then
        end
    end,false,-127,true) 
    self:setTouchEnabled(true);
end
function EndWin:buttonHandler(tag)
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if tag == "next" then
        if CONFIG.gate > CONFIG.gateData:getLength() then
            -- 切换到 gateScene
            CONFIG.changeScene("gateScene", self:getParent());
        else
            if not table.indexof(CONFIG.unlockedGates, CONFIG.gate + 1) then
                -- 提示解锁关卡
                UnlockLayer.show(self:getParent(),CONFIG.gate + 1);
            else
                CONFIG.gate = CONFIG.gate + 1;       
                CONFIG.changeScene("gameScene", self:getParent());
            end
        end
    elseif tag == "restart" then
        -- 重新加载 GameScene
        CONFIG.changeScene("gameScene", self:getParent());
    elseif tag == "gate" then
        CONFIG.changeScene("gateScene", self:getParent());
    end
end
function EndWin:showStar()
    self._starIndex = self._starIndex + 1;
    if self._starIndex > #self._starList then
        self:showButton();
        return;
    end
    local star = self._starList[self._starIndex];
    star:setVisible(true);
    local y = star:getPositionY();
    star:setPositionY(y + 150);
    star:scale(1.4);
    local seq = transition.sequence({
        CCMoveTo:create(0.2, ccp(star:getPositionX(), y)),
        CCCallFunc:create(function()
            self:showStar();
        end)
    });
    star:runAction(seq);
end
function EndWin:showButton()
    self._next:setVisible(true);
    self._restart:setVisible(true);
    self._btn_gate:setVisible(true);
end
local GameScene = class("GameScene",LayerBase)
function GameScene.show()
    local layer = GameScene.new()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer)
end
function GameScene:ctor()
    self.super.ctor(self)
    -- UITools.addSpriteFrames(IMG_PATH .. "game")
    -- UITools.addSpriteFrames(IMG_PATH .. "block")
    -- UITools.addSpriteFrames(IMG_PATH .. "shadow")
    self.blockScale = 0.6;
    self.disx = 20
    if BA.IS_IPHONEX then
        self.disx = 50
    end
    print("GameScene ctor---")
    self._blocks = {};
    -- self._tipCount = {};
    local bg = display.newSprite(CONFIG.R.bg)
    bg:pos(display.cx,display.cy);
    self:addChild(bg);
    if BA.IS_IPHONEX then
        bg:setScaleX(1.22)
    end
    local data = GateData.new():getData(CONFIG.gate);
    local gameMap = GameMap.new(data.map, 2);
    gameMap:pos(0,0)
    self:addChild(gameMap,10);
    self._gameMap = gameMap
    --- 触发完成检查
    EventManager:getInstance():add("newOne",self.mapHandler,self);
    self:createBlocks(data.blocks);
    -- 添加主页按钮
    local btn_gate = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_gate1,
        callback = self.buttonHandler,
        delegate = self,
        tag = "gate",
    })
    btn_gate:addTo(self)
    local capx = 70
    if BA.IS_IPHONEX then
        capx = 90
    end
    btn_gate:pos(left(capx),top(capx))
    -- 当前关卡
    local gateNum = CCLabelBMFont:create(tonumber(CONFIG.gate),CONFIG.R.num2_fnt);
    gateNum:addTo(self)
    gateNum:setAnchorPoint(ccp(0.5,1))
    gateNum:pos(display.cx , display.height - 30)
    local topBar = TopBar.new();
    topBar:addTo(self)
    topBar:pos(right(100), top(40));
    self._topBar = topBar;
    local btn_setting = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_setting1,
        delegate = self,
        callback = self.buttonHandler,
        tag = "setting",
    })
    btn_setting:addTo(self)
    btn_setting:pos(left(capx),60);
    local btn_restart = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_restart1,
        delegate = self,
        callback = self.buttonHandler,
        tag = "restart",
    })
    btn_restart:addTo(self);
    btn_restart:pos(right(capx),capx);
    self:registerScriptTouchHandler(function(event,x,y) 
        -- print(event)
        if event == "began" then
            -- 判断点击某一个块
            return self:onTouchBegan(x,y)
        elseif event == "moved" then
            self:onTouchMoved(x,y)
        elseif event == "ended" then
            self:onTouchEnded(x,y)
        end
    end,false,-127,true) 
    self:setTouchEnabled(true);
    self:registerScriptHandler(handler(self,self.onNodeEvent));
end
function GameScene:onNodeEvent(event)
    if event == "exit" then
        EventManager:getInstance():remove("newOne", self);
    end
end
function GameScene:addMap(gate)
    local data = GateData.new():getData(gate);
    local gameMap = GameMap.new(data.map);
    gameMap:pos(0,-150)
    self:addChild(gameMap,10);
    self._gameMap = gameMap
    self:createBlocks(data.blocks);
end
function GameScene:createBlocks(blocks) 
    CONFIG.shuffle(blocks);
    local groups = {};
    local gridCount = 0;
    -- bba.printTable(blocks)
    while(#blocks > 0) do
        local re = self:getGroup(blocks,gridCount)
        table.insert(groups, re)
        gridCount = gridCount + re[#re].colGrids;
    end
    -- bba.printTable(groups);
    self:genBlocks(groups);
    print("line 94")
end
function GameScene:getGroup(blocks,gridCount)
    local colGrids = 0;
    for i = 1,#blocks do 
        colGrids = colGrids + blocks[i].colGrids;
    end
    if gridCount + colGrids <= 14 then
        print(debug.getinfo(1).currentline)
        return {table.remove(blocks,1)};
    end
    local copyBlocks = CONFIG.copyArr(blocks);
    table.sort(copyBlocks,function(a,b)
        if a.rowGrids == b.rowGrids then
            return b.colGrids < a.colGrids;
        end
        return a.rowGrids < b.rowGrids
    end)
    local re = {};
    local short = copyBlocks[1];
    if short.rowGrids == 1 then
        local has = false;
        local b1 = short;
        for i = 2,#copyBlocks do 
            local b2 = copyBlocks[i];
            if b2.rowGrids > 1 then
                break;
            end
            if b2.colGrids == b1.colGrids then 
                table.insert(re,b1)
                table.insert(re,b2)
                has = true;
                break;
            end
            b1 = b2;
        end
        if not has and #copyBlocks > 1 then
            table.insert(re,short);
            local second = copyBlocks[2];
            if second.rowGrids == 1 then
                if second.colGrids > short.colGrids then
                    table.insert(re,second);
                else
                    table.insert(re,1,second);
                end
            end
        end
    else
        table.insert(re,short)
    end
    local bottomCols = re[#re].colGrids;
    local upCols = 0;
    local hasRows = short.rowGrids;
    if #re == 2 then
        hasRows = 2;
    end
    for i = #copyBlocks, 1, -1 do 
        local b = copyBlocks[i];
        if not table.indexof(re, b) then
            local beenCols = b.colGrids + upCols;
            if ((upCols == 0 and bottomCols >= beenCols) or bottomCols >= beenCols) and b.rowGrids + hasRows <= 6  then
                table.insert(re,1,b);
                upCols = upCols + b.colGrids;
                if #re >= 3 then
                    break;
                end
                if bottomCols - upCols <= 1 then
                    break;
                end
            end
        end
    end
    for i = 1, #re do 
        local b = re[i];
        table.removebyvalue(blocks,b);
    end
    return re;
end
function GameScene:genBlocks(groups)
    -- bba.printTable(groups)
    local blockLayer = display.newNode() 
    local maxHeight = 0;
    local gs = {};
    local x = 0;
    for k,v in ipairs(groups) do 
        local gc = self:createGroup(v);
        if gc:getContentSize().height > maxHeight then
            maxHeight = gc:getContentSize().height;
        end
        gc:setPositionX(x);
        blockLayer:addChild(gc);
        table.insert(gs,gc);
        x = x + gc:getContentSize().width + 30;
    end
    blockLayer:setScale(self.blockScale)
    -- local shape = display.newColorLayer(ccc4(0,0,0,100));
    -- shape:setContentSize(CCSize(200,200))
    -- shape:pos(display.cx,display.cy);
    -- self:addChild(shape,1)
    -- blockLayer:ignoreAnchorPointForPosition(false)
    -- blockLayer:setAnchorPoint(ccp(0.5,0))
    self._blockLayer = blockLayer;
    self:addChild(blockLayer,2)
    blockLayer:pos(self.disx,display.cy - maxHeight / 2);
end
-- 创建一组
function GameScene:createGroup(group)
    -- bba.printTable(group)
    local layer = display.newLayer();
    local bottom = self:createBlock(group[#group]);
    layer:addChild(bottom);
    layer:setContentSize(bottom:getContentSize())
    local capy = 15
    if #group == 2 then
        local b = self:createBlock(group[1]);
        b:setPositionY(bottom.height + capy)
        layer:addChild(b);
        layer:setContentSize(CCSize( b.width > bottom.width and b.width or bottom.width ,b.height + bottom.height + capy))
    elseif #group == 3 then 
        local block1 = self:createBlock(group[1]);
        local block2 = self:createBlock(group[2]);
        local b1Size = block1:getContentSize();
        local b2Size = block2:getContentSize();
        if group[2].rowGrids == 1 and group[3].rowGrids == 1 and (group[1].colGrids + group[2].colGrids > group[3].colGrids) then
            block2:setPositionY(bottom.height + 10 );
            block1:setPositionY(bottom.height + 10 + block2.height + 10)
            layer:setContentSize(CCSize(math.max(bottom.width,block1.width,block2.width),bottom.height + block1.height + block2.height + 20))
        else
            local cap = 15;
            if (group[1].colGrids + group[2].colGrids) == group[3].colGrids then
                cap = 5;
            end
            block2:setPositionX(b1Size.width + cap);
            local sw = b1Size.width + b2Size.width + cap
            local width = sw > bottom.width and sw or bottom.width
            local height = 0
            if b1Size.height > b2Size.height then
                block2:setPositionY(b1Size.height - b2Size.height + bottom.height + capy );
                block1:setPositionY(bottom.height + capy)
                height = b1Size.height
            elseif b2Size.height > b1Size.height then
                block1:setPositionY(b2Size.height - b1Size.height + bottom.height + capy);
                block2:setPositionY(bottom.height + capy)
                height = b2Size.height
            else
                block2:setPositionY(bottom.height + capy);
                block1:setPositionY(bottom.height + capy)
                height = b1Size.height
            end
            layer:setContentSize(CCSize(width, bottom.height + capy + height))
        end
        layer:addChild(block1)
        layer:addChild(block2)
    end
    return layer;
end
function GameScene:createBlock(stru)
    local block = Block.new(stru.type,stru.index);
    block.rightRow = stru.row;
    block.rightCol = stru.col;
    block:showShadow();   
    table.insert(self._blocks,block);
    return block;
end
function GameScene:checkComplete()
    -- 判断是否每一个都可见
    for k,v in ipairs(self._blocks) do 
        if not v:isHide() then
            return;
        end
    end
    print("pass ",CONFIG.gate)
    -- 判断提示使用次数
    local starCount = 3;
    CONFIG.passGate(CONFIG.gate,starCount)
    self._topBar:updateScore();
    -- 线上结算界面
    self:addChild(EndWin.new(starCount),20);
end
function GameScene:buttonHandler(data)
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if data == "gate" then
        print("gate touch")
        self:remove();
    elseif data == "setting" then
        CONFIG.changeScene("settingLayer");
    elseif data == "restart" then
        CONFIG.changeScene("gameScene",self);
    end
end
function GameScene:remove()
    CONFIG.changeScene("gateScene",self);
end
function GameScene:mapHandler() 
    self:checkComplete()
end
function GameScene:onTouchBegan(touchx,touchy)
    -- 原始块
    for k, v in ipairs(self._blocks) do 
        local lp = v._bitmap:convertToNodeSpace(ccp(touchx,touchy))
        if not v:isHide() and v._bitmap:boundingBox():containsPoint(lp) then
            local bitSize = v._bitmap:getContentSize();
            local row = math.ceil((bitSize.height - lp.y) / 50);   -- y越大row越小
            local col = math.ceil(lp.x / 50);
            if v:map()[row][col] == 1 then
                local block =  v:copyBlock()
                local x, y = v:getParent():getPosition()
                local dis = 40
                if BA.IS_IPHONEX then
                    dis = 90
                end 
                local worldpos = v._bitmap:convertToWorldSpace(ccp(x,y))
                local p = ccp((worldpos.x - dis) * self.blockScale, worldpos.y)
                block:pos(p.x,p.y)
                self.offx = touchx - p.x;
                self.offy = touchy - p.y;
                self._gameMap:addChild(block)
                v:hide()
                self._currentOriginPos = p
                self._moveBlock = block; 
                return true;
            end
        end
    end
    -- 已放置的块
    for k, v in ipairs(self._gameMap._blocks) do 
        local lp = v._bitmap:convertToNodeSpace(ccp(touchx,touchy))
        if v._bitmap:boundingBox():containsPoint(lp) then
            local bitSize = v._bitmap:getContentSize();
            local row = math.ceil((bitSize.height - lp.y) / 50);   -- y越大row越小
            local col = math.ceil(lp.x / 50);
            if v:map()[row][col] == 1 then
                local x, y = v:originBlock():getParent():getPosition()
                local dis = 40
                if BA.IS_IPHONEX then
                    dis = 90
                end 
                local p = ccp((x + dis) * self.blockScale, self._blockLayer:getPositionY())
                self.offx = touchx - v:getPositionX();
                self.offy = touchy - v:getPositionY();
                self._currentOriginPos = p;
                self._moveBlock = v;
                print("zorder ",self._moveBlock:getZOrder())
                self._moveBlock:setZOrder(1); 
                return true;
            end
        end
    end
    return false;
end
function GameScene:onTouchMoved(x,y)
    local cx = x - self.offx;
    local cy = y - self.offy;
    self._moveBlock:pos(cx,cy);
end
function GameScene:onTouchEnded(x,y)
    local canPut = self._gameMap:checkBlock(self._moveBlock);
    self._moveBlock:setZOrder(0);
    print("canPut",canPut)
    if not canPut then
        local t =  math.sqrt(math.pow(self._currentOriginPos.x - x, 2) + math.pow(self._currentOriginPos.y - y, 2))/5000
        local seq = transition.sequence({transition.spawn({
            CCMoveTo:create(t,self._currentOriginPos),
            CCScaleTo:create(t,self.blockScale),
            -- CCCallFuncN:create(function(node) 
            -- end)
        }),
        CCCallFuncN:create(function(node)
            node:removeFromParentAndCleanup(true)
            node:originBlock():show()
        end)
        })
        self._moveBlock:runAction(seq)
        self._moveBlock = nil;
    end
end
local GateScene = class("GateScene",LayerBase)
function GateScene.show()
    local layer = GateScene:new()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer)
end
function GateScene:ctor()   
    GateScene.super.ctor(self)
    BackGroud.new(self)
    self._pageSize = 12;
    self._page = 1;
    local btn_left = display.newButton({
        normal = CONFIG.R.gate_left,
        delegate = self,
        callback = self.onButton,
        tag = 1;
    })
    btn_left:addTo(self,1)
    local capx = 40
    if BA.IS_IPHONEX then
        capx = 90
    end
    btn_left:pos(capx,display.cy)
    self.btn_left = btn_left
    local btn_right = display.newButton({
        normal = CONFIG.R.gate_right,
        delegate = self,
        callback = self.onButton,
        tag = 2,
    })
    btn_right:addTo(self, 1)
    btn_right:pos(display.width - capx, display.cy);
    self.btn_right = btn_right
    self._totalPage = math.ceil(CONFIG.gateData:getLength() / self._pageSize)
    self._maxPassGate = CONFIG.getMaxPassGate()
    self._page = math.ceil(CONFIG.gate / self._pageSize)
    -- print( "line 56", self._totalPage, self._maxPassGate, self._page  );
    self:showPageFlag();
    local list = self:getPageData(self._page);
    local layer = self:createPageContent(list);
    layer:pos((display.width - 772)/2 + 89, 0);
    self._pageNode = display.newNode();
    self:add(self._pageNode);
    self._pageNode:add(layer);
    self._curView = layer;
    -- topBar
    local topBar = TopBar.new();
    topBar:addTo(self)
    topBar:pos(right(100), top(40));
    local btn_home = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_home1,
        delegate = self,
        callback = self.onButton,
        tag = 3,
    })
    btn_home:addTo(self)
    if not BA.IS_IPHONEX then
        capx = capx + 30
    end
    btn_home:pos(left(capx),top(capx));
    local btn_charge = display.newButton({
        normal = CONFIG.R.btn_shop,
        pressed = CONFIG.R.btn_shop,
        delegate = self,
        callback = self.onButton,
        tag = 4,
    })
    btn_charge:addTo(self,1);
    btn_charge:pos(right(100),60);
    -- local key_bg = display.newSprite(CONFIG.R.score_bg);
    local key_bg = display.newButton({
        normal = CONFIG.R.score_bg,
        pressed = CONFIG.R.score_bg,
        callback = function()
            Toast:showToast("鑰匙用於解鎖關卡,每一關需要5把鑰匙");
        end,
    })
    key_bg:addTo(self,1);
    key_bg:pos(right(100),top(130));
    local key = display.newSprite(CONFIG.R.key);
    key:addTo(key_bg);
    key:pos(-40,0);
    local label = CCLabelBMFont:create(PLUGIN_INS.UserInfo.CURRENCY, CONFIG.R.num1_fnt);
    key_bg:add(label);
    label:pos(20,0);
    self.scoreLabel = label;
    label:scale(0.8);
    -- 设置
    local btn_setting = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_setting1,
        delegate = self,
        callback = self.onButton,
        tag = 5,
    })
    btn_setting:addTo(self);
    btn_setting:pos(left(capx),60);
    EventManager:getInstance():add("UPDATE_CURRENCY",self.onEvent,self);
    self:registerScriptHandler(function(event)
        if event == "exit" then
            EventManager:getInstance():remove("UPDATE_CURRENCY",self);
            print("remove event");
        end 
    end)
end
function GateScene:getPageData(page)
    local len = CONFIG.gateData:getLength();
    local startIndex = (page - 1) * self._pageSize + 1;
    local endIndex = startIndex + self._pageSize - 1;
    if endIndex >= len then
        endIndex = len ;
    end
    local list = {};
    for i = startIndex, endIndex do 
        local score = 0;
        local lock = true;
        if i <= self._maxPassGate + 1 then
            lock = false;
            local passGate = CONFIG.getPassGate(i);
            if passGate then
                score = passGate.score;
            end
        end
        local item = {
            gate = i,
            score = score,
            lock = lock,
        }
        table.insert(list,item);
    end
    return list;
end
function GateScene:createPageContent(list)
    local layer = display.newNode();
    local rowCount = 4;
    local cap = 20;
    for k, item in ipairs(list) do 
        local row = math.floor((k - 1) / rowCount) + 1;
        local col = (k - 1) % rowCount + 1;  -- 1 2 3 0 1 2 
        -- bba.printTable(item);
        local gate = self:createItem(item.gate, item.score, item.lock);
        gate:pos((col - 1) * (178 + cap) , (rowCount - row) * (178 + cap) - 89);
        layer:add(gate);
        if CONFIG.gate == item.gate then
            local sp = display.newSprite(CONFIG.R.gate_frame);
            sp:pos((col - 1) * (178 + cap) , (rowCount - row) * (178 + cap) - 89);
            sp:addTo(layer);
        end
    end
    return layer;
end
function GateScene:createItem(gate, score, lock)
    local name = CONFIG.R.gate_pad_pass;
    if lock then
        name = CONFIG.R.gate_pad_lock;
    end
    local btn = display.newButton({
        normal = name,
        pressed = name,
        delegate = self,
        tag = gate,
        callback = self.onItemHandler,
    })
    local map = GameMap.new(CONFIG.gateData:getData(gate).map, 1);
    map:scale(0.25);
    btn:add(map);
    if lock then
        btn:setTouchEnabled(false);
        local l = display.newSprite(CONFIG.R.gate_lock);
        l:addTo(btn);
        l:pos(44, -44); 
    else
        btn.gate = gate;
        if not table.indexof(CONFIG.unlockedGates,gate) then  --- 可以进入，但未解锁
            local l = display.newSprite(CONFIG.R.gate_lock);
            l:addTo(btn);
            l:pos(44, -44);
        else
            for i = 1, 3 do 
                local name = CONFIG.R.star2;
                if score >= i then
                    name = CONFIG.R.star;
                end 
                local star = display.newSprite(name);
                star:scale(0.8);
                star:pos(-40 + 35 * (i - 1), -55);
                btn:add(star);
            end
        end
    end
    local atlas = CCLabelBMFont:create(gate, CONFIG.R.num1_fnt);
    btn:add(atlas);
    atlas:pos(0, 60);
    atlas:scale(0.8);
    return btn;
end
function GateScene:prevPage()
    if self._sliding then
        return;
    end
    self._sliding = true;
    self:gotoPage(self._page - 1);
end
function GateScene:nextPage()
    if self._sliding then
        return;
    end
    self._sliding = true;
    self:gotoPage(self._page + 1);
end
function GateScene:gotoPage(page)
    local x1 = - display.width - 89;
    local x2 = display.width ;
    if page == self._page + 1 then
        x1 = -x1;
        x2 = -x2;
    end
    local list = self:getPageData(page);
    local layer = self:createPageContent(list);
    layer:pos(x1,0);
    self._pageNode:add(layer);
    local seq = transition.sequence({
        CCMoveTo:create(0.1,ccp(x2,0));
        CCCallFuncN:create(function(node)
            node:removeFromParentAndCleanup(true);
            local act = transition.sequence({
                CCMoveTo:create(0.1,ccp((display.width - 772)/2 + 89, 0 )),
                CCCallFuncN:create(function(node2)
                    self._sliding = false;
                    self._curView = node2;
                 end)
            })
            layer:runAction(act);
        end)
    })
    self._curView:runAction(seq)
    self._page = page;
    self:showPageFlag();
end
function GateScene:onItemHandler(tag)
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3, false);
    if table.indexof(CONFIG.unlockedGates,tag) then
        CONFIG.gate = tag;
        CONFIG.changeScene("gameScene",self);
    else
        UnlockLayer.show(self,tag);
    end
end
function GateScene:showPageFlag()
    self.btn_right:hideAndBan(true);
    self.btn_left:hideAndBan(true);
    if self._page == 1 then
        self.btn_left:hideAndBan(false);
    end
    if self._page >= self._totalPage then
        self.btn_right:hideAndBan(false);
    end
end
function GateScene:onButton(tag) 
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if tag == 1 then
        self:prevPage();
    elseif tag == 2 then
        self:nextPage();
    elseif tag == 3 then
        CONFIG.changeScene("startScene",self);
    elseif tag == 4 then
        print("充值");
        PLUGIN_INS.IapSG:showUI()
    elseif tag == 5 then
        CONFIG.changeScene("settingLayer");
    end
end
function GateScene:onEvent(event,data)
    self.scoreLabel:setString(data);
end
local StartScene = class("StartScene", LayerBase)
function StartScene.show()
    local layer = StartScene.new()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer)
end
function StartScene:ctor()
    StartScene.super.ctor(self)
    UITools.addSpriteFrames(IMG_PATH .. "game")
    UITools.addSpriteFrames(IMG_PATH .. "block")
    UITools.addSpriteFrames(IMG_PATH .. "shadow")
    BackGroud.new(self);
    --- 开始按钮
    local btn_start = display.newButton({
        normal = CONFIG.R.start_play_bg,
        label = CONFIG.R.start_play,
        delegate = self,
        callback = self.onButton,
        tag = 1,
    });
    btn_start:addTo(self);
    btn_start:pos(display.cx,display.cy);
    -- 设置
    local capx = 70
    if BA.IS_IPHONEX then
        capx = 90
    end
    local btn_setting = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_setting1,
        delegate = self,
        callback = self.onButton,
        tag = 2,
    })
    btn_setting:addTo(self)
    btn_setting:pos(left(capx),60);
    local logo = display.newSprite(CONFIG.R.logo);
    logo:addTo(self)
    logo:pos(centerX(),top(80));
    local tip = display.newTTFLabel({
        text = "前30關免費開放。鑰匙用於解鎖關卡,每關5個。",
        size = 24,
        color =  ccc3(109,31,0),
    })
    tip:addTo(self)
    tip:pos(display.cx,30)
end
function StartScene:onButton(tag)
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if tag == 1 then
        print("start")
        CONFIG.changeScene("gateScene",self);
    elseif tag == 2 then
        print("setting")
        CONFIG.changeScene("settingLayer");
    end 
end
local SettingLayer  = class("SettingSettingLayer",function() 
    return display.newColorLayer(ccc4(0,0,0,150))
end)
function SettingLayer.show()
    local layer = SettingLayer.new()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer)
end
function SettingLayer:ctor() 
    local bg = display.newSprite(CONFIG.R.setting_bg);
    bg:addTo(self);
    bg:center();
    local btn_close = display.newButton({
        normal = CONFIG.R.button_bg,
        label = CONFIG.R.button_close1,
        delegate = self,
        callback = self.buttonHandler ,
        tag = "close",
    })
    btn_close:addTo(bg);
    btn_close:pos(270,220);
    btn_close:scale(0.7);
    local sp_music = display.newSprite(CONFIG.R.setting_music);
    sp_music:addTo(bg);
    sp_music:pos(100,160);
    local sp_sound = display.newSprite(CONFIG.R.setting_sound);
    sp_sound:addTo(bg);
    sp_sound:pos(100,90);
    local btn_music = display.newButton({
        normal = CONFIG.R.setting_select_bg,
        pressed = CONFIG.R.setting_select_bg,
        -- label = CONFIG.R.setting_select,
        delegate = self,
        callback = self.buttonHandler,
        tag = "music",
    })
    btn_music:addTo(bg);
    btn_music:pos(200,160);
    self.btn_music = btn_music;
    local img_music = display.newSprite(CONFIG.R.setting_select);
    btn_music:add(img_music)
    self.img_music = img_music;
    local btn_sound = display.newButton({
        normal = CONFIG.R.setting_select_bg,
        pressed = CONFIG.R.setting_select_bg,
        -- label = CONFIG.R.setting_select,
        delegate = self,
        callback = self.buttonHandler,
        tag = "sound",
    })
    btn_sound:addTo(bg);
    btn_sound:pos(200,90);
    self.btn_sound = btn_sound;
    local img_sound = display.newSprite(CONFIG.R.setting_select);
    btn_sound:add(img_sound)
    self.img_sound = img_sound;
    self.img_music:setVisible(CONFIG.canPlayMusic)
    self.img_sound:setVisible(CONFIG.canPlayEffect)
    self:registerScriptTouchHandler(function(event,x,y) 
        if event == "began" then
            return true;
        end
    end,false,-127,true)
    self:setTouchEnabled(true);
end
function SettingLayer:buttonHandler(tag) 
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
    if tag == "close" then
        self:removeFromParentAndCleanup(true);
        CCUserDefault:sharedUserDefault():setBoolForKey("sound_status",CONFIG.canPlayEffect)
        CCUserDefault:sharedUserDefault():setBoolForKey("music_status",CONFIG.canPlayMusic)
    elseif tag == "music" then
        CONFIG.canPlayMusic = not CONFIG.canPlayMusic
        self.img_music:setVisible(CONFIG.canPlayMusic)
        CONFIG.playMusic();
        print("play music");
    elseif tag == "sound" then
        CONFIG.canPlayEffect = not CONFIG.canPlayEffect
        self.img_sound:setVisible(CONFIG.canPlayEffect)
    end
end

-- [PLUGIN UserInfo START]
-- 如果该插件需要依赖其他插件请按<>中的格式写：<--"@plugin=UserInfo">
-- 从这里开始填写需要依赖的插件 --
-- 插件的配置文件 在该配置文件填写配置数据和常量
-- 其他文件通过require的方式使用该配置文件
local UserInfoConfig = {}
-- 资源路径
UserInfoConfig.RESOURCE_PATH = BASE_IMAGE .. "review/UserInfo/"
-- 可视中心点
UserInfoConfig.VISIBLE_CENTER = ccp(display.cx, display.cy);
-- 可视范围
UserInfoConfig.VISIBLE_SIZE = cc.size(display.width, display.height)
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
--
-- lume
--
-- Copyright (c) 2017 rxi
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
local lume = { _version = "2.3.0" }
local pairs, ipairs = pairs, ipairs
local type, assert, unpack = type, assert, unpack or table.unpack
local tostring, tonumber = tostring, tonumber
local math_floor = math.floor
local math_ceil = math.ceil
local math_atan2 = math.atan2 or math.atan
local math_sqrt = math.sqrt
local math_abs = math.abs
local noop = function()
end
local identity = function(x)
  return x
end
local patternescape = function(str)
  return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
end
local absindex = function(len, i)
  return i < 0 and (len + i + 1) or i
end
local iscallable = function(x)
  if type(x) == "function" then return true end
  local mt = getmetatable(x)
  return mt and mt.__call ~= nil
end
local getiter = function(x)
  if lume.isarray(x) then
    return ipairs
  elseif type(x) == "table" then
    return pairs
  end
  error("expected table", 3)
end
local iteratee = function(x)
  if x == nil then return identity end
  if iscallable(x) then return x end
  if type(x) == "table" then
    return function(z)
      for k, v in pairs(x) do
        if z[k] ~= v then return false end
      end
      return true
    end
  end
  return function(z) return z[x] end
end
function lume.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end
function lume.round(x, increment)
  if increment then return lume.round(x / increment) * increment end
  return x >= 0 and math_floor(x + .5) or math_ceil(x - .5)
end
function lume.sign(x)
  return x < 0 and -1 or 1
end
function lume.lerp(a, b, amount)
  return a + (b - a) * lume.clamp(amount, 0, 1)
end
function lume.smooth(a, b, amount)
  local t = lume.clamp(amount, 0, 1)
  local m = t * t * (3 - 2 * t)
  return a + (b - a) * m
end
function lume.pingpong(x)
  return 1 - math_abs(1 - x % 2)
end
function lume.distance(x1, y1, x2, y2, squared)
  local dx = x1 - x2
  local dy = y1 - y2
  local s = dx * dx + dy * dy
  return squared and s or math_sqrt(s)
end
function lume.angle(x1, y1, x2, y2)
  return math_atan2(y2 - y1, x2 - x1)
end
function lume.vector(angle, magnitude)
  return math.cos(angle) * magnitude, math.sin(angle) * magnitude
end
function lume.random(a, b)
  if not a then a, b = 0, 1 end
  if not b then b = 0 end
  return a + math.random() * (b - a)
end
function lume.randomchoice(t)
  return t[math.random(#t)]
end
function lume.weightedchoice(t)
  local sum = 0
  for _, v in pairs(t) do
    assert(v >= 0, "weight value less than zero")
    sum = sum + v
  end
  assert(sum ~= 0, "all weights are zero")
  local rnd = lume.random(sum)
  for k, v in pairs(t) do
    if rnd < v then return k end
    rnd = rnd - v
  end
end
function lume.isarray(x)
  return (type(x) == "table" and x[1] ~= nil) and true or false
end
function lume.push(t, ...)
  local n = select("#", ...)
  for i = 1, n do
    t[#t + 1] = select(i, ...)
  end
  return ...
end
function lume.remove(t, x)
  local iter = getiter(t)
  for i, v in iter(t) do
    if v == x then
      if lume.isarray(t) then
        table.remove(t, i)
        break
      else
        t[i] = nil
        break
      end
    end
  end
  return x
end
function lume.clear(t)
  local iter = getiter(t)
  for k in iter(t) do
    t[k] = nil
  end
  return t
end
function lume.extend(t, ...)
  for i = 1, select("#", ...) do
    local x = select(i, ...)
    if x then
      for k, v in pairs(x) do
        t[k] = v
      end
    end
  end
  return t
end
function lume.shuffle(t)
  local rtn = {}
  for i = 1, #t do
    local r = math.random(i)
    if r ~= i then
      rtn[i] = rtn[r]
    end
    rtn[r] = t[i]
  end
  return rtn
end
function lume.sort(t, comp)
  local rtn = lume.clone(t)
  if comp then
    if type(comp) == "string" then
      table.sort(rtn, function(a, b) return a[comp] < b[comp] end)
    else
      table.sort(rtn, comp)
    end
  else
    table.sort(rtn)
  end
  return rtn
end
function lume.array(...)
  local t = {}
  for x in ... do t[#t + 1] = x end
  return t
end
function lume.each(t, fn, ...)
  local iter = getiter(t)
  if type(fn) == "string" then
    for _, v in iter(t) do v[fn](v, ...) end
  else
    for _, v in iter(t) do fn(v, ...) end
  end
  return t
end
function lume.map(t, fn)
  fn = iteratee(fn)
  local iter = getiter(t)
  local rtn = {}
  for k, v in iter(t) do rtn[k] = fn(v) end
  return rtn
end
function lume.all(t, fn)
  fn = iteratee(fn)
  local iter = getiter(t)
  for _, v in iter(t) do
    if not fn(v) then return false end
  end
  return true
end
function lume.any(t, fn)
  fn = iteratee(fn)
  local iter = getiter(t)
  for _, v in iter(t) do
    if fn(v) then return true end
  end
  return false
end
function lume.reduce(t, fn, first)
  local acc = first
  local started = first and true or false
  local iter = getiter(t)
  for _, v in iter(t) do
    if started then
      acc = fn(acc, v)
    else
      acc = v
      started = true
    end
  end
  assert(started, "reduce of an empty table with no first value")
  return acc
end
function lume.set(t)
  local rtn = {}
  for k in pairs(lume.invert(t)) do
    rtn[#rtn + 1] = k
  end
  return rtn
end
function lume.filter(t, fn, retainkeys)
  fn = iteratee(fn)
  local iter = getiter(t)
  local rtn = {}
  if retainkeys then
    for k, v in iter(t) do
      if fn(v) then rtn[k] = v end
    end
  else
    for _, v in iter(t) do
      if fn(v) then rtn[#rtn + 1] = v end
    end
  end
  return rtn
end
function lume.reject(t, fn, retainkeys)
  fn = iteratee(fn)
  local iter = getiter(t)
  local rtn = {}
  if retainkeys then
    for k, v in iter(t) do
      if not fn(v) then rtn[k] = v end
    end
  else
    for _, v in iter(t) do
      if not fn(v) then rtn[#rtn + 1] = v end
    end
  end
  return rtn
end
function lume.merge(...)
  local rtn = {}
  for i = 1, select("#", ...) do
    local t = select(i, ...)
    local iter = getiter(t)
    for k, v in iter(t) do
      rtn[k] = v
    end
  end
  return rtn
end
function lume.concat(...)
  local rtn = {}
  for i = 1, select("#", ...) do
    local t = select(i, ...)
    if t ~= nil then
      local iter = getiter(t)
      for _, v in iter(t) do
        rtn[#rtn + 1] = v
      end
    end
  end
  return rtn
end
function lume.find(t, value)
  local iter = getiter(t)
  for k, v in iter(t) do
    if v == value then return k end
  end
  return nil
end
function lume.match(t, fn)
  fn = iteratee(fn)
  local iter = getiter(t)
  for k, v in iter(t) do
    if fn(v) then return v, k end
  end
  return nil
end
function lume.count(t, fn)
  local count = 0
  local iter = getiter(t)
  if fn then
    fn = iteratee(fn)
    for _, v in iter(t) do
      if fn(v) then count = count + 1 end
    end
  else
    if lume.isarray(t) then
      return #t
    end
    for _ in iter(t) do count = count + 1 end
  end
  return count
end
function lume.slice(t, i, j)
  i = i and absindex(#t, i) or 1
  j = j and absindex(#t, j) or #t
  local rtn = {}
  for x = i < 1 and 1 or i, j > #t and #t or j do
    rtn[#rtn + 1] = t[x]
  end
  return rtn
end
function lume.first(t, n)
  if not n then return t[1] end
  return lume.slice(t, 1, n)
end
function lume.last(t, n)
  if not n then return t[#t] end
  return lume.slice(t, -n, -1)
end
function lume.invert(t)
  local rtn = {}
  for k, v in pairs(t) do rtn[v] = k end
  return rtn
end
function lume.pick(t, ...)
  local rtn = {}
  for i = 1, select("#", ...) do
    local k = select(i, ...)
    rtn[k] = t[k]
  end
  return rtn
end
function lume.keys(t)
  local rtn = {}
  local iter = getiter(t)
  for k in iter(t) do rtn[#rtn + 1] = k end
  return rtn
end
function lume.clone(t)
  local rtn = {}
  for k, v in pairs(t) do rtn[k] = v end
  return rtn
end
function lume.fn(fn, ...)
  assert(iscallable(fn), "expected a function as the first argument")
  local args = { ... }
  return function(...)
    local a = lume.concat(args, { ... })
    return fn(unpack(a))
  end
end
function lume.once(fn, ...)
  local f = lume.fn(fn, ...)
  local done = false
  return function(...)
    if done then return end
    done = true
    return f(...)
  end
end
local memoize_fnkey = {}
local memoize_nil = {}
function lume.memoize(fn)
  local cache = {}
  return function(...)
    local c = cache
    for i = 1, select("#", ...) do
      local a = select(i, ...) or memoize_nil
      c[a] = c[a] or {}
      c = c[a]
    end
    c[memoize_fnkey] = c[memoize_fnkey] or {fn(...)}
    return unpack(c[memoize_fnkey])
  end
end
function lume.combine(...)
  local n = select('#', ...)
  if n == 0 then return noop end
  if n == 1 then
    local fn = select(1, ...)
    if not fn then return noop end
    assert(iscallable(fn), "expected a function or nil")
    return fn
  end
  local funcs = {}
  for i = 1, n do
    local fn = select(i, ...)
    if fn ~= nil then
      assert(iscallable(fn), "expected a function or nil")
      funcs[#funcs + 1] = fn
    end
  end
  return function(...)
    for _, f in ipairs(funcs) do f(...) end
  end
end
function lume.call(fn, ...)
  if fn then
    return fn(...)
  end
end
function lume.time(fn, ...)
  local start = os.clock()
  local rtn = {fn(...)}
  return (os.clock() - start), unpack(rtn)
end
local lambda_cache = {}
function lume.lambda(str)
  if not lambda_cache[str] then
    local args, body = str:match([[^([%w,_ ]-)%->(.-)$]])
    assert(args and body, "bad string lambda")
    local s = "return function(" .. args .. ")\nreturn " .. body .. "\nend"
    lambda_cache[str] = lume.dostring(s)
  end
  return lambda_cache[str]
end
local serialize
local serialize_map = {
  [ "boolean" ] = tostring,
  [ "nil"     ] = tostring,
  [ "string"  ] = function(v) return string.format("%q", v) end,
  [ "number"  ] = function(v)
    if      v ~=  v     then return  "0/0"      --  nan
    elseif  v ==  1 / 0 then return  "1/0"      --  inf
    elseif  v == -1 / 0 then return "-1/0" end  -- -inf
    return tostring(v)
  end,
  [ "table"   ] = function(t, stk)
    stk = stk or {}
    if stk[t] then error("circular reference") end
    local rtn = {}
    stk[t] = true
    for k, v in pairs(t) do
      rtn[#rtn + 1] = "[" .. serialize(k, stk) .. "]=" .. serialize(v, stk)
    end
    stk[t] = nil
    return "{" .. table.concat(rtn, ",") .. "}"
  end
}
setmetatable(serialize_map, {
  __index = function(_, k) error("unsupported serialize type: " .. k) end
})
serialize = function(x, stk)
  return serialize_map[type(x)](x, stk)
end
function lume.serialize(x)
  return serialize(x)
end
function lume.deserialize(str)
  return lume.dostring("return " .. str)
end
function lume.split(str, sep)
  if not sep then
    return lume.array(str:gmatch("([%S]+)"))
  else
    assert(sep ~= "", "empty separator")
    local psep = patternescape(sep)
    return lume.array((str..sep):gmatch("(.-)("..psep..")"))
  end
end
function lume.trim(str, chars)
  if not chars then return str:match("^[%s]*(.-)[%s]*$") end
  chars = patternescape(chars)
  return str:match("^[" .. chars .. "]*(.-)[" .. chars .. "]*$")
end
function lume.wordwrap(str, limit)
  limit = limit or 72
  local check
  if type(limit) == "number" then
    check = function(s) return #s >= limit end
  else
    check = limit
  end
  local rtn = {}
  local line = ""
  for word, spaces in str:gmatch("(%S+)(%s*)") do
    local s = line .. word
    if check(s) then
      table.insert(rtn, line .. "\n")
      line = word
    else
      line = s
    end
    for c in spaces:gmatch(".") do
      if c == "\n" then
        table.insert(rtn, line .. "\n")
        line = ""
      else
        line = line .. c
      end
    end
  end
  table.insert(rtn, line)
  return table.concat(rtn)
end
function lume.format(str, vars)
  if not vars then return str end
  local f = function(x)
    return tostring(vars[x] or vars[tonumber(x)] or "{" .. x .. "}")
  end
  return (str:gsub("{(.-)}", f))
end
function lume.trace(...)
  local info = debug.getinfo(2, "Sl")
  local t = { info.short_src .. ":" .. info.currentline .. ":" }
  for i = 1, select("#", ...) do
    local x = select(i, ...)
    if type(x) == "number" then
      x = string.format("%g", lume.round(x, .01))
    end
    t[#t + 1] = tostring(x)
  end
  print(table.concat(t, " "))
end
function lume.dostring(str)
  return assert((loadstring or load)(str))()
end
function lume.uuid()
  local fn = function(x)
    local r = math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef"):sub(r, r)
  end
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end
function lume.hotswap(modname)
  local oldglobal = lume.clone(_G)
  local updated = {}
  local function update(old, new)
    if updated[old] then return end
    updated[old] = true
    local oldmt, newmt = getmetatable(old), getmetatable(new)
    if oldmt and newmt then update(oldmt, newmt) end
    for k, v in pairs(new) do
      if type(v) == "table" then update(old[k], v) else old[k] = v end
    end
  end
  local err = nil
  local function onerror(e)
    for k in pairs(_G) do _G[k] = oldglobal[k] end
    err = lume.trim(e)
  end
  local ok, oldmod = pcall(require, modname)
  oldmod = ok and oldmod or nil
  xpcall(function()
    package.loaded[modname] = nil
    local newmod = require(modname)
    if type(oldmod) == "table" then update(oldmod, newmod) end
    for k, v in pairs(oldglobal) do
      if v ~= _G[k] and type(v) == "table" then
        update(v, _G[k])
        _G[k] = v
      end
    end
  end, onerror)
  package.loaded[modname] = oldmod
  if err then return nil, err end
  return oldmod
end
local ripairs_iter = function(t, i)
  i = i - 1
  local v = t[i]
  if v then return i, v end
end
function lume.ripairs(t)
  return ripairs_iter, t, (#t + 1)
end
function lume.color(str, mul)
  mul = mul or 1
  local r, g, b, a
  r, g, b = str:match("#(%x%x)(%x%x)(%x%x)")
  if r then
    r = tonumber(r, 16) / 0xff
    g = tonumber(g, 16) / 0xff
    b = tonumber(b, 16) / 0xff
    a = 1
  elseif str:match("rgba?%s*%([%d%s%.,]+%)") then
    local f = str:gmatch("[%d.]+")
    r = (f() or 0) / 0xff
    g = (f() or 0) / 0xff
    b = (f() or 0) / 0xff
    a = f() or 1
  else
    error(("bad color string '%s'"):format(str))
  end
  return r * mul, g * mul, b * mul, a * mul
end
function lume.rgba(color)
  local a = math_floor((color / 16777216) % 256)
  local r = math_floor((color /    65536) % 256)
  local g = math_floor((color /      256) % 256)
  local b = math_floor((color) % 256)
  return r, g, b, a
end
local chain_mt = {}
chain_mt.__index = lume.map(lume.filter(lume, iscallable, true),
  function(fn)
    return function(self, ...)
      self._value = fn(self._value, ...)
      return self
    end
  end)
chain_mt.__index.result = function(x) return x._value end
function lume.chain(value)
  return setmetatable({ _value = value }, chain_mt)
end
setmetatable(lume,  {
  __call = function(_, ...)
    return lume.chain(...)
  end
})
local HelperTools = class("HelperTools");
---將外部設定值拷貝到目標之中
-- 
-- 這裡會將目標的鑰匙拿去和源比對，如果源內有值才會將資料拷貝到目標之中
-- 可以避免外部將亂七八糟的資料都設定到target上
-- 
-- @table target目標表，類別內部屬性
-- @table source來源表，外部設定值
function HelperTools.assingTableValue(target, source)
    if not source and type(source) ~= "table" then return; end
    for k, _ in pairs(source) do
        if type(source[k]) == "table" then
            HelperTools.assingTableValue(target[k], source[k]);
        else
            target[k] = source[k];
        end
    end
end
--- 偵測是否在目標物上
function HelperTools.isClickInTarget(target, x, y)
    local parent = target:getParent()
    if not parent then return false; end
    local clickPoint = parent:convertToNodeSpace(ccp(x, y))
    local rect = target:boundingBox()
    return rect:containsPoint(clickPoint)
end
--- 權重選擇
-- @param weightTable 帶入權重數字表
-- @param seed 亂數種子
-- @return 回傳傳入表被選重的index值
function HelperTools.weightedchoice(weightTable, seed)
    local cumulativeWeights = { }
    local seed = seed or 1
    local total = 0
    for i = 1, #weightTable do
        cumulativeWeights[i] = total + weightTable[i]
        total = total + weightTable[i]
    end
    math.randomseed(tonumber(tostring(math.floor(os.time() / seed)):reverse():sub(1, 6)))
    local rnd = math.random() * total
    for i = 1, #weightTable do
        if rnd < cumulativeWeights[i] then
            return i
        end
    end
    return #weightTable
end
-- 玩家假名列表
local FAKENAME_LIST = { "在下老陰比", "一桿狙打天下", "反手就是一槍", "叫我半仙", "誅仙", "別動我開槍了", "絕地撿垃圾", "絕地XXX", "專業撿垃圾", "空投沒命撿", "絕地快遞", "絕命快遞", "別說話吻我", "刺激chi吃雞", "人帥是非多", "沒槍就很狂", "開門送溫暖", "開門你的快遞", "我是d快遞員", "在下伏地魔", "CaaryX", "擦槍走火", "一槍就夠了", "代號XXX", "國際代號XX", "6到沒朋友", "致命98K", "快遞員XX", "開門送快遞的", "年少未曾輕狂", "馬鹿殺手", "盒子已成精", "我偷塔賊溜", "我逃跑賊溜", "我槍法賊溜", "專殺菜雞", "隊友我都不扶", "小鹿吖", "兔兔突", "不給你吃雞", "吃雞都不叫", "牛皮不用吹", "僅此而已", "如履薄冰", "傷心是男人", "南末", "兩肋插刀", "大姨媽打老婆", "如今啥都難", "從訫開始", "青春染紙流年", "萌萌鹿哈尼", "糾結d3心", "你背叛我", "葬嬡", "青春瀟瑟了", "輪囘li巡影", "烈性釹子", "醉狀擺弄姿態", "血緣關係戲子", "vannesa", "柚子未成年", "姚貝娜再見", "一個人在回憶", "天天也很帥", "窒息的鬼魅", "萁實佷介意", "萬賤穿心", "多喜歡張傑吖", "代表月亮消滅", "莈什庅是怺恆", "清風清雲", "相交的平行線", "泡菜煎餅", "紅色的傻子", "只是形式上", "高冷國王i", "稀薄空氣", "棄者後會無期", "如此放蕩", "動感超人", "叼著棒棒糖", "空虛德現實", "淚痕", "永久太賣弄", "Run鯨魚", "藍天下的迷彩", "半路青春", "訫狠痛", "經不起誘惑", "收起你de逼範", "BarBar", "maniubi", "天下無雙", "獨孤天下", "梅長蘇", "飛留", "漠雨見", "LYBNo1", "白日夢", "不好玩", "變色龍", "專打擦邊球", "3000MB", "偷偷點鬼火", "woshiLYB", "RoseMary穎", "Flower穎", "Make堇晨", "mango甜甜", "冷眸2Cruel", "老農民", "殘夢Dangerou", "冷夜色cheeks", "玩命dancers", "情緒控hea2t", "夢徒Dream", "豹女郎", "茶蘼", "逃亡者的詭異", "離人過客", "抽象heart", "你的專屬Tool", "Please遠離我", "紛亂9Demon", "惆悵Burlk", "Yoshi惟美", "旖旎ecstAsy", "深空控DISE", "心奴控bar", "單人House", "破相broken", "Nixon瘋子", "藍顏Memory", "我是壞人", "Believeme", "Cruelheart", "放空砲", "Memorie", "帶我走", "MadDog", "Imfine", "YouAndme", "老狐狸的尾巴", "Tothelonel", "Than後知後覺", "離沫傾城wind", "Distance失落", "似懂非懂", "giveup", "saygoodbye", "你看不見我", "Shadowlover", "八槍子打不著", "Amonologue", "Agoni", "彼岸花Triste", "bridesmai", "滾雪球", "Elijah", "Ean", "Ed", "Melody", "Shirley", "Vivian", "Joyce", "收學費", "紅牌出場", "夏天", "Dream", "黑色的雪", "lovedearly", "Kissme", "草莓味小王子", "若離勿哭", "別開槍自己人", "別動吃煙霧彈", "快來舔包", "東京神話", "暗夜玫瑰", "恍如一場夢", "撩妹高手", "誘惑嘵節", "壞氣少爺", "範二先生", "菩提聖者", "如此Clever", "風起而散的日", "污界槓把子", "D調de華麗", "Rush匪徒", "宛若清風", "煙肺的需求", "半夏時光", "縱情天下", "風漸消逝", "傲笑九天", "自倚修行", "幽冥崖子", "哥de寂寞", "Confuse初顏", "Sweet沫", "Lucy貝貝", "空城Memory", "Nimei雪", "Destiny沫兮", "MeMe撒謊伱", "BABYGIRL", "summer夢", "蜜桃pmy", "吻我", "DeviL熙", "Speed無限速", "Confuse傾城", "Antidote溫瞳", "Missyou", "Fast", "Jay誓言", "Fame陌軒", "單裑繢鏃", "Angel王", "NIdaye峰", "Messi", "工蜂M", "璐客比", "迪達爾", "瑪利奧", "平底鍋", "大吉大利", "Roger", "Gipa", "Rey", "蘇察哈爾", "把你鼠標移開", "槍法好的出奇", "專打美女", "我是認真爆頭", "奇葩閃閃", "死亡一槍", "先殺我隊友啊", "從坑到神坑", "名字長別躲草", "失眠青年", "飛奔de小豬", "日久生姦情", "別追本人已婚", "我智商開外掛", "千雞變", "菠蘿吹雪", "鄉巴佬", "反派作風", "人民戰士別惹", "Throwwweep", "帥很耗CPU", "人走茶涼", "三點一線", "假摔天王", "內馬爾", "C羅", "Zinedine", "Liuzzz", "Ronaldo", "貝克漢", "魯尼", "蘇牙", "LumbMill", "GustavXX", "TryfelliILL", "Shadow", "shiva", "Nopnoped", "Survivors", "Baha", "Jazzzzz", "Scar", "fuenz", "BallocBa", "Miccoily", "Dazeface", "Jimmy", "HaxMax", "Lighter", "Nighters", "近在咫尺", "笑傲江湖", "老男孩", "煙花易冷", "內衣先生", "斗羅", "五月天", "最強男神", "半路跌倒", "幽蘭", "龍龍", "我站著不動", "YY", "嚇到吃手", "大雕萌妹" };
--- 取得指定數量隨機不重複命名
-- @param amount 獲得命名數量
-- @return 回傳amount數量的名字[table]
function HelperTools.getRandomNames(amount)
    local fakeNameList = lume.shuffle(FAKENAME_LIST);
    local names = {}
    for i = 1 , amount do
        names[i] = fakeNameList[i];
    end
    return names;
end
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
PLUGIN_INS.UserInfo= UserInfo.register()
-- [PLUGIN UserInfoEND]
-- [PLUGIN IapSG START]
-- 如果该插件需要依赖其他插件请按该格式写："--@plugin=UserInfo"
-- 从这里开始填写需要依赖的插件 --
-- 插件的配置文件 在该配置文件填写配置数据和常量
-- 其他文件通过require的方式使用该配置文件
local IapSGConfig = {}
-- 资源路径
IapSGConfig.RESOURCE_PATH = CONFIG.REVIEW_PATH .. "IapSG/"
-- 可视中心点
IapSGConfig.VISIBLE_CENTER = ccp(display.cx,display.cy);
-- 可视范围
IapSGConfig.VISIBLE_SIZE = cc.size(display.width,display.height)
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
-- 从这里填写需要额外require的文件 --
-- 视图元素的基类
local IapSGBasePop = class("IapSGBasePop",function ( color,priority,...)
    return display.newColorLayer(color)
end)
IapSGBasePop.TOUCH_PRIORITY_BASE = -200
function IapSGBasePop:ctor( color,priority,... )
    self:setNodeEventEnabled(true);
    self:setAnchorPoint(ccp(0.5, 0.5));
    self:ignoreAnchorPointForPosition(false);
    -- 设置与调整后的设计分辨率大小一致
    self:setContentSize(IapSGConfig.VISIBLE_SIZE);
    -- touch
    -- 默认不吞噬触摸事件
    self._swallow = false
    self._touchRect = CCRect(0,0,self:getContentSize().width,self:getContentSize().height)
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:setTouchEnabled(true);
    self:registerScriptTouchHandler(function(...)
        return self:_onTouch(...)
    end, false, priority or IapSGBasePop.TOUCH_PRIORITY_BASE,true)
end
--处理触摸事件
function IapSGBasePop:_onTouch(event, x, y)
    local pos = self:convertToNodeSpace(ccp(x, y))
    if event == "began" then
        if self._touchRect:containsPoint(pos) then
            return self._swallow
        end 
    elseif event == "ended" then     
    elseif event == "moved" then
    end
    return false
end
-- 吞噬按键
function IapSGBasePop:setSwallowTouch( swallow )
        self._swallow = swallow
end
function IapSGBasePop:onEnter()
end 
function IapSGBasePop:onExit()
end
function IapSGBasePop:onButtonClick()
    CONFIG.playEffect(IMG_PATH .. "cry", CONFIG.R.sounds_click_mp3,false)
end 
local IapSGFailPop = class("IapSGFailPop", IapSGBasePop)
IapSGFailPop.TAG = {
    BUTTON_CLOSE = 100,
}
IapSGFailPop.ZORDER = 800
IapSGFailPop.TOUCH_PRIORITY_BASE = IapSGBasePop.TOUCH_PRIORITY_BASE - 2
IapSGFailPop.TOUCH_PRIORITY = {
    BUTTON = IapSGFailPop.TOUCH_PRIORITY_BASE - 1
}
function IapSGFailPop.show( ... )
    local obj = IapSGFailPop.new(IapSGConfig.DEFAULT_CONFIG.FAIL_UI.LAYER_COLOR
        ,IapSGFailPop.TOUCH_PRIORITY_BASE)
    obj:setPosition(IapSGConfig.VISIBLE_CENTER)
    CCDirector:sharedDirector():getRunningScene():addChild(obj, IapSGFailPop.ZORDER)
end
function IapSGFailPop:ctor(...)
    IapSGFailPop.super.ctor(self,...)
    self:setSwallowTouch(true)
    self:_initUI()
end
function IapSGFailPop:_initUI()
    -- bg
    local bgSP = display.newSprite(IapSGConfig.RESOURCE_PATH .. IapSGConfig.DEFAULT_CONFIG.FAIL_UI.BG)
    bgSP:setPosition(IapSGConfig.VISIBLE_CENTER);
    self._bgSP = bgSP
    self:addChild(bgSP);
    local bgSize  = bgSP:size()
    -- close button
    local closeButton = display.newButton({
        normal   = IapSGConfig.RESOURCE_PATH .. IapSGConfig.DEFAULT_CONFIG.FAIL_UI.CLOSE_BUTTON.IMAGE,
        tag      = IapSGFailPop.TAG.BUTTON_CLOSE,
        delegate = self,
        priority = IapSGFailPop.TOUCH_PRIORITY.BUTTON,
        callback = IapSGFailPop.onButtonClick
    });
    local pos = IapSGConfig.DEFAULT_CONFIG.FAIL_UI.CLOSE_BUTTON.POS
    if pos == "CENTER" then
        pos = ccp(bgSize.width / 2,closeButton:getContentSize().height / 2 + 20)
    elseif pos == "RIGHT" then
        pos = ccp(bgSize.width - closeButton:getContentSize().width / 2
            ,bgSize.height - closeButton:getContentSize().height / 2)
    end 
    closeButton:setPosition(pos);
    bgSP:addChild(closeButton);   
end
--处理触摸事件
function IapSGFailPop:_onTouch(event, x, y)
    local pos  = self:convertToNodeSpace(ccp(x, y))
    local pos1  = self._bgSP:convertToNodeSpace(ccp(x, y))
    local rect = CCRect(0,0,self._bgSP:getContentSize().width,self._bgSP:getContentSize().height)
    if event == "began" then
        if self._touchRect:containsPoint(pos) then
            if not rect:containsPoint(pos1) and IapSGConfig.DEFAULT_CONFIG.STORE.CLOSE_BUTTON.CLOSE_BY_TOUCH then
                self:removeFromParentAndCleanup(true)
            end 
            return self._swallow
        end 
    elseif event == "ended" then     
    elseif event == "moved" then
    end
    return false
end
function IapSGFailPop:onButtonClick(tag)
    IapSGFailPop.super.onButtonClick(self,tag)
    if tag == IapSGFailPop.TAG.BUTTON_CLOSE then
        self:removeFromParentAndCleanup(true)
    end
end
local IapSGSuccessPop = class("IapSGSuccessPop", IapSGBasePop)
IapSGSuccessPop.TAG = {
    BUTTON_CLOSE = 100,
}
IapSGSuccessPop.ZORDER = 800
IapSGSuccessPop.TOUCH_PRIORITY_BASE = IapSGBasePop.TOUCH_PRIORITY_BASE - 2
IapSGSuccessPop.TOUCH_PRIORITY = {
    BUTTON = IapSGSuccessPop.TOUCH_PRIORITY_BASE - 1
}
function IapSGSuccessPop.show( coin )
    local obj = IapSGSuccessPop.new(IapSGConfig.DEFAULT_CONFIG.SUCCESS_UI.LAYER_COLOR
        ,IapSGSuccessPop.TOUCH_PRIORITY_BASE
        ,coin)
    obj:setPosition(IapSGConfig.VISIBLE_CENTER)
    CCDirector:sharedDirector():getRunningScene():addChild(obj, IapSGSuccessPop.ZORDER)
end
function IapSGSuccessPop:ctor(color,priority,coin)
    IapSGSuccessPop.super.ctor(self,color,priority)
    self:setSwallowTouch(true)
    self:_initUI(coin)
end
function IapSGSuccessPop:_initUI(coin)
    -- bg
    local bgSP = display.newSprite(IapSGConfig.RESOURCE_PATH .. IapSGConfig.DEFAULT_CONFIG.SUCCESS_UI.BG)
    bgSP:setPosition(IapSGConfig.VISIBLE_CENTER);
    self._bgSP = bgSP
    self:addChild(bgSP);
    local bgSize  = bgSP:size()
    -- money label
    local num = display.newTTFLabel({
        text = string.format(IapSGConfig.DEFAULT_CONFIG.SUCCESS_UI.STR_HINT,coin),
        size = 28,
        color = display.COLOR_BLACK,
        align = kCCTextAlignmentCenter,
        dimensions = CCSizeMake(470, 200),
    });
    num:setAnchorPoint(ccp(0, 0.5));
    num:setPosition(IapSGConfig.DEFAULT_CONFIG.SUCCESS_UI.STR_POS);
    num:addTo(bgSP);
    -- close button
    local closeButton = display.newButton({
        normal   = IapSGConfig.RESOURCE_PATH .. IapSGConfig.DEFAULT_CONFIG.SUCCESS_UI.CLOSE_BUTTON.IMAGE,
        tag      = IapSGSuccessPop.TAG.BUTTON_CLOSE,
        delegate = self,
        priority = IapSGSuccessPop.TOUCH_PRIORITY.BUTTON,
        callback = IapSGSuccessPop.onButtonClick
    });
    local pos = IapSGConfig.DEFAULT_CONFIG.SUCCESS_UI.CLOSE_BUTTON.POS
    if pos == "CENTER" then
        pos = ccp(bgSize.width / 2,closeButton:getContentSize().height / 2 + 20)
    elseif pos == "RIGHT" then
        pos = ccp(bgSize.width - closeButton:getContentSize().width / 2
            ,bgSize.height - closeButton:getContentSize().height / 2)
    end 
    closeButton:setPosition(pos);
    bgSP:addChild(closeButton);   
end
--处理触摸事件
function IapSGSuccessPop:_onTouch(event, x, y)
    local pos  = self:convertToNodeSpace(ccp(x, y))
    local pos1  = self._bgSP:convertToNodeSpace(ccp(x, y))
    local rect = CCRect(0,0,self._bgSP:getContentSize().width,self._bgSP:getContentSize().height)
    if event == "began" then
        if self._touchRect:containsPoint(pos) then
            if not rect:containsPoint(pos1) and IapSGConfig.DEFAULT_CONFIG.STORE.CLOSE_BUTTON.CLOSE_BY_TOUCH then
                self:removeFromParentAndCleanup(true)
            end 
            return self._swallow
        end 
    elseif event == "ended" then     
    elseif event == "moved" then
    end
    return false
end
function IapSGSuccessPop:onButtonClick(tag)
    IapSGSuccessPop.super.onButtonClick(self,tag)
    if tag == IapSGSuccessPop.TAG.BUTTON_CLOSE then
        self:removeFromParentAndCleanup(true)
    end
end
local IapSGHelper = class("IapSGHelper")
function IapSGHelper:getInstance()
    if self._instance == nil then        
        self._instance = IapSGHelper.new()  
    end  
    return self._instance 
end
function IapSGHelper:startPay(itemNo,count)
	self:_resetStatus()
	IapSGHelper.itemNo = itemNo
	IapSGHelper.count = count
	IapSGHelper.isPay = true
	-- loading
	Loading:showLoading({ during = 600})
	self:_startIap()
end
function IapSGHelper:_resetStatus()
	IapSGHelper.itemNo = 0
	IapSGHelper.count = 0
	IapSGHelper.isPay = false
end
function IapSGHelper:_startIap()
	PayToolsLua:iosPay(IapSGHelper.itemNo,self._checkOrder)
end
function IapSGHelper._checkOrder( success, data )
	Loading:removeLoading()
	IapSGHelper.isPay = false
	if success then
		IapSGSuccessPop.show(IapSGHelper.count)
		EventEngine.dispatch(EventName.UPDATE_GOLD, IapSGHelper.count);
	else
		IapSGFailPop.show()
	end
end
local IapSGStorePop = class("IapSGStorePop", IapSGBasePop)
IapSGStorePop.TAG = {
    BUTTON_CLOSE  = 100,
}
IapSGStorePop.ZORDER = 800
IapSGStorePop.TOUCH_PRIORITY = {
    BUTTON = IapSGBasePop.TOUCH_PRIORITY_BASE - 1,
    TABLE  = IapSGBasePop.TOUCH_PRIORITY_BASE - 1
}
function IapSGStorePop.show( ... )
    local store = IapSGStorePop.new(IapSGConfig.DEFAULT_CONFIG.STORE.LAYER_COLOR)
    store:setPosition(IapSGConfig.VISIBLE_CENTER)
    CCDirector:sharedDirector():getRunningScene():addChild(store, IapSGStorePop.ZORDER)
end
function IapSGStorePop:ctor()
    IapSGStorePop.super.ctor(self)
    self:setSwallowTouch(true)
    self:_initUI()
end
function IapSGStorePop:_initUI()
    -- bg
    local bgSP = display.newSprite(IapSGConfig.RESOURCE_PATH .. IapSGConfig.DEFAULT_CONFIG.STORE.BG)
    bgSP:setPosition(IapSGConfig.VISIBLE_CENTER);
    self._bgSP = bgSP
    self:addChild(bgSP);
    local bgSize  = bgSP:size()
    -- close button
    local closeButton = display.newButton({
        normal   = CONFIG.R.button_bg,
        pressed  = CONFIG.R.button_bg,
        label    = CONFIG.R.button_close1,
        tag      = IapSGStorePop.TAG.BUTTON_CLOSE,
        delegate = self,
        priority = IapSGStorePop.TOUCH_PRIORITY.BUTTON,
        callback = IapSGStorePop.onButtonClick
    });
    local pos = IapSGConfig.DEFAULT_CONFIG.STORE.CLOSE_BUTTON.POS
    if pos == "CENTER" then
        pos = ccp(bgSize.width / 2,closeButton:getContentSize().height / 2 + 20)
    elseif pos == "RIGHT" then
        pos = ccp(bgSize.width - closeButton:getContentSize().width / 2
            ,bgSize.height - closeButton:getContentSize().height / 2)
    end    
    closeButton:setPosition(pos);
    bgSP:addChild(closeButton);
    -- items
    local tableConfig = IapSGConfig.DEFAULT_CONFIG.STORE.TABLE
    local tableView   = CCTableView:create(tableConfig.TABLE_SIZE);
    tableView:setPosition(ccp(bgSize.width / 2 - tableConfig.TABLE_SIZE.width / 2
        ,bgSize.height / 2 - tableConfig.TABLE_SIZE.height / 2 - 30))
    tableView:setDirection(kCCScrollViewDirectionVertical)
    tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    tableView:setTouchPriority(IapSGStorePop.TOUCH_PRIORITY.TABLE)
    tableView:registerScriptHandler(IapSGStorePop._cellSizeForTable, CCTableView.kTableCellSizeForIndex);
    tableView:registerScriptHandler(IapSGStorePop._tableCellAtIndex, CCTableView.kTableCellSizeAtIndex);
    tableView:registerScriptHandler(IapSGStorePop._numberOfCellsInTableView, CCTableView.kNumberOfCellsInTableView);
    tableView:reloadData();  
    tableView:addTo(bgSP) 
end
function IapSGStorePop._cellSizeForTable(tableView, idx)
    return IapSGConfig.DEFAULT_CONFIG.STORE.TABLE.CELL_HEIGHT,tableView:getContentSize().width
end
function IapSGStorePop._numberOfCellsInTableView(tableView)
    return math.ceil(#IapSGConfig.DEFAULT_CONFIG.STORE.TABLE.CELL_DATA / IapSGConfig.DEFAULT_CONFIG.STORE.TABLE.COL)
end
function IapSGStorePop._tableCellAtIndex(tableView, idx)
    local cell = tableView:dequeueCell();
    if not cell then
        cell = CCTableViewCell:new();
    else
        cell:removeAllChildrenWithCleanup(true)
    end
    IapSGStorePop._renderCell(cell,idx)
    return cell;
end
function IapSGStorePop._renderCell( cell,idx )
    local tableConig = IapSGConfig.DEFAULT_CONFIG.STORE.TABLE
    local colWidth,startX,startY = tableConig.TABLE_SIZE.width / tableConig.COL,0,0
    for i = 1,tableConig.COL do
        local dataIndex = idx*tableConig.COL + i
        local data = tableConig.CELL_DATA[dataIndex];
        if data then
            print(dataIndex)
            local itemButton = display.newButton({
                normal   = IapSGConfig.RESOURCE_PATH .. data.IMAGE,
                tag      = dataIndex,
                delegate = self,
                priority = IapSGStorePop.TOUCH_PRIORITY.BUTTON,
                callback = IapSGStorePop.onButtonClick
            });
            startX = colWidth*(i - 1) + colWidth / 2
            startY = itemButton:size().height / 2
            itemButton:setPosition(ccp(startX,startY))
            cell:addChild(itemButton)
        end
    end 
end
--处理触摸事件
function IapSGStorePop:_onTouch(event, x, y)
    local pos  = self:convertToNodeSpace(ccp(x, y))
    local pos1  = self._bgSP:convertToNodeSpace(ccp(x, y))
    local rect = CCRect(0,0,self._bgSP:getContentSize().width,self._bgSP:getContentSize().height)
    if event == "began" then
        if self._touchRect:containsPoint(pos) then
            if not rect:containsPoint(pos1) and IapSGConfig.DEFAULT_CONFIG.STORE.CLOSE_BUTTON.CLOSE_BY_TOUCH then
                print(" - 138 ")
                self:removeFromParentAndCleanup(true)
            end 
            return self._swallow
        end 
    elseif event == "ended" then     
    elseif event == "moved" then
    end
    return false
end
--处理按钮事件
function IapSGStorePop:onButtonClick(tag)
    IapSGStorePop.super.onButtonClick(self,tag)
    if tag == IapSGStorePop.TAG.BUTTON_CLOSE then
        print(" - 155 ")
        self:removeFromParentAndCleanup(true)
    else
        if type(tag) == 'number' then
            local config = IapSGConfig.DEFAULT_CONFIG.STORE.TABLE.CELL_DATA[tag]
            IapSGHelper:getInstance():startPay(config.ITEM_NO,config.COUNT)
        end
    end
end
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
PLUGIN_INS.IapSG= IapSG.register()
-- [PLUGIN IapSGEND]
CONFIG.scenes = {
    startScene=StartScene,
    gateScene = GateScene,
    gameScene = GameScene,
    settingLayer = SettingLayer,
}
CONFIG.changeScene = function(name,old)
    if old then
        old:removeFromParentAndCleanup(true);
    end
    CONFIG.scenes[name].show()
end
local ReviewLayer = class('ReviewLayer',function()
    return CCLayer:create()
end);
function ReviewLayer.create()
    return ReviewLayer.new()
end
function ReviewLayer:ctor()
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
     self:scheduleUpdateWithPriorityLua(function(dt)
        self:update(dt)
    end, 0)
    self:registerScriptHandler(function(tag)
        self:onNodeEvent(tag)
    end)
    -- EventEngine只用来响应金币购买成功的事件
    -- 小游戏使用EventManager
    EventEngine.register(self, self._onEventNotify);
end
function ReviewLayer:onNodeEvent(event)
    if "enter" == event then
        self:_onEnter()
    elseif "exit" == event then
        self:unscheduleUpdate()
        self:_onExit()
    end
end
function ReviewLayer:_onEventNotify(event, data)
    if event and event == EventName.UPDATE_GOLD then
        self:_onGoldCharged(data);
    end
end
function ReviewLayer:_onEnter()
    -- game start
    bba.log("遊戲成功運行") 
    CONFIG.gateData = GateData.new()
    CONFIG.loadConfig();
    CONFIG.playMusic();
    StartScene.show()
    -- import("sg/GameScene").show()
end
function ReviewLayer:dis(arr)
    table.remove(arr,1)
end
function ReviewLayer:_onExit()
    -- game end
    print("ReviewLayer exit")
    EventEngine.unregister(self)
end
function ReviewLayer:update(dt)
end
function ReviewLayer:_onGoldCharged(count)
    -- game charged
    -- 平台充值成功的回调(data花费的钱，count获得的数量)
    bba.log(string.format("花费获得%d",count))
    PLUGIN_INS.UserInfo:setUserInfoByKey({
        CURRENCY = PLUGIN_INS.UserInfo.CURRENCY + count
    })
end
function ReviewLayer:_createResolutionLayer()
    local origin = CCDirector:sharedDirector():getVisibleOrigin();
    --背景颜色可以随自己喜欢来修改，预设是半透明的绿色
    local width = CONFIG.WIN_SIZE.width;
    local height = CONFIG.WIN_SIZE.height;
    local resolutionLayer = CCLayerColor:create(ccc4(0, 255, 0, 128), width, height);
    resolutionLayer:setScale(1 / CONFIG.SCREEN_FACTOR);
    resolutionLayer:setAnchorPoint(0, 0);
    resolutionLayer:setPosition(ccp(origin.x, origin.y));
    return resolutionLayer;
end
return ReviewLayer;