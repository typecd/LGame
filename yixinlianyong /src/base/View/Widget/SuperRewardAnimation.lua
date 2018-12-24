--[[
    顯示全屏獎bigwin效果的動畫物件。

    @ 使用範例 ---------------------------------------------------------------

    -- 引用全屏獎動畫物件
    local SuperReward = require("base.View.Widget.SuperRewardAnimation")

    -- 建立全屏獎動畫物件
    function TestLayer:_initSuperRewardLayer()
        self.superReward = SuperReward.create({
            -- 客制化參數，參考@ ctor()參數說明
        });
        self.superReward:pos(centerX(), centerY());
        self.superReward:addTo(self, 10);
    end

    -- 播放全屏獎動畫(開始後至關閉，流程已自動化)
    -- 參考播放時機：財神到設定"贏得金額"賠付倍數 >= 15倍才播動畫，但免費轉結算畫面"贏得金額"多少都播動畫。
    -- @param score 大獎總分數
    -- @param odds 大獎賠率倍數
    -- @param completionCallback 數字跑動結束時的callback
    -- @param disappearCallback 介面隱藏關閉時的callback
    function PGSUILayer:playBigReward(score, odds, completionCallback, disappearCallback)

        -- 設定各階段callback設定
        self.superReward:setNumberRollStartHandler(function()                 -- 設定開始跑動數字時的callback
        end)

        self.superReward:setNumberRollCompletionHandler(function(isStopAhead) -- 設定數字跑動結束時的callback
            completionCallback(isStopAhead)
        end)

        self.superReward:setAnimationCompletionHandler(function(isStopAhead)  -- 設定金幣跟跑分動畫都結束時的callback
        end)

        self.superReward:setAnimationDisappearHandler(function(isStopAhead)   -- 設定結束時隱藏介面後的callback
            disappearCallback(isStopAhead)
        end)

        self.superReward:start(score, odds); -- 開始播放動畫
    end
--]]
--[[
    @ ctor()參數說明 ---------------------------------------------------------

    -- 不加參數，完全使用base資源與設定，沒有換圖/換音效需求直接如此留空白使用即可
    SuperReward.create({
    });

    -- 可個別設定資源路徑與相關參數，不加以設定的參數仍使用預設設定
    SuperReward.create({
        soundBigStartPath = "base/sound_mp3/big_start.mp3", 	-- (可不加)開始時的長音效
        soundGoldRollPath = "base/sound_mp3/gold_roll.mp3", 	-- (可不加)金幣loop音效
        soundBigEndPath = "base/sound_mp3/big_end.mp3",     	-- (可不加)結束時的音效

        emitBatchNodePath = "base/animation/gold_coin_big",		-- (可不加)包含所有噴金幣的圖集(plist與png檔)，用於batchNode
        emitFramAnimKey = "base_gold_coin_big_000", 			-- (可不加)金幣圖前綴名稱，用在抓名稱，如"gold_"，在plist裡的圖檔名稱則為 gold_00.png、gold_01.png ...
        emitFramAnimTotal = 50, 								-- (可不加)金幣圖動畫總張數
        emitGoldFps = 1/30, 									-- (可不加)多少秒噴一顆金幣

        tipPath = "base/images/quick_over.png",                 -- (可不加)"連點兩下關閉"的提示圖

        sparyLoopPath = "base/particle/sparyloop.plist",        -- (可不加)粒子物件，底部loop噴光效果
        sparyPath = "base/particle/spary.plist",                -- (可不加)粒子物件，切換title時的噴光效果

        bigRewardPath = "base/animation/invincible_big_reward", -- (可不加)sharedTextureCache包含4個大獎圖與2個光效(plist與png檔)，如果有在其他地方預載，可設定 bigRewardPath = false 
        radiantLightEffect = "radiant_light_big.png",           -- (可不加)cache內，底部loop光效圖檔名稱
        flareEffect = "flare_orange.png",                       -- (可不加)cache內，切換title時的光效圖檔名稱
        hideSimpleEffect = false,                               -- (可不加)特殊需求，=true時，radiantLightEffect跟flareEffect兩個效果不加入layer也不顯示。
        lightStartScale = 1.2,                                  -- (可不加)底部loop光效圖檔(radiant light)起始大小
        lightIncreasingScale = 0.1,                             -- (可不加)底部loop光效圖檔(radiant light)每階段增加大小
        flareScaleTable = {                                     -- (可不加)切換title時的光效圖檔(flare)每階段大小
            ccp(3, 2),
            ccp(3.3, 2.2),
            ccp(3.6, 2.4),
            ccp(3.9, 2.6)
        }
        titleScaleTable = {1.0, 1.0, 1.0, 1.0}                  -- (可不加)切換標題的文字每階段大小
        titlesName = {                                          -- (可不加)cache內，每段標題名稱(不含png字尾)
            "big_reward",
            "super_reward",
            "super_big_reward",
            "invincible_big_reward"
        },

        rewardNumPath = "base/number/reward_num",               -- (可不加)含"0~9."的數字圖集(plist與png檔)，用於batchNode
        rewardNumName = "reward_num",                           -- (可不加)cache內，數字圖集參照名稱
        numStartScale = 0.8,                                    -- (可不加)數字起始大小
        numIncreasingScale = 0.1,                               -- (可不加)數字每階段增加大小


        -- 吃雞slot中使用到的特殊參數需求，可跳過不看。
        -- 特殊需求為使用json動畫替代原本radiantLightEffect跟flareEffect的顯示時機。
        -- 需要事先在外部將json動畫所用的資源檔做sharedTextureCache預載。

        showJsonAnimation = false,                                  -- (可不加)true啟用json動畫方法，啟動後以下參數的都需要設定
        lightJsonPath = "GameName/json/ultimatereward_down.json",   -- (啟動後必加)代替底部loop光效(radiantLightEffect)的json動畫檔路徑，showJsonAnimation啟動後必須設定。
        lightJsonParticlesPath = "GameName/json/particles/",        -- (啟動後必加)json粒子檔路徑，上述該json檔使用的粒子檔案路徑，showJsonAnimation啟動後必須設定。
        lightJsonPos = ccp(0, -30),                                 -- (啟動後必加)微調上述json動畫座標，showJsonAnimation啟動後必須設定。
        flareJsonPath = "GameName/json/ultimatereward_up.json",     -- (啟動後必加)代替切換title時的光效(flareEffect)的json動畫檔路徑，showJsonAnimation啟動後必須設定。
        flareJsonParticlesPath = "GameName/json/particles/",        -- (啟動後必加)json粒子檔路徑，上述該json檔使用的粒子檔案路徑，showJsonAnimation啟動後必須設定。
        flareJsonPos = ccp(0, 150),                                 -- (啟動後必加)微調上述json動畫座標，showJsonAnimation啟動後必須設定。
    });
--]]
--[[
    @ 附錄，引用base資源清單 ---------------------------------------------------
    預設參考引用以下公用資源，如公用資源有重大調整請注意命名與路徑：
        res/base/animation/gold_coin_big.plist
        res/base/animation/gold_coin_big.png
        res/base/animation/invincible_big_reward.plist
        res/base/animation/invincible_big_reward.png
        res/base/images/quick_over.png
        res/base/number/reward_num.plist
        res/base/number/reward_num.png
        res/base/particle/particleTexture.png
        res/base/particle/point.png
        res/base/particle/spary.plist
        res/base/particle/sparyloop.plist
        res/base/sound_mp3/big_end.mp3
        res/base/sound_mp3/big_start.mp3
        res/base/sound_mp3/gold_roll.mp3
--]]

