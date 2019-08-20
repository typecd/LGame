local LayerBase = require("sg/LayerBase")
local GameScene = class("GameScene", LayerBase)

local ConfirmBuyView = require("sg/ConfirmBuyView")

function GameScene.show()
    local layer = GameScene.new()

    local scene = CCScene:create()
    scene:setNodeEventEnabled(true)
    scene:addChild(layer)
    local transition = display.wrapSceneWithTransition(scene, "crossFade", 0.5)
    display.replaceScene(transition)
end

function GameScene:ctor()
    GameScene.super.ctor(self)

    -- self:registerScriptTouchHandler(
    --     function(event, x, y)
    --         if event == "began" then
    --             self:touchBegan(x, y)
    --             return true
    --         elseif event == "ended" then
    --             self:touchEnded(x, y)
    --         end
    --     end,
    --     false,
    --     -127,
    --     true
    -- )
    -- self:setTouchEnabled(true)

    self.gateData = CONFIG.gateData[CONFIG.gate]
    
    local btn_back = display.newButton({
        normal = CONFIG.IMG_PATH .. "btn_back_1.png",
        pressed = CONFIG.IMG_PATH .. "btn_back_2.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "back"
    })
    btn_back:addTo(self, 2)

    local margin_left = 0
    if BA.IS_IPHONEX then
        margin_left = 40
    end
    self.margin_left = margin_left

    local bgSize = 50
    self.bgSize = bgSize


    btn_back:pos(40 + margin_left, display.height - 35)

    self:addSoundBtn({150 + margin_left, display.height - 35})

    -- 提示标示
    local tip_spr = display.newSprite(CONFIG.IMG_PATH .. "tip.png")
    tip_spr:addTo(self)
    tip_spr:pos(40 + margin_left, 30)

    local btn_reset = display.newButton({
        normal = CONFIG.IMG_PATH .. "btn_reset.png",
        pressed = CONFIG.IMG_PATH .. "btn_reset.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "reset",
    })

    btn_reset:addTo(self)
    btn_reset:pos(465 + margin_left, 30)

    -- 关卡
    local spr_gate = display.newSprite(CONFIG.IMG_PATH .. "gate.png")
    spr_gate:pos(display.cx, display.height - 35)
    spr_gate:addTo(self)

    local lb_gate = CONFIG.createBMFont(CONFIG.gate, CONFIG.IMG_PATH .. "gate_fnt.fnt")
    lb_gate:addTo(spr_gate)
    lb_gate:pos(83.5, 30)
    self.lb_gate = lb_gate

    local spr_coin = display.newSprite(CONFIG.IMG_PATH .. "coin_bg.png")
    spr_coin:addTo(self)
    spr_coin:pos(display.width - 150, display.height - 35)
    local lb_coin = CONFIG.createBMFont(CONFIG.diamond, CONFIG.IMG_PATH .. "coin_fnt.fnt")
    lb_coin:addTo(spr_coin)
    lb_coin:pos(100, 32)


    local btn_adTip = display.newButton({
        normal = CONFIG.IMG_PATH .. "btn_adtip.png",
        pressed = CONFIG.IMG_PATH .. "btn_adtip.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "adtip"
    })
    btn_adTip:addTo(self)
    btn_adTip:scale(0.6)
    btn_adTip:pos(40 + self.margin_left + self.bgSize * 10 + 50, 35)
    
    local btn_tip = display.newButton({
        normal = CONFIG.IMG_PATH .. "btn_tip.png",
        pressed = CONFIG.IMG_PATH .. "btn_tip.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "tip"
    })
    btn_tip:addTo(self)
    btn_tip:scale(0.6)
    btn_tip:pos(display.cx + (40 + self.margin_left + self.bgSize * 10 + 50)/2 - 25, 35)

    local btn_jieshi = display.newButton({
        normal = CONFIG.IMG_PATH .. "btn_jieshi.png",
        pressed = CONFIG.IMG_PATH .. "btn_jieshi.png",
        delegate = self,
        callback = self.onButtonHandler,
        tag = "jieshi"
    })
    btn_jieshi:addTo(self)
    btn_jieshi:scale(0.6)
    btn_jieshi:pos(display.width - 60, 35)

    local scrollView = CCScrollView:create()
    scrollView:setViewSize(CCSizeMake(350, 40))
    scrollView:pos(60 + self.margin_left, 15)
    scrollView:ignoreAnchorPointForPosition(true)
    scrollView:setDirection(kCCScrollViewDirectionHorizontal)
    scrollView:setClippingToBounds(true)
    scrollView:setBounceable(false)
    scrollView:addTo(self, 2)
    -- local lb_mean = display.newTTFLabel({
    --     text = "把赤诚的心交给人家。比喻真心待人。",
    --     size = 24
    -- })
    -- print("sz ", lb_mean:getSize().width)
    -- lb_mean:pos(300, 0)
    -- scrollView:setContentSize(CCSizeMake(lb_mean:getSize().width + 340 + 300, 40))
    -- scrollView:addChild(lb_mean)

    -- scrollView:setContentOffset(ccp(0, 0))

    self.scrollView =scrollView
    self:showBg()
   

