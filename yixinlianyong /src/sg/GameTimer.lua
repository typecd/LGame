local GameTimer = class("GameTimer",function() 
    return display.newColorLayer(ccc4(0,0,0,0))
end)

function GameTimer.show(time,interval,callback)
    local layer = GameTimer.new(time,interval,callback)
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer,100)

end

function GameTimer:ctor(time,interval,callback)

    self.time = time
    self.callback = callback
    local labelTime = display.newTTFLabel({
        text = time,
        size = 64,
        color = ccc3(0,0,0),
    })
    labelTime:addTo(self)
    labelTime:pos(display.cx,display.cy)
    self.labelTime = labelTime

    self.upSchedu = scheduler.scheduleGlobal(handler(self,self.update),interval)
    self:registerScriptTouchHandler(function(event,x,y) 
        if event == "began" then
            print("GameTimer began")
            return true
        end
    end,false,-127,true) 
    self:setTouchEnabled(true)
end

function GameTimer:update(dt)

    self.time = self.time - 1

    if self.time <= 0 and self.upSchedu then
        scheduler.unscheduleGlobal(self.upSchedu)
        self.upSchedu = nil
        self.callback()
        self:removeFromParentAndCleanup(true)
        return
    end

    self.labelTime:setString(self.time)

end


return GameTimer