local AnimationNumberLabel = require("base.View.Widget.AnimationNumberLabel")
local CA = require("base.View.Widget.CompositionAnimator.CompositionAnimator")
local scheduler = require("base.framework.scheduler")
local EmitGold = require("base.View.Widget.EmitGold")

local SCHEDULER_INTERVAL = 1 / 60

local GOLD_COIN_MAX_JUMP_DURATION = 3
local TITLE_FADE_IN_DURATION1 = 0.16
local TITLE_FADE_IN_DURATION2 = 0.08
local TITLE_FADE_OUT_DURATION = 0.16
local TITLE_SWITCH_DURATION = TITLE_FADE_OUT_DURATION + TITLE_FADE_IN_DURATION1 + TITLE_FADE_IN_DURATION2

local FALRE_FADE_IN_DURATION = 0.04
local FALRE_FADE_OUT_DURATION = 0.4

local NUMBER_DISPLAY_MAX_DURATION = 2
local NUMBER_ROLL_MULTIPLE_TIME = 0.21;
local NUMBER_ROLL_MIN_DURATION = 1.5;

local cutArray = function(a, index)
    local t = {}
    local c = #a
    local temp = {}
    for i = 1, index do 
        table.insert(temp, a[i])
    end
    for i = 1, c - index do 
        t[i] = a[i + index]
    end
    for i = 1, index do 
        t[i + c - index] = temp[i]
    end
    return t
