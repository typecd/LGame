local LayerBase = require("sg/LayerBase")
local GateScene = class("GateScene",LayerBase)

local GateData = require("sg/GateData")

function GateScene.show()
    local layer = GateScene:new()
    local scene = CCScene:create()
    scene:setNodeEventEnabled(true)
    scene:addChild(layer)
    local transition = display.wrapSceneWithTransition(scene, "crossFade", 0.5)
    display.replaceScene(transition)

end


function GateScene:ctor()

    local bg = display.newSprite(CONFIG.IMG_PATH .. "bg.png")
    bg:addTo(self)
    bg:pos(display.cx, display.cy)

    local bg_bottom = display.newSprite(CONFIG.IMG_PATH .. "bg_bottom.png")
    bg_bottom:addTo(self)
    bg_bottom:pos(display.cx, bg_bottom:getSize().height/2)

    local bg_gate = display.newSprite(CONFIG.IMG_PATH .. "bg_gate.png")
    bg_gate:addTo(self)
    bg_gate:pos(display.cx, display.height + bg_gate:getSize().height/2)
    self.bg_gate = bg_gate

    local btn_node = display.newNode()
    btn_node:addTo(self)
    btn_node:center()

    local row = 4
    local col = 6
    for i = 1, row*col do
        local btn = display.newButton({
            normal = CONFIG.IMG_PATH .. "btn_passed.png",
            pressed = CONFIG.IMG_PATH .. "btn_passed.png",
            delegate = self,
            callback = self.onButtonHandler,
            tag = "tag",
        })
        btn:scale(0.5)
        btn:addTo(btn_node)
        btn:pos(((i-1)%col - (col-1)/2) * 100,  ((row-1)/2 - math.modf((i-1)/col)) * 100)

    end

    self:registerScriptHandler(function(event) 
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)

end


function GateScene:onEnter()
    
    self.updateSchedule = scheduler.scheduleUpdateGlobal(handler(self, self.update))
    local mt = CCMoveTo:create(1.2, ccp(display.cx, display.cy))
    local action = transition.newEasing(mt, "CCEaseElasticOut", 0.3)
    self.bg_gate:runAction(action)



end

function GateScene:onExit()
    scheduler.unscheduleGlobal(self.updateSchedule)

end

function GateScene:update(dt)
    
end



function GateScene:onButtonHandler(tag)
    if tag == "" then
    elseif tag == "flag" then

    end
    
    GateScene.super.onButtonHandler(self, tag)

end


return GateScene