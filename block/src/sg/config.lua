CONFIG = {}
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