end

local SuperRewardAnimation = class("SuperRewardAnimation", function () 
    local nodeRGBA = CCNodeRGBA:new()
    nodeRGBA:autorelease()
    return nodeRGBA
end)

-- 如要了解細節參數內容，請參考頂端範例參數說明，如只需使用預設設定則讓 configTable = {}
function SuperRewardAnimation.create(configTable)
    return SuperRewardAnimation.new(configTable)
end

function SuperRewardAnimation:ctor(configTable)
    self:setVisible(false)

    self.originScale = UITools.getScreenScale()
    self:setScale(self.originScale)

    self:setNodeEventEnabled(true)
    self:setCascadeOpacityEnabled(true)

    self.animating = false
    self.hasNumberRolled = false
    self.elapsed = 0
    self.fadeOutDuration = 0.2

    self.numStartScale = configTable.numStartScale or 0.8
    self.numIncreasingScale = configTable.numIncreasingScale or 0.1
    self.lightStartScale = configTable.lightStartScale or 1.2
    self.lightIncreasingScale = configTable.lightStartScale or 0.1
    self.soundBigStartPath = configTable.soundBigStartPath or BASE_SOUND .. "_mp3/big_start.mp3";
    self.soundGoldRollPath = configTable.soundGoldRollPath or BASE_SOUND .. "_mp3/gold_roll.mp3";
    self.soundBigEndPath = configTable.soundBigEndPath or BASE_SOUND .. "_mp3/big_end.mp3";
    self.sparyPath = configTable.sparyPath or BASE_PART .. "spary.plist";
    self.flareScaleTable = configTable.flareScaleTable or {ccp(3, 2), ccp(3.3, 2.2), ccp(3.6, 2.4), ccp(3.9, 2.6)};
    self.titleScaleTable = configTable.titleScaleTable or {1.0, 1.0, 1.0, 1.0};
    self.changeTitleTimeLines = configTable.titleTimeLines or {8, 14, 20};
    self.hideSimpleEffect = configTable.hideSimpleEffect;
    self.showJsonAnimation = configTable.showJsonAnimation;
    self.emitGoldFps = configTable.emitGoldFps or 1/16;
    local emitBatchNodePathPath = configTable.emitBatchNodePathPath or BASE_ANIM .. "gold_coin_big";
    local emitFramAnimKey = configTable.emitFramAnimKey or "base_gold_coin_big_000";
    local emitFramAnimTotal = configTable.emitFramAnimTotal or 50;
    local tipPath = configTable.tipPath or BASE_IMAGE .. "quick_over.png";
    local sparyLoopPath = configTable.sparyLoopPath or BASE_PART .. "sparyloop.plist";
    local bigRewardPath = configTable.bigRewardPath or BASE_ANIM .. "invincible_big_reward";
    local radiantLightEffect = configTable.radiantLightEffect or "radiant_light_big.png"
    local flareEffect = configTable.flareEffect or "flare_orange.png";
    local titles = configTable.titlesName or {"big_reward", "super_reward", "super_big_reward", "invincible_big_reward"}
    local rewardNumPath = configTable.rewardNumPath or BASE_NUMBER .. "reward_num";
    local rewardNumName = configTable.rewardNumName or "reward_num";

    if(self.showJsonAnimation) then
        self.hideSimpleEffect = true;
    end

    self.emitGold = EmitGold.create(
        emitBatchNodePathPath,
        emitFramAnimKey,
        emitFramAnimTotal
    );
    self.emitGold:setPosition(
        0,
        -CONFIG_SCREEN_HEIGHT * 0.5
    );
    self:addChild(self.emitGold, 1);

    self.node = CCNode:create();
    self:addChild(self.node, 5);

    self:initTip(tipPath);
    self:initBigBanLayer();
    
    local sparyLoop = CCParticleSystemQuad:create(sparyLoopPath)
    sparyLoop:setAutoRemoveOnFinish(false)
    sparyLoop:pos(0, 60)
    sparyLoop:addTo(self.node, 1)
    sparyLoop:setVisible(false)
    self.sparyLoop = sparyLoop

    -- 載入plist，不會重複載入
    if(bigRewardPath) then
        if(not CCTextureCache:sharedTextureCache():textureForKey(bigRewardPath .. ".png")) then
            CCTextureCache:sharedTextureCache():addImage(bigRewardPath .. ".png");
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(bigRewardPath .. ".plist");
            -- 紀錄下來以供釋放
            self.bigRewardPath = bigRewardPath;
        end
    end

    if(not self.hideSimpleEffect) then
        local light = display.newSprite("#" .. radiantLightEffect)
        local lightBlendFunc = light:getBlendFunc();
        lightBlendFunc.src = GL_SRC_ALPHA
        lightBlendFunc.dst = GL_ONE
        light:setBlendFunc(lightBlendFunc)
        light:pos(0, 60)
        light:addTo(self.node, 3)	
        local rotate = CCRepeatForever:create(CCRotateBy:create(5, 360))
        light:runAction(rotate)
        light:setVisible(false)
        self.light = light 

        local flare = display.newSprite("#" .. flareEffect)
        local flareBlendFunc = flare:getBlendFunc();
        flareBlendFunc.src = GL_SRC_ALPHA
        flareBlendFunc.dst = GL_ONE
        flare:setBlendFunc(flareBlendFunc)
        flare:pos(0, 15)
        flare:setAnchorPoint(0.5, 0.45)
        flare:addTo(self.node, 5)	
        flare:setVisible(false)
        self.flare = flare
    end
    if(self.showJsonAnimation) then
        local light = self.getEffectNode(
            "light",
            configTable.lightJsonPath,
            nil,
            configTable.lightJsonParticlesPath
        );
        light:setPosition(configTable.lightJsonPos or ccp(0, 60));
        light:stopAnimation("light");
        self.node:addChild(light, 3);
        light:setVisible(false)
        self.light = light;

        local flare = self.getEffectNode(
            "flare",
            configTable.flareJsonPath,
            1,
            configTable.flareJsonParticlesPath
        );
        flare:setPosition(configTable.flareJsonPos or ccp(0, 15))
        flare:setAnchorPoint(0.5, 0.45)
        flare:stopAnimation("flare");
        self.node:addChild(flare, 5);
        flare:setVisible(false)
        self.flare = flare
        self.flareJsonPos = configTable.flareJsonPos;
    end

    self.titleIndex = 1
    self.titleSprites = {}
    for i, title in ipairs(titles) do 
        local sprite = display.newSprite("#" .. title .. ".png")
        if sprite then 
            sprite:pos(0, 15)
            sprite:setAnchorPoint(0.5, 0)
            sprite:addTo(self.node, 3)
            sprite:setCascadeOpacityEnabled(true)
            -- if self.titleIndex ~= i then
                sprite:setVisible(false)
            -- end
            table.insert(self.titleSprites, sprite)
        end
    end

    local numLabel = AnimationNumberLabel.new(
        rewardNumPath,
        rewardNumName,
        true
    )
    numLabel:addTo(self.node, 6)
    numLabel:pos(0, 0)
    numLabel:setAnchorPoint(0.5, 1)
    numLabel:setScale(self.numStartScale + (self.titleIndex - 1) * self.numIncreasingScale)
    numLabel:setCascadeOpacityEnabledRecursively(true)
    numLabel:setAnimationCompletionHandler(function() 
        --self.emiting = false
        self.hasNumberRolled = false
        self:stopScheduler()
        self.emitGold:stop();
        self:stopGoldSound();
        
        if self.numberRollCompletionHandler then 
            -- print("SuperReward number scroll stop normally")
            self.numberRollCompletionHandler()
        end
        self.tipSpr:setVisible(false);
        self.tipSwitch = false;

        self:stopAllActions()
        self:performWithDelay(function() 
            -- hide the bg spary particle first, cause it's dazzling
            self.sparyLoop:setVisible(false)
            --fadeOutAllChilden(self.batchNode, self.fadeOutDuration)
            self.emitGold:clear();

            self:runAction(transition.sequence({
                CCFadeOut:create(self.fadeOutDuration),
                CCCallFunc:create(function() 
                    if self.animationCompletionHandler then 
                        -- print("SuperReward animation stop normally")
                        self.animationCompletionHandler(false)
                    end

                    self:setVisible(false)
                    self.bigBanLayer:setVisible(false);
                    self.bigBanLayer:setTouchEnabled(false);
                    self.animating = false
                    if self.animationDisappearHandler then 
                        print("SuperReward animation disappear")
                        self.animationDisappearHandler()
                    end
                    if(self.showJsonAnimation) then
                        self.light:stopAnimation("light");
                        self.flare:stopAnimation("flare");
                    end
                end)
            }))
        --end, NUMBER_DISPLAY_MAX_DURATION)
        end, GOLD_COIN_MAX_JUMP_DURATION)
    end)
    self.numLabel = numLabel
    if(not self.hideSimpleEffect or self.showJsonAnimation) then
        self:addFlare(1)
    end
