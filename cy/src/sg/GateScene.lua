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

    self.btnArr = {}

    local row = 4
    local col = 8
    for i = 1, row*col - 5 do
        local btn = display.newButton({
            normal = CONFIG.IMG_PATH .. "btn_passed.png",
            pressed = CONFIG.IMG_PATH .. "btn_passed.png",
            delegate = self,
            callback = self.onButtonHandler,
            label = tostring(i),
            labelSize = 60,
            labelColor = ccc3(27, 74, 80),
            tag = tostring(i),
        })
        btn:scale(0)
        btn:addTo(btn_node)
        btn:pos(((i-1)%col - (col-1)/2) * 100, ((row-1)/2 - math.modf((i-1)/col)) * 100)

        local colTable = self.btnArr[(i-1)%col + 1]
        if not colTable then
            colTable = {}
            table.insert(self.btnArr, colTable)    
        end
        table.insert(colTable, btn)
    end

    self.tbl_ani_index = {}
    for i = 1, row + col - 1 do
        local t =self:getBtns(i, row, col)
        table.insert(self.tbl_ani_index, t)
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
    local action = transition.sequence({
        transition.newEasing(mt, "CCEaseElasticOut", 0.3),
        CCCallFunc:create(function() 
            self:startBtnAni()
        end)
    })
    self.bg_gate:runAction(action)

    
end


function GateScene:startBtnAni()
    --- TODO
    self.updateAni = scheduler.scheduleGlobal(handler(self, self.updateBtnAni), 0.1)
end

function GateScene:updateBtnAni(dt)
    --- TODO
    local t_index = table.remove(self.tbl_ani_index, 1)

    for _, v in ipairs(t_index) do
        local act = transition.sequence({
            CCScaleTo:create(0.5, 0.6, 0.6),
            CCScaleTo:create(0.1, 0.5, 0.5)
        })
        local btn = self.btnArr[v[1]][v[2]]
        if btn then
            btn:runAction(act)
        end
    end


    if #self.tbl_ani_index == 0 then
        scheduler.unscheduleGlobal(self.updateAni)
    end
end


function GateScene:onExit()
    scheduler.unscheduleGlobal(self.updateSchedule)

end

function GateScene:update(dt)
    
end

--[[
    获取相同时间执行动作的对象
    rows 总行数
    cols 总列数
    index - 取值范围row + col - 1
]]
function GateScene:getBtns(index, rows, cols)
    --- TODO
    -- y = x + index -- 
    local tbl_index = {}
    for x = 0, index - 1 do
        local y = x - (index - 1)
        if -y < rows and x < cols  then
            print(x, y)
            y = math.abs(y)
            table.insert(tbl_index, {x + 1, y + 1})
        end
    end
    
    return tbl_index
end


function GateScene:onButtonHandler(tag)
    print("tag", tag)
    if tag == "" then
    elseif tag == "flag" then

    end
    
    GateScene.super.onButtonHandler(self, tag)

end


return GateScene