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
    local btn = self.backupBtnArr[tag]
    local char = btn.labelNormal:getString()
    print(char)

    -- 添加一个遮罩

    -- 移动 foucsSpr
    print("currTag",self.currTag)
    


    -- 目标btn
    local btn_tag = self.btnArr[self.currTag]
    
    local label = display.newTTFLabel({
        text = char,
        size = 28,
    })

    label:addTo(self.oprateNode)
    label:pos(btn:getx(), btn:gety())
    
    label:runAction(CCMoveTo:create(0.2, ccp(btn_tag:getx(), btn_tag:gety())))

end

-- 判断区按钮点击
function GameScene:onItemHandler(tag)
    --- TODO
    print(tag)
    if self.currTag == tag then
        return
    end
    
    local btn = self.btnArr[tag]
    local label = btn:getChildByTag(1000)
    if label then
        print(label:getString())
        self:scaleAndReverce(label, 1.15)
    end

    self.focusSpr:runAction(CCMoveTo:create(0.1, ccp(btn:getx(), btn:gety())))

    -- 初始带字
    if btn.original then
        print("原始内容")
        return
    end

    self:scaleAndReverce(btn, 1.05)

    self.currTag = tag

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

function GameScene:posInTable(table, pos)
    --- TODO
    for k, v in ipairs(table) do
        if v[1] == pos[1] and v[2] == pos[2] then
            return true
        end
    end
    
    return false
end

return GameScene