end

-- 初始連點關閉提示
function SuperRewardAnimation:initTip(path)
    self.tipSpr = display.newSprite(path)
    self.tipSpr:addTo(self.node, 7)
    self.tipSpr:pos(
        right(self.tipSpr:size().width * 0.5 + 25 + display.width * 0.5),
        top(self.tipSpr:size().height * 0.5 + 15 + display.height * 0.5)
    )
    self.tipSpr:setVisible(false);
    self.tipSwitch = false;
end

-- 初始背景
function SuperRewardAnimation:initBigBanLayer()
    local isRunning = false
    local validTapCnt = 0

    local tipSpr = nil
    local helpNode = CCNode:create()
    self.bigBanLayer = display.newColorLayer(ccc4(0, 0, 0, 200))
    self.bigBanLayer:pos(-display.width * 0.5, -display.height * 0.5);
    self.bigBanLayer:registerScriptTouchHandler(function(event, x, y)
        if event == "began" then
            return true
        elseif event == "ended" then
            -- 提示觸碰兩次快速關閉
            if not self.tipSpr:isVisible() and self.tipSwitch then 
                self.tipSpr:setVisible(true);
            end
            -- 觸碰兩次間隔判斷
            if not isRunning then 
                validTapCnt = 0
                isRunning = true
                helpNode:runAction(transition.sequence({
                    CCDelayTime:create(0.5),
                    CCCallFunc:create(function()
                        isRunning = false
                        validTapCnt = 0
                    end)
                }))
            end
            validTapCnt = validTapCnt + 1
            -- 觸碰兩次，關閉
            if validTapCnt >= 2 then 
                if self.tipSpr:isVisible() then
                    self.tipSpr:setVisible(false);
                end
                isRunning = false;
                validTapCnt = 0;
                self:stop();
            end
                
        end
    end, false, -127, true)
    self.bigBanLayer:addTo(self, -1);
    self.bigBanLayer:setVisible(false);
    helpNode:addTo(self.bigBanLayer)
