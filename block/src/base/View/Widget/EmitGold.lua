--[[
    噴發金幣的動畫物件。

    @ 使用範例 ---------------------------------------------------------------

    -- 引用噴金幣物件
    local EmitGold = require("base.View.Widget.EmitGold")

    -- 建立噴金幣物件
	function TestLayer:_initEmitGoldLayer()
        self.emitGold = EmitGold.create(
            "res/base/animation/gold_coin_big",
            "base_gold_coin_big_000",
            50
        );
		self.emitGold:setPosition(0, -display.height * 0.5);
        self:addChild(self.emitGold, 5);
    end

    -- 開始噴金幣
    function TestLayer:_startEmitGold()
        self.emitGold:start(1/30);
    end

    -- 停止噴金幣
	function TestLayer:_stopEmitGold()
        self.emitGold:stop();
    end

    -- 淡出並隱藏所有金幣
	function TestLayer:_clearEmitGold()
        self.emitGold:clear();
    end
    
--]]
--[[
    @ 使用說明 ---------------------------------------------------------------
    可事先在UIloading或其他地方，將包含金幣圖plist與png檔進行addImageAsync()。
    也讓本物件自動cache，但是是使用addImage()確保資源讀入，故有機會延遲畫面。
    plist命名從00開始，尾端依張數自動加字串(二位數)，如"gold_" + "01" = gold01。
    如果創造多個物件，但每個物件圖片內容與數量完全不一樣，注意plist裡面命名別衝突，避免cache出錯。

    --- 初始化物件
    @param batchNodePath batchNode圖檔路徑，如"res/pgs/coin"，ctor會檢查是否有cache資源，無則自動loading資源;
    @param framAnimKey 金幣圖前綴名稱，用在抓名稱，如"gold_"，起始為00
    @param framAnimTotal -- 金幣圖動畫總張數
    EmitGold:ctor(batchNodePath, framAnimKey, framAnimTotal)

    --- 開始噴發金幣用，如：node:start(1/20)
    @param fps 多少秒噴發一顆金幣
    EmitGold:start(fps);

    -- 停止噴發金幣用
    EmitGold:stop();

    -- 淡出+隱藏介面
    EmitGold:clear();
--]]


local CONFIG_SCREEN_WIDTH = display.width -- CONFIG_SCREEN_WIDTH -- 噴發左右範圍
local CONFIG_SCREEN_HEIGHT = CONFIG_SCREEN_HEIGHT -- 噴發高度

local GOLD_COIN_PRE_CREATE_CACHE_COUNT = 32; -- 初始金幣量
local GOLD_COIN_ADD_CREATE_CACHE_COUNT = 16; -- 不足時增加的金幣量
local GOLD_COIN_JUMP_DURATION = 2 + math.random() * 1; -- 噴發方向

local CLASS_TAG = "EmitGold";

local EmitGold = class(CLASS_TAG, function()
    return CCLayerRGBA:create()
end)

function EmitGold.create(batchNodePath, framAnimKey, framAnimTotal)
    return EmitGold.new(batchNodePath, framAnimKey, framAnimTotal)
end

function EmitGold:ctor(batchNodePath, framAnimKey, framAnimTotal)
    -------------------
    -- Member 初始化
    -------------------
    self.batchNodePath = batchNodePath; -- 金幣BatchNode圖
    self.framAnimKey = framAnimKey; -- 金幣圖動畫名稱
    self.framAnimTotal = framAnimTotal; -- 金幣圖動畫張數

    -- 載入plist，不會重複載入
    if(not CCTextureCache:sharedTextureCache():textureForKey(batchNodePath .. ".png")) then
        CCTextureCache:sharedTextureCache():addImage(batchNodePath .. ".png");
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(batchNodePath .. ".plist");
        self.loadBatchNode = true;
    end

    self._scheduler = CCDirector:sharedDirector():getScheduler();
    self._Update = nil;
    self.coins = {};
    self.allCoins = {};

    self:_initCoinPool();
    self:setCascadeOpacityEnabled(true)
    self:setCascadeOpacityEnabledRecursively(true)

    -------------------
    -- Life Cycle
    -------------------
    self:registerScriptHandler(function(event)
        if self.onEnter and "enter" == event then
            self:onEnter();
        elseif self.onExit and "exit" == event then
            self:onExit();
        end
    end)
end

---------------------------------------- Life Cycle ----------------------------------------
function EmitGold:onEnter()
end

function EmitGold:onExit()
    self.coinBatchNode:removeAllChildrenWithCleanup(true)

    if(self._Update) then
        self._scheduler:unscheduleScriptEntry(self._Update);
    end

    if(self.loadBatchNode) then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(self.batchNodePath .. ".plist")
        CCTextureCache:sharedTextureCache():removeTextureForKey(self.batchNodePath .. ".png")
        self.loadBatchNode = nil;
    end
end

---------------------------------------- Public Function -----------------------------------

