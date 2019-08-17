local LayerBase = require("sg/LayerBase")
local GameScene = class("GameScene", LayerBase)

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

    self:registerScriptTouchHandler(
        function(event, x, y)
            if event == "began" then
                self:touchBegan(x, y)
                return true
            elseif event == "ended" then
                self:touchEnded(x, y)
            end
        end,
        false,
        -127,
        true
    )
    self:setTouchEnabled(true)

    self.gateData = CONFIG.gateData[CONFIG.gate]
    
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


-- 背景
function GameScene:showBg()
    --- TODO
    -- 左下为 1,1
    local margin_left = 0
    if BA.IS_IPHONEX then
        margin_left = 40
    end
    local node = display.newNode()
    node:addTo(self)
    node:pos(40 + margin_left, display.cy - 590/2 + 20)
    self.oprateNode = node

    local bgArr = {}
    local bgSize = 62
    self.bgSize = bgSize
    for col = 1, 10 do
        local colArr = {}
        for row = 1, 10 do
            local bg_spr = display.newSprite(IMG_PATH .. "bg_item_small.png")
            bg_spr:addTo(node)
            bg_spr:pos((col - 1) * bgSize, (row - 1) * bgSize)
            table.insert(colArr, bg_spr)
        end
        table.insert(bgArr, colArr)
    end
    self.bgArr = bgArr
    

    self.backupCharsArr = {} -- 所有备选的文字
    self.backupBtnArr = {} -- 所有备选按钮
    self.labeCharArr = {}  -- 添加到btn上到文字label
    self.btnArr = {} -- 所有按钮

    local charPosArr = {}  -- 显示文字的位置,在添加过程中保证只添加一次
    -- 判断那个位置有字 那些位置为空白
    for k, v in ipairs(self.gateData) do 
        -- 有字的位置添加按钮 可见字的位置不能点击
        -- 拆分pos
        -- local posArr = self:splitPos(v.pos)
        local index = 1
        for i, p in ipairs(v.pos) do
            if not self:posInTable(charPosArr, p) then
                 
                local btn_item = display.newButton({
                    normal = IMG_PATH .. "kong1_small.png",
                    pressed = IMG_PATH .. "kong1_small.png",
                    delegate = self,
                    callback = self.onItemHandler,
                    tag = p[1] .. "," .. p[2]
                })
                btn_item:pos(p[1] * bgSize, p[2] * bgSize)
                btn_item:addTo(node)
                -- btn_item.tag = p[1] .. "," .. p[2]
                self.btnArr[p[1] .. "," .. p[2]] = btn_item

                if v.vis[i] == 1 then
                    local text = display.newTTFLabel({
                        text = v.term:sub(index, index + 2),
                        size = 28,
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

    self.focusSpr = display.newSprite(IMG_PATH .. "focus_small.png")
    self.focusSpr:addTo(self.oprateNode)
    -- self.focusSpr:setVisible(false)

    for k, v in pairs(self.btnArr) do
        if not v.original then
            self.currTag = v.data
            self.focusSpr:pos(v:getx(), v:gety())
            break
        end
    end

    self:addBackupChars()

end

-- 显示备选文字
function GameScene:addBackupChars()
    --- TODO
    local rows = #self.backupCharsArr/6

    for k, v in ipairs(self.backupCharsArr) do
        local btn_backup = display.newButton({
            normal = IMG_PATH .. "optionItem.png",
            pressed = IMG_PATH .. "optionItem.png",
            delegate = self,
            callback = self.onBackupHandler,
            label = v,
            tag = "tag_" .. k
        })
        btn_backup:addTo(self.oprateNode)
        btn_backup:pos(self.bgSize * 10 + 40 + (k - 1)%6 * 75 , 275 + (rows/2 - math.floor((k-1)/6)) * 75)
        self.backupBtnArr["tag_" .. k] = btn_backup
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
        local mask = display.newSprite(IMG_PATH .. "mask.png")
        mask:addTo(btn)
        mask:setTag(1000)
        -- 目标btn
        
        local label = display.newTTFLabel({
            text = char,
            size = 28,
        })
        label.originalPos = {btn:getx(), btn:gety()}
        label.tagPos = {btn_tag:getx(), btn_tag:gety()}
        label.tag = tag  -- 寻找backupbtn


        -- 保存label
        self.labeCharArr[self.currTag] = label
        btn.labelTag = self.currTag

        label:addTo(self.oprateNode)
        label:pos(btn:getx(), btn:gety())
        label:runAction(CCMoveTo:create(0.1, ccp(btn_tag:getx(), btn_tag:gety())))

        -- 移动focusSpr
        self:findTagAndMoveFocusSpr()
    else
        -- 已经有遮罩,找到对应label移除 并移除再移除mask
        btn.masked = false

        local label = self.labeCharArr[btn.labelTag]
        self:labelMoveToBackup(label)
        self.currTag = btn.labelTag
        local pos = string.split(self.currTag, ",")
        self.focusSpr:runAction(CCMoveTo:create(0.1, ccp(pos[1] * self.bgSize, pos[2] * self.bgSize)))
        self.labeCharArr[btn.labelTag] = nil
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

    if btn.red then
        -- 
    end
    
    
    local label = self.labeCharArr[tag]
    if label and not btn.original then -- 当前按钮有字 但不是原始内容
        -- label 移除
        self:labelMoveToBackup(label)
        self.labeCharArr[tag] = nil
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

    self.currTag = tag

    -- 初始带字
    if btn.original then
        print("原始内容")
        return
    end

    self:scaleAndReverce(btn, 1.05)


end

function GameScene:findTagAndMoveFocusSpr()
    --- TODO
    --- 根据当前currTag找到对应对成语第一个空位,并确定当前移动对方向，同一个方向优先寻找
    local currPos = string.split(self.currTag, ",")
    currPos = {tonumber(currPos[1]), tonumber(currPos[2])}
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
            local tag = v[1] .. "," .. v[2]
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



    -- 当前词语已经填满 找一个新位置
    for k, v in ipairs(self.gateData) do
        for i, pos in ipairs(v.pos) do
            local tag = pos[1] .. "," .. pos[2]
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
            local tag = v[1] .. "," .. v[2]
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

-- "5,9;6,9;7,9;8,9"
function GameScene:splitPos(posStr)
    --- TODO
    print(posStr)
    local posTable = string.split(posStr, ";")
    local posArr = {}
    for k,v in ipairs(posTable) do
        table.insert(posArr,string.split(v, ","))
    end

    return posArr
end



return GameScene