end

---------------------------------------- Life Cycle ----------------------------------------

function SuperRewardAnimation:onEnter()
    -- print("SuperRewardAnimation:onEnter")
end

function SuperRewardAnimation:onExit()
    -- print("SuperRewardAnimation:onExit")
    self:stopScheduler()
    self.emitGold:stop();
    if(self.showJsonAnimation) then
        -- json釋放
        self.light:purgeJsonDataCache();
        self.flare:purgeJsonDataCache();
    end
    if(self.bigRewardPath) then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(self.bigRewardPath .. ".plist")
        CCTextureCache:sharedTextureCache():removeTextureForKey(self.bigRewardPath .. ".png")
    end
end

---------------------------------------- Public Function -----------------------------------

-- 開始跑動數字
function SuperRewardAnimation:setNumberRollStartHandler(handler)
    self.numberRollStartHandler = handler
end

-- 數字跑動結束
function SuperRewardAnimation:setNumberRollCompletionHandler(handler)
    self.numberRollCompletionHandler = handler
end

-- 整體動畫結束
function SuperRewardAnimation:setAnimationCompletionHandler(handler)
    self.animationCompletionHandler = handler
end

-- 整體介面關閉
function SuperRewardAnimation:setAnimationDisappearHandler(handler)
    self.animationDisappearHandler = handler