-- 開始噴金幣效果
function EmitGold:start(fps)
    self:setVisible(true);
    for i, v in ipairs(self.allCoins) do
        v:setOpacity(255);
    end
    local function updateTime( dt )
        self:_emitGoldCoin();
    end
    self._Update = self._scheduler:scheduleScriptFunc(updateTime, fps, false);
end

-- 停止噴金幣效果
function EmitGold:stop()
    if(self._Update) then
        self._scheduler:unscheduleScriptEntry(self._Update);
    end
end

-- 清除金幣
function EmitGold:clear()
    local duration = 0.2;
    local arr = CCArray:create();
    arr:addObject(CCFadeOut:create(duration));
    arr:addObject(CCCallFunc:create(function ()
        self:setVisible(false);
        self:setOpacity(255);
    end));
    self:stopAllActions();
    self:runAction(CCSequence:create(arr))

    for i, v in ipairs(self.allCoins) do
        v:runAction(CCFadeOut:create(duration))
    end
end

---------------------------------------- Private Function ----------------------------------

-- 噴一個金幣
function EmitGold:_emitGoldCoin()
    local node = self:_getCoinPool();

    -- 原始位置
    local originPoint = ccp(0, 0)
    local leftDir = false
    if math.random(0, 1) == 1 then 
        leftDir = true
    end
    -- 原始偏移
    local startOffsetX = math.random(node:getContentSize().width)
    if leftDir then 
        startOffsetX = startOffsetX * -1
    end 
    local startPoint = ccp(originPoint.x + startOffsetX, originPoint.y - node:getContentSize().height * 0.5)
    -- 掉落點偏移
    local endOffsetX = math.random(0, CONFIG_SCREEN_WIDTH * 0.5)
    if leftDir then 
        endOffsetX = endOffsetX * -1
    end 
    -- 掉落點位置
    local endPoint = ccp(originPoint.x + endOffsetX, startPoint.y)
    node:setRotation(360 * math.random())
    node:setPosition(startPoint)

    local height = math.random(CONFIG_SCREEN_HEIGHT * 0.6, CONFIG_SCREEN_HEIGHT * 1.2) - startPoint.y
    
    -- 跑動畫
    node:stopAllActions()
    local arr = CCArray:create();
    arr:addObject(CCJumpBy:create(GOLD_COIN_JUMP_DURATION, endPoint, height, 1));
    arr:addObject(CCCallFunc:create(function ()
        node:setVisible(false)
        table.insert(self.coins, node)
        --print("CoinPool", #self.coins);
    end));
    node:runAction(CCSequence:create(arr))
end

-- 創造物件池
function EmitGold:_initCoinPool()
    local batchNode = CCSpriteBatchNode:create(self.batchNodePath .. ".png");
    self:addChild(batchNode);
    self.coinBatchNode = batchNode;

    --print("create CoinPool");
    for i = 1, GOLD_COIN_PRE_CREATE_CACHE_COUNT do
        self:_createCoin();
    end 
end

-- 創造物件
function EmitGold:_createCoin()
    local node = CCSprite:create();
    node:setTexture(self.coinBatchNode:getTexture());
    self.coinBatchNode:addChild(node);
    local coin = EmitGold.createAnimtor(self.framAnimKey, self.framAnimTotal - 1, 0.8/self.framAnimTotal)
    coin:setCascadeOpacityEnabled(true)
    coin:setCascadeOpacityEnabledRecursively(true)
    node:addChild(coin);
    node:setVisible(false);
    node:setContentSize(coin:getContentSize());

    table.insert(self.allCoins, coin)
    table.insert(self.coins, node)
end

-- 取得物件池的金幣
function EmitGold:_getCoinPool()
    local node;
    --需要創新
    if(#self.coins <= 0) then
        --print("add CoinPool");
        for i = 1, GOLD_COIN_ADD_CREATE_CACHE_COUNT do
            self:_createCoin();
        end
    end
    node = clone(self.coins[1]);
    table.remove(self.coins, 1)
    --print("CoinPool", #self.coins);
    node:setVisible(true);
    return node;
end

function EmitGold.createAnimtor(imgName, count, speed, isRepeat)
    if isRepeat == nil then
        isRepeat = true
    end
    local sharedSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache(); 
    local sprite = CCSprite:createWithSpriteFrameName(imgName .. "00.png")
    sprite:setAnchorPoint(0.5, 0)
    local animation = CCAnimation:create()
	local number, name
    for i = 0, count do
		if i < 10 then
			number = "0"..i
		else
			number = i
		end
        name = imgName .. number .. ".png"
        animation:addSpriteFrame(sharedSpriteFrameCache:spriteFrameByName(name))
    end 
    animation:setDelayPerUnit(speed)
    animation:setRestoreOriginalFrame(false)
    local action = CCAnimate:create(animation)
    if isRepeat then 
        local repeatAction = CCRepeatForever:create(action)
        sprite:runAction(repeatAction)
    else
        sprite:runAction(action) 
        animation:setRestoreOriginalFrame(false)
    end
     
    return sprite
end

return EmitGold