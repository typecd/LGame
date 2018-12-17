local IapSGConfig = require("module/IapSG/sub/IapSGConfig")
local IapSGBasePop = require("module/IapSG/sub/IapSGBasePop")

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

return IapSGSuccessPop