end

-- 回傳標題切換時間
function SuperRewardAnimation:getTitleTimeLines()
    return self.changeTitleTimeLines;
end

-- 開始BigWin
-- @param rewardNumber 總分數
-- @param rewardOdds 贏得倍數
function SuperRewardAnimation:start(rewardNumber, rewardOdds)
    if self.animating then 
        -- print("SuperRewardAnimation already started")
        return 
    end
    self.animating = true

    -- print("SuperRewardAnimation start ", rewardNumber, numberRollDuration)

    self.rewardNumber = rewardNumber
    self.numberRollDuration = rewardOdds * NUMBER_ROLL_MULTIPLE_TIME;
    if(self.numberRollDuration < NUMBER_ROLL_MIN_DURATION) then
        self.numberRollDuration = NUMBER_ROLL_MIN_DURATION;
    end

    audio.playMusic(self.soundBigStartPath, false);

    self:stopAllActions()
    self:performWithDelay(function() 
        self:setVisible(true)
        self:setOpacity(255)
        self.tipSpr:setVisible(false);
        self.tipSwitch = true;
        self.bigBanLayer:setVisible(true);
        self.bigBanLayer:setTouchEnabled(true)

        if self.animating then
            self.elapsed = 0
            --self.emitElapsed = 0
            --self.emiting = true
            self.hasNumberRolled = true

            self:startScheduler()
            
            --self:addSpary()

            self.numLabel:setScale(self.numStartScale)
            self.numLabel:setNumber(self.rewardNumber, self.numberRollDuration)
            if self.numberRollStartHandler then 
                print("SuperReward number scroll start")
                self.numberRollStartHandler()
            end
            self.goldSound = audio.playSound(self.soundGoldRollPath, true);

            if(not self.hideSimpleEffect or self.showJsonAnimation) then
                self.light:setVisible(true)
                self.light:setScale(self.lightStartScale)
                if(self.showJsonAnimation) then
                    self.light:runAnimation("light")
                end
            end
            self.sparyLoop:setVisible(true)
            self.sparyLoop:setScale(1)

            self.titleIndex = 1
            for i, sprite in ipairs(self.titleSprites) do
                if i <= #self.titleScaleTable then 
                    sprite:setScale(self.titleScaleTable[i])
                end
                if self.titleIndex == i then
                    sprite:setVisible(true)
                else
                    sprite:setVisible(false)
                end
            end

            self.node:setScale(0.01)
            self.node:runAction(CCScaleTo:create(self.fadeOutDuration, self.originScale))
            self:runAction(CCFadeIn:create(self.fadeOutDuration))
        end
    end, 1)
end

---------------------------------------- Private Function ----------------------------------

