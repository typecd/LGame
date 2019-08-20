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
end

function GateScene:onExit()
    scheduler.unscheduleGlobal(self.updateSchedule)
    display.removeAnimationCache("currLevel")
    UITools.removeSpriteFrames(CONFIG.IMG_PATH .. "currlevel")
end

function GateScene:update(dt)
    if self.LevelAniActive then

        if self.hide then
            self.opacity = self.opacity + 5
            if self.opacity >= 255 then
                self.opacity = 255
                self.hide = false
            end
        else
            self.opacity = self.opacity - 5
            if self.opacity <= 0 then
                self.opacity = 0
                self.hide = true
            end
        end
        self.currLevelSpr:setOpacity(self.opacity)
    end
end


function GateScene:createMap()
    for i = 1, self.levelOpened do 
        self:addLevelButton(i)
    end

    -- for i = 1, self.levelOpened - 1 do 
    --     self:addWayPoins(i)
    -- end
end


function GateScene:addLevelButton(index, show)
    if show == nil then 
        show = false
    end
    local currLvl = nil
    if index < 6 then
        currLvl = index + 1
    else
        currLvl = index
    end

    if index == 6 then
        
    elseif index == 13 then
    end

    local btn_flag = display.newButton({
        normal = CONFIG.IMG_PATH .. "scene/flag_10000.png",
        pressed = CONFIG.IMG_PATH .. "scene/flag_10000.png",
        delegate = self,
        callback = self.onFlagHandler,
        tag = index,
        label = tostring(index)
    })
    btn_flag:addTo(self, 1)
    btn_flag:pos(self.flagsPosition[index][1] + display.cx, self.flagsPosition[index][2] + display.cy)
    if show == false then
        self:addStar(btn_flag, index)
    end
    btn_flag.numLevel = currLvl
    -- self.btn_flag = btn_flag
end


function GateScene:onFlagHandler(tag)
    print("flag: ",tag)
    CONFIG.gateData = GateData.new(tag)
    CONFIG.currGate = tag
    CONFIG.changeScene("gameScene", self)
    CONFIG.playEffect("mouse_click")
end


-- 添加star
function GateScene:addStar(btn_flag, level)
    -- 从本地数据获取star
    local count = 0
    local gate = CONFIG.getPassGate(level)
    if gate then
        count = gate.score
    end
    for i = 1, count do 
        local spr = display.newSprite(CONFIG.IMG_PATH .. "scene/star_10000.png")
        spr:pos(self.posStar[i][1], self.posStar[i][2])
        spr:rotation(self.posStar[i][3])
        local z = 0
        if i == 2 then
            z = 1
        end
        btn_flag:addChild(spr, z)
    end
    if count == 0 then
        self.currLevelSpr:setVisible(true)
        self.currLevelSpr:pos(btn_flag:getx() + 2, btn_flag:gety())
        self.LevelAniActive = true
        self.currAniSpr:setVisible(true)
        self.currAniSpr:pos(btn_flag:getx() + 2, btn_flag:gety() - 30)
        transition.playAnimationForever(self.currAniSpr, display.getAnimationCache("currLevel"))
    end
end


function GateScene:addWayPoins(index)

end



function GateScene:onButtonHandler(tag)
    if tag == "" then
    elseif tag == "flag" then

    end
    
    GateScene.super.onButtonHandler(self, tag)

end


return GateScene