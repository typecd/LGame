local IapSGConfig = require("module/IapSG/sub/IapSGConfig")
local IapSGBasePop = require("module/IapSG/sub/IapSGBasePop")

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

return IapSGFailPop