-- 停止跑分
function SuperRewardAnimation:stop()
    if not self.animating then 
        -- print("SuperRewardAnimation already stopped")
        return 
    end
    self.animating = false
    -- print("SuperRewardAnimation stop")

    self:stopScheduler()
    self:stopAllActions()
    self.emitGold:stop();
    self:stopGoldSound();

    self:setScale(self.originScale)
    self:setVisible(true)
    self:setOpacity(255)

    self.titleIndex = 1
    for i, timeLine in ipairs(self.changeTitleTimeLines) do
        if self.numberRollDuration >= timeLine then 
            self.titleIndex = i + 1
        end
    end
    for i, sprite in ipairs(self.titleSprites) do 
        sprite:stopAllActions()
        if i <= #self.titleScaleTable then 
            sprite:setScale(self.titleScaleTable[i])
        end
        if i == self.titleIndex then 
            sprite:setVisible(true)
        else 
            sprite:setVisible(false)
        end
    end


    if(not self.hideSimpleEffect or self.showJsonAnimation) then
        self.light:setVisible(true)
        self.light:setScale(self.lightStartScale + (self.titleIndex - 1) * self.lightIncreasingScale)
        if(self.showJsonAnimation) then
            self.light:runAnimation("light")
        end
    end
    self.sparyLoop:setScale(1 + (self.titleIndex - 1)* self.numIncreasingScale)
    self.sparyLoop:setVisible(true)
    -- self.numLabel:setScale(self.numStartScale + (self.titleIndex - 1) * self.numIncreasingScale)

    if self.numLabel:isAnimating() then 
        self.numLabel:stopAnimation() 
        if self.numberRollCompletionHandler then 
            -- print("SuperReward number scroll interrupted because of stop")
            self.numberRollCompletionHandler()
        end
    else 
        if not self.hasNumberRolled then
            if self.numberRollCompletionHandler then 
                -- print("SuperReward number scroll interrupted because of number is 0")
                self.numberRollCompletionHandler()
            end
        end
    end
    self.numLabel:setNumber(self.rewardNumber)
    local s = self:adjustNumberLabelScaleInsideScreen(self.numStartScale + (self.titleIndex - 1) * self.numIncreasingScale)
    self.numLabel:setScale(s)
    self.numLabel:setOpacity(255)
    
    local dismissDuration = self.hasNumberRolled and GOLD_COIN_MAX_JUMP_DURATION or NUMBER_DISPLAY_MAX_DURATION

    self:performWithDelay(function() 
        -- hide the bg spary particle first, cause it's dazzling
        self.sparyLoop:setVisible(false)
        --fadeOutAllChilden(self.batchNode, self.fadeOutDuration)
        self.emitGold:clear();
        self:runAction(transition.sequence({
            CCFadeOut:create(self.fadeOutDuration), 
            CCCallFunc:create(function() 
                self:setVisible(false)
                self.bigBanLayer:setVisible(false);
                self.bigBanLayer:setTouchEnabled(false);
                if self.animationDisappearHandler then 
                    --print("SuperReward animation disappear")
                    self.animationDisappearHandler()
                end
                if(self.showJsonAnimation) then
                    self.light:stopAnimation("light");
                    self.flare:stopAnimation("flare");
                end
            end)
        }))
    end, dismissDuration)
    -- end, NUMBER_DISPLAY_MAX_DURATION)
    -- end, GOLD_COIN_MAX_JUMP_DURATION)

    self.hasNumberRolled = false

    if self.animationCompletionHandler then 
        -- print("SuperReward animation interrupted")
        self.animationCompletionHandler(true)
    end 
    self.tipSpr:setVisible(false);
    self.tipSwitch = false;
end