end

function GameScene:touchBegan(x, y)
    self.touchBeganX = x
    self.touchBeganY = y
end


function GameScene:touchEnded(x, y)

end

function GameScene:_onEnter()

end


function GameScene:_onExit()
    self.super._onExit(self)

    
end

function GameScene:startShowMean()
    --- TODO
     -- 当前关卡以及开通词语解释
    if not CONFIG.meanTags[CONFIG.gate] then
        print("功能未开放")
        return
    end
    local str = self:getMeanData(self.currTag)
    if str == self.currMean then
        print("mean 未变化")
        return
    end
    if self.lb_mean then
        self.lb_mean:removeSelf()
    end

    local lb_mean = display.newTTFLabel({
        text = str,
        size = 24
    })
    self.lb_mean = lb_mean
    self.currMean = str
    self.scrollView:addChild(lb_mean)

    self.currOffset = 0 
    self.scrollView:setContentOffset(ccp(0, 0))
    
    if self.updateLabel then
        scheduler.unscheduleGlobal(self.updateLabel)
        self.updateLabel = nil
    end

    local lb_w = lb_mean:getSize().width 
    if lb_w > 350 then
        print("lb_w", lb_w)
        self.scrollView:setContentSize(CCSize(lb_w + 650, 40))
        lb_mean:pos(300, 0)

        self.maxOffset = lb_w + 300

         -- 每帧更新scorllView的offset
        self.updateLabel = scheduler.scheduleUpdateGlobal(handler(self, self.updateLabelPos))
    else
        self:setContentSize(CCSize(350, 40))
        
    end


end

-- 背景
function GameScene:showBg()
    --- TODO
    -- 左下为 1,1
    
    local node = display.newNode()
    node:addTo(self)
    local node_y = display.cy - 470/2
    node:pos(40 + self.margin_left, node_y)
    self.oprateNode = node
    
    self.node_y = node_y

    local bgArr = {}

    for col = 1, 10 do
        local colArr = {}
        for row = 1, 10 do
            local bg_spr = display.newSprite(CONFIG.IMG_PATH .. "bg_item_small.png")
            bg_spr:addTo(node)
            bg_spr:pos((col - 1) * self.bgSize, display.height - node_y + 80) --(row - 1) * bgSize)
            table.insert(colArr, bg_spr)
        end
        table.insert(bgArr, colArr)
    end
    self.bgArr = bgArr
    
    self.labelCount = 0
    self.choosedCount = 0
    self.backupCharsArr = {} -- 所有备选的文字
    self.backupBtnArr = {} -- 所有备选按钮
    self.labeCharArr = {}  -- 添加到btn上到文字label
    self.btnArr = {} -- 所有按钮

    local charPosArr = {}  -- 显示文字的位置,在添加过程中保证只添加一次
    -- 判断那个位置有字 那些位置为空白
    for k, v in ipairs(self.gateData) do 
        -- 有字的位置添加按钮 可见字的位置不能点击
        -- 拆分pos
        local index = 1
        for i, p in ipairs(v.pos) do
            if not self:posInTable(charPosArr, p) then
                 
                local btn_item = display.newButton({
                    normal = CONFIG.IMG_PATH .. "kong1_small.png",
                    pressed = CONFIG.IMG_PATH .. "kong1_small.png",
                    delegate = self,
                    callback = self.onItemHandler,
                    tag = self:posToTag(p)
                })
                btn_item:pos(p[1] * self.bgSize, display.height - node_y + 80) -- p[2] * bgSize)
                btn_item:addTo(node)
                -- btn_item.tag = self:posToTag(p)
                self.btnArr[self:posToTag(p)] = btn_item

                if v.vis[i] == 1 then
                    local text = display.newTTFLabel({
                        text = v.term:sub(index, index + 2),
                        size = 26,
                    })
                    text:addTo(btn_item)
                    text:setTag(1000)
                    btn_item.original = true
                    btn_item:setColor(ccc3(0, 255, 0))
                else
                    table.insert(self.backupCharsArr, v.term:sub(index, index + 2))
                end
                
                table.insert(charPosArr, p)
            end

            index = index + 3
        end
    end

    CONFIG.shuffle(self.backupCharsArr)

    self.moveTime = {1, 1.2, 1.5, 1.1, 0.8, 1, 1.3, 1.4, 0.9, 1.1}

    self:addBackupChars()

    self.schedulePos = scheduler.scheduleGlobal(handler(self, self.updatePosition), 0.2)    
    self.showRow = 1

    

    
    
