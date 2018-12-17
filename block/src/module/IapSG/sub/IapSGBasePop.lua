local IapSGConfig = require("module/IapSG/sub/IapSGConfig")
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

return IapSGBasePop