function SuperRewardAnimation:startScheduler()
    if self.scheduler == nil then 
        local changeTitleCount = #self.changeTitleTimeLines
        -- self.scheduler = self:schedule(function()
        self.emitGold:start(self.emitGoldFps);
        self.scheduler = scheduler.scheduleGlobal(function (dt)
            local changeTitleTimeLine = self.changeTitleTimeLines[self.titleIndex]
            if changeTitleTimeLine and self.titleIndex <= changeTitleTimeLine then 
                self.elapsed = self.elapsed + dt
                if self.titleIndex <= changeTitleCount then 
                    -- print("elapsed changeTitleTimeLine", elapsed, changeTitleTimeLine)
                    if self.elapsed >= changeTitleTimeLine then 
                        self:nextTitle()
                    end
                end				
            end
        end, SCHEDULER_INTERVAL)
    end
end

function SuperRewardAnimation:stopScheduler()
    if self.scheduler then 
        scheduler.unscheduleGlobal(self.scheduler)
        -- self:stopAction(self.scheduler)
        self.scheduler = nil
    end
end

function SuperRewardAnimation:nextTitle()
    if self.titleIndex > #self.titleSprites then 
        return 
    end
    -- print("nextTitle", self.titleIndex)
    local curTitle = self.titleSprites[self.titleIndex]
    local nextTitle = self.titleSprites[self.titleIndex + 1]
    local nextScale = self.titleScaleTable[self.titleIndex + 1]
    if curTitle then 
        curTitle:runAction(transition.sequence({
            CCScaleTo:create(TITLE_FADE_OUT_DURATION, 0.01),
            CCCallFunc:create(function()
                curTitle:setVisible(false)
                --self:addSpary()
                self:addFlare(ccp(curTitle:getPositionX(), curTitle:getPositionY() + curTitle:size().height / 2), self.titleIndex + 1)
                if nextTitle then
                    nextTitle:setVisible(true)
                    nextTitle:setScale(0.01)
                    nextTitle:runAction(transition.sequence({
                        CCScaleTo:create(TITLE_FADE_IN_DURATION1, nextScale + 0.1),
                        CCScaleTo:create(TITLE_FADE_IN_DURATION2, nextScale)
                    }))
                end
            end)
        }))
    end

    self.titleIndex = self.titleIndex + 1

    local s = self:adjustNumberLabelScaleInsideScreen(self.numStartScale + (self.titleIndex - 1) * self.numIncreasingScale)
    self.numLabel:runAction(CCScaleTo:create(TITLE_SWITCH_DURATION, s))
    if(not self.hideSimpleEffect or self.showJsonAnimation) then
        self.light:runAction(CCScaleTo:create(TITLE_SWITCH_DURATION, 1.2 + (self.titleIndex - 1) * self.numIncreasingScale))
    end
    self.sparyLoop:runAction(CCScaleTo:create(TITLE_SWITCH_DURATION, 1 + (self.titleIndex - 1) * self.numIncreasingScale))
end

function SuperRewardAnimation:adjustNumberLabelScaleInsideScreen(scale)
    
    local pos = self.numLabel:getParent():convertToWorldSpace(ccp(self.numLabel:getPosition()))
    local numWidthHalf = self.numLabel:size().width * UITools.getScreenScale() * scale * 0.5
    -- print("adjustNumberLabelScaleInsideScreen pos", pos.x, pos.y)
    -- print("adjustNumberLabelScaleInsideScreen numWidthHalf", numWidthHalf)
    if pos.x - numWidthHalf < left() or pos.x + numWidthHalf > right() then 
        local s = centerX() / numWidthHalf
        -- print("adjustNumberLabelScaleInsideScreen222", scale * s)
        return scale * s
    end
    return scale
end

function SuperRewardAnimation:addFlare(index)
    if(not self.hideSimpleEffect or self.showJsonAnimation) then
        self.flare:setVisible(true)
        if(self.flareJsonPos) then
            self.flare:setPositionX(self.flareJsonPos.x)
            self.flare:setPositionY(self.flareJsonPos.y * self.numLabel:getScaleY())
        else
            self.flare:setPositionX(0)
            self.flare:setPositionY(60 * self.numLabel:getScaleY())
        end
        local scale = self.flareScaleTable[index]
        if scale then
            self.flare:setScaleX(scale.x)
            self.flare:setScaleY(scale.y)
        end
        self.flare:runAction(transition.sequence({
            CCFadeIn:create(FALRE_FADE_IN_DURATION),
            CCFadeOut:create(FALRE_FADE_OUT_DURATION),
            CCCallFunc:create(function ()
                self.flare:setVisible(false)
            end)
        }))
        if(self.showJsonAnimation) then
            self.flare:runAnimation("flare", 1);
        end
    end
end

function SuperRewardAnimation:addSpary(pos)
    local spary = CCParticleSystemQuad:create(self.sparyPath)
    spary:setAutoRemoveOnFinish(true)
    spary:addTo(self.node, 2)
    spary:pos(0, 60)
end

-- 停止跑分音效
function SuperRewardAnimation:stopGoldSound()
    audio.stopAllSounds();
    audio.stopMusic();
    audio.playSound(self.soundBigEndPath);
    if self.goldSound then 
        audio.stopSound(self.goldSound)
        self.goldSound = nil
    end
end

-- 創造json動畫
function SuperRewardAnimation.getEffectNode(animName, jsonFile, times, particlesPath)
    -- 預設無限播放
    times = times or 0
    -- 创建CompositionAnimator对象
    local ca = CA.new()
    -- 加载json对应的动画为"anim1","anim2"
    ca:prepareAnimation(animName, jsonFile, particlesPath)
    ca:runAnimation(animName, times)
    return ca
end

return SuperRewardAnimation