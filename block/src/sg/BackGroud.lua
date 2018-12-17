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


return BackGroud