end

function GameScene:updatePosition(dt)
    --- TODO
    for col = 1, 10 do
        self.bgArr[col][self.showRow]:runAction(CCMoveTo:create(self.moveTime[col] - 0.8, ccp((col-1) * self.bgSize, (self.showRow - 1) * self.bgSize)))
        local tag = (col - 1) .. "," .. (self.showRow - 1)
        local btn = self.btnArr[tag]
        if btn then
            btn:runAction(CCMoveTo:create(self.moveTime[col] - 0.8, ccp((col-1) * self.bgSize, (self.showRow - 1) * self.bgSize)))
        end
    end

    self.showRow = self.showRow + 1
    if self.showRow == 11 then
        print(" stop scheduler ")
        scheduler.unscheduleGlobal(self.schedulePos)
        self.schedulePos = nil

        self.focusSpr = display.newSprite(CONFIG.IMG_PATH .. "focus_small.png")
        self.focusSpr:addTo(self.oprateNode)

        for k, v in pairs(self.btnArr) do
            if not v.original then
                self.currTag = v.data
                self.focusSpr:pos(v:getx(), v:gety())
                break
            end
        end

        self:startShowMean()
    end
end

-- 显示备选文字
function GameScene:addBackupChars()
    --- TODO
    local rows = #self.backupCharsArr/6

    for k, v in ipairs(self.backupCharsArr) do
        local btn_backup = display.newButton({
            normal = CONFIG.IMG_PATH .. "optionItem.png",
            pressed = CONFIG.IMG_PATH .. "optionItem.png",
            delegate = self,
            callback = self.onBackupHandler,
            label = v,
            tag = "tag_" .. k
        })
        btn_backup:addTo(self.oprateNode)
        btn_backup:pos(display.cx - (40 + self.margin_left)/2 + self.bgSize * 5 - 75 * 3 + (k - 1)%6 * 75 + 35, 
                display.cy + rows * 75 / 2 - math.floor((k-1)/6) * 75 - self.node_y - 37.5)
        self.backupBtnArr["tag_" .. k] = btn_backup
        btn_backup:scale(0)
        btn_backup:runAction(transition.sequence({
            CCDelayTime:create( self.moveTime[math.random(1, 10)] - 0.5  ),
            CCScaleTo:create(0.2, 1.2, 1.2),
            CCScaleTo:create(0.1, 1, 1)
        }))
    end

end

-- 被选区按钮点击
function GameScene:onBackupHandler(tag)
    --- TODO
    print("backup tag", tag)
    local btn_tag = self.btnArr[self.currTag]
    if btn_tag.original then
        print("原始按钮不能添加")
        return
    end
    
    local btn = self.backupBtnArr[tag]
    if btn.choosed then
        return
    end

    if not btn.masked then
        btn.masked = true
        local char = btn.labelNormal:getString()
        print(char)
        -- 添加一个遮罩
        local mask = display.newSprite(CONFIG.IMG_PATH .. "mask.png")
        mask:addTo(btn)
        mask:setTag(1000)
        -- 目标btn
        
        local label = display.newTTFLabel({
            text = char,
            size = 26,
        })
        label.originalPos = {btn:getx(), btn:gety()}
        label.tagPos = {btn_tag:getx(), btn_tag:gety()}
        label.tag = tag  -- 寻找backupbtn


        -- 保存label
        self.labeCharArr[self.currTag] = label
        btn.labelTag = self.currTag
        self.labelCount = self.labelCount + 1

        label:addTo(self.oprateNode)
        label:pos(btn:getx(), btn:gety())
        label:runAction(CCMoveTo:create(0.1, ccp(btn_tag:getx(), btn_tag:gety())))

        -- 移动focusSpr
        self:findTagAndMoveFocusSpr()

        self:startShowMean()
    else
        -- 已经有遮罩,找到对应label移除 并移除再移除mask
        btn.masked = false

        print(btn.labelTag)

        local label = self.labeCharArr[btn.labelTag]
        print(label)

        self:labelMoveToBackup(label)
        self.labelCount = self.labelCount - 1
        
        self.currTag = btn.labelTag
        local pos = string.split(self.currTag, ",")
        self.focusSpr:runAction(CCMoveTo:create(0.1, ccp(pos[1] * self.bgSize, pos[2] * self.bgSize)))
        self.labeCharArr[btn.labelTag] = nil
        if self.btnArr[self.currTag].red then
            self.btnArr[self.currTag]:setColor(ccc3(255, 255, 255))
        end
    end
    
end

-- 操作区按钮点击
function GameScene:onItemHandler(tag)
    --- TODO
    print(tag)
    local btn = self.btnArr[tag]

    
    if self.currTag == tag then
        print("当前按钮")
        -- 当前按钮没字
        return
    end
    
    self.currTag = tag

   
    self:startShowMean()
    -- end

    -- 取消特殊颜色
    -- 找出tag所在词语,让red按钮颜色还原
    if btn.red then
        local changeData = self:findDataByTag(tag)
        for k, v in ipairs(changeData) do
            for i, pos in ipairs(v.pos) do
                local tag = self:posToTag(pos)
                local btn = self.btnArr[tag]
                if btn.red then
                    btn.red = false
                    btn:setColor(ccc3(255, 255, 255))
                end
            end
        end
    end
    
    
    local label = self.labeCharArr[tag]
    if label and not btn.original then -- 当前按钮有字 但不是原始内容
        -- label 移除
        self:labelMoveToBackup(label)
        self.labeCharArr[tag] = nil
        self.labelCount = self.labelCount - 1
    elseif label and btn.original then
        -- 当前按钮变为原始内容
        self:scaleAndReverce(label, 1.15)
    end

    -- 创建按钮时添加到label
    local label_ori = btn:getChildByTag(1000)
    if label_ori then
        print(label_ori:getString())
        self:scaleAndReverce(label_ori, 1.15)
    end

    self.focusSpr:runAction(
        transition.sequence({
            CCDelayTime:create(0.1),
            CCMoveTo:create(0.1, ccp(btn:getx(), btn:gety()))
        })
    )

    

    -- 初始带字
    if btn.original then
        print("原始内容")
        return
    end

    self:scaleAndReverce(btn, 1.05)


end


-- tag所在词语的数据,通过数据找btn和label
function GameScene:findDataByTag(tag)
    --- TODO
    local pos = self:tagToPos(tag)

    local temp_data = {}
    for k, v in ipairs(self.gateData) do
        if self:posInTable(v.pos, pos) then
            table.insert(temp_data, v)
        end
    end

    return temp_data
end


function GameScene:findTagAndMoveFocusSpr()
    --- TODO
    --- 根据当前currTag找到对应对成语第一个空位,并确定当前移动对方向，同一个方向优先寻找
    local currPos = self:tagToPos(self.currTag)
    -- print("self.currTag", self.currTag)
    -- dump(currPos)
    -- 手动选择了新位置
    if self.currData and not self:posInTable(self.currData.pos, currPos) then
        self.currData = nil
    end

    -- 如果当前需要填充对成语为nil 根据currTag找一个
    if not self.currData  then
        for k, v in ipairs(self.gateData) do
            for i,pos in ipairs(v.pos) do
                if currPos[1] == pos[1] and currPos[2] == pos[2] then
                    self.currData = v
                    break
                end
            end
            if self.currData then
                break
            end
        end        
    end

    -- 在currData中找一个未填字的按钮
    for k, v in ipairs(self.currData.pos) do
        if self.currData.vis[k] == 0 then
            local tag = self:posToTag(v)
            local label = self.labeCharArr[tag]
            if not label then
                self.currTag = tag
                self.focusSpr:runAction(
                    transition.sequence({
                        CCDelayTime:create(0.1),
                        CCMoveTo:create(0.1, ccp(v[1] * self.bgSize, v[2] * self.bgSize))
                    })    
                )
                return
            end
        end
    end

    -- 执行到这时，表示当前词已经填满
    self:isContentComplete(self.currData)
    
    -- 判断currTag 还在不在其他词语中\
    local other_data = {}
    for k, data in ipairs(self.gateData) do
        if data ~= self.currData then
            local pos = self:tagToPos(self.currTag)
            if self:posInTable(data.pos, pos) then
                print("其他词语")
                table.insert(other_data, data)
            end
        end
    end

    for k, v in ipairs(other_data) do
        self:isContentComplete(v)
    end

    print(self.choosedCount , #self.backupCharsArr)
    if self.choosedCount == #self.backupCharsArr then
        print("通关")

        return
    end

    -- 当前词语已经填满 找一个新位置
    for k, v in ipairs(self.gateData) do
        for i, pos in ipairs(v.pos) do
            local tag = self:posToTag(pos)
            if not self.labeCharArr[tag] and v.vis[i] == 0 then
                self.currData = v
                self.currTag = tag
                self.focusSpr:runAction(
                    transition.sequence({
                        CCDelayTime:create(0.1),
                        CCMoveTo:create(0.1, ccp(pos[1] * self.bgSize, pos[2] * self.bgSize))
                    })  
                )
                return 
            end
        end
    end

end


-- 将正确填充的词语设置为特殊颜色，并改变对应backup按钮的显示和点击效果
-- data为当前词语的数据
function GameScene:isContentComplete(data)
    --- TODO
    local strIndex = 1
    local complete = true
    local temp_btn_tag = {}
    local temp_label = {} 
    for k, v in ipairs(data.pos) do
        if data.vis[k] == 0 then
            local tag = self:posToTag(v)
            print("tag", tag)
            local label = self.labeCharArr[tag]
            if label then
                local char = label:getString()
                if char ~= string.sub(data.term, strIndex, strIndex + 2) then
                    complete = false
                    -- break
                end
                table.insert(temp_label, label)
            else
                -- 为填写完
                return
            end
            table.insert(temp_btn_tag, tag)
        end
        strIndex = strIndex + 3
    end

    if complete then
        print("填写正确")
        dump(temp_btn_tag)
        for k, tag in ipairs(temp_btn_tag) do
            local btn = self.btnArr[tag]
            if not btn.original then
                btn:setColor(ccc3(0, 255, 0))
                btn.original = true
                btn.red = false 
            end
        end

        -- 对应的backup按钮文字移除,点击不在有效果
        for k, lb in ipairs(temp_label) do
            local btn_backup = self.backupBtnArr[lb.tag]
            if btn_backup.labelNormal then
                btn_backup.labelNormal:removeSelf()
                btn_backup.labelPressed:removeSelf()
                btn_backup.labelDisabled:removeSelf()
                btn_backup.labelNormal = nil
                btn_backup.labelPressed = nil
                btn_backup.labelDisabled = nil
                self.choosedCount = self.choosedCount + 1
            end
            btn_backup.choosed = true
        end
        -- 添加特效
    else
        -- 不完全正确,没有变成original的btn要变色 错误提示
        for k, tag in ipairs(temp_btn_tag) do
            local btn = self.btnArr[tag]
            if not btn.original then
                btn:setColor(ccc3(255, 0, 0))
                btn.red = true
            end
        end

    end
end


function GameScene:tagToPos(tag)
    --- TODO
    local t = string.split(tag, ",")
    t = {tonumber(t[1]), tonumber(t[2])}
    return t
end

function GameScene:posInTable(table, pos)
    --- TODO
    for k, v in ipairs(table) do
        if pos[1] == v[1] and pos[2] == v[2] then
            return true
        end
    end
    return false
end

function GameScene:labelMoveToBackup(label)
    --- TODO
    -- label 移动到backup btn 
    -- btn 移除遮罩
    local act = transition.sequence({
        CCMoveTo:create(0.2, ccp(label.originalPos[1], label.originalPos[2])),
        CCCallFuncN:create(function(node)
            node:removeSelf()
        end),
        CCCallFuncN:create(function(node) 
            self.backupBtnArr[node.tag]:removeChildByTag(1000, true)
            self.backupBtnArr[node.tag].masked = false
        end)
    })
    label:runAction(act)


end

function GameScene:scaleAndReverce(view, scale)
    --- TODO
    -- view:stop()
    local seq = transition.sequence({
        CCScaleTo:create(0.2, scale, scale),
        CCScaleTo:create(0.2, 1, 1)
    })
    view:runAction(seq)
end


function GameScene:posToTag(pos)
    --- TODO
    local tag = pos[1] .. "," .. pos[2]
    return tag
end


function GameScene:onButtonHandler(tag)
    --- TODO
    print(tag)
    GameScene.super.onButtonHandler(self, tag)
    if tag == "reset" then
        self:resetView()
    elseif tag == "jieshi" then
        ConfirmBuyView.show(self)
    end
end

-- 获取一个位置对应词语的解释
function GameScene:getMeanData(tag)
    --- TODO
    print("mean tag", tag)
    local pos = self:tagToPos(tag)
    -- 0 h水平方向
    -- 1 v
    local mean_table = {}
    for k, ci in ipairs(self.gateData) do
        if self:posInTable(ci.pos, pos) then
            local ori_mean = {}
            if ci.ori == 0 then
                ori_mean[1] = "hm"
            elseif ci.ori == 1 then
                ori_mean[1] = "vm"
            end
            ori_mean[2] = ci.mean
            table.insert(mean_table, ori_mean)
        end
    end

    dump(mean_table)
    local str = ""
    if #mean_table == 2 then
        for k, v in ipairs(mean_table) do
            if v[1] == "hm" then
                str = "[橫向]" .. v[2] .. str
            elseif v[1] == "vm" then
                str = str .. "  [竪向]" .. v[2]
            end
        end
    else
        str = mean_table[1][2]
    end


    return str
end

-- 更新offest
function GameScene:updateLabelPos(dt)
    --- TODO
    self.currOffset = self.currOffset - 2

    self.scrollView:setContentOffset(ccp(self.currOffset, 0))

    if self.currOffset < -self.maxOffset then
        self.currOffset = 0
    end
end


function GameScene:resetView()
    --- TODO

    if self.labelCount <= 0 then
        print("不能resetview", self.labelCount)
        return
    end

    self.focusSpr:removeSelf()
    self.focusSpr = nil


    for i = 1, 10 do 
        CONFIG.removeViewTableByIndex(self.bgArr[i])
    end
    
    self.labelCount = 0 -- 操作区中添加了多少个字 用于判定是否可以reset view
    self.choosedCount = 0 -- 备选区中已经被使用的字个数
    self.backupCharsArr = {} -- 所有备选的文字
    CONFIG.removeViewTableByKeyValue(self.backupBtnArr)
    CONFIG.removeViewTableByKeyValue(self.labeCharArr)
    CONFIG.removeViewTableByKeyValue(self.btnArr)

    if self.lb_mean then
        if self.updateLabel then
            scheduler.unscheduleGlobal(self.updateLabel)
            self.updateLabel = nil
        end
        self.lb_mean:removeSelf()
        self.lb_mean = nil
    end

    self:showBg()
end



return GameScene
