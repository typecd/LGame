local ChoiceList = class("ChoiceList",function()
	return display.newNode();
end)

local MY_PRIORITY = -128;

function ChoiceList.show(parent, pos, params)
    local cl = ChoiceList.new(params)
    cl:addTo(parent)
    cl:pos(pos.x, pos.y)
    return cl;
end

-- 参数
-- callback 回调函数（选择结果从回调参数返回）
-- data     列表数据
function ChoiceList:ctor(params)
    params.callback = params.callback or function()end
    self.cnt = params.data or {}
    self.callback = params.callback
    self.hasTouch = false
    self.bgHeight = params.bgHeight;

    if #self.cnt > 0 then
        self:createUI()
    end
end

function ChoiceList:createUI()
    local layer = display.newColorLayer(ccc4(0,0,0,0))
    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(function(event, posX, posY)
        if event == "began" then
            return self:touchBegan(posX, posY)
        else
            if self and self.touchEnded then
                self:touchEnded(posX, posY) 
            end
        end
    end, false, MY_PRIORITY, true)
    layer:addTo(self)
    self.layer = layer

    local infoBg = display.newScale9Sprite(BASE_IMAGE_EXCHANGE .. "info_bg.png")
    infoBg:setContentSize(CCSizeMake(285, self.bgHeight))
    infoBg:addTo(layer)
    infoBg:setAnchorPoint(ccp(0.5, 1));
    self.infoBg = infoBg

    local listV = ListView.new({
        size = infoBg:size(),
        cellSize = function ()
            -- return infoBg:size().height / 6, 0
            return 54, 0
        end,
        cellCount = function ()
            return #self.cnt
        end,
        getCell = function(...) self:getCell(...) end,
        cellTouched = function(...) self:cellTouched(...) end,
        priority = MY_PRIORITY
    })
    listV:addTo(infoBg)
end

function ChoiceList:touchBegan(x, y)
    local pos = self.layer:convertToNodeSpace(ccp(x, y))
    self.hasTouch = self.infoBg:boundingBox():containsPoint(pos)
    return true
end

function ChoiceList:touchEnded(x, y)
    local pos = self.layer:convertToNodeSpace(ccp(x, y))
    if not self.infoBg:boundingBox():containsPoint(pos) and not self.hasTouch then
        self.callback()
        self:removeFromParentAndCleanup(true)
    end
end

function ChoiceList:getCell(tableV, cell, idx)
    local cellSize = self.infoBg:size()
    cellSize.height = 54;
    
    local name = display.newTTFLabel({
        text = self.cnt[idx + 1],
        color = COLOR.WHITE,
        size = 24
    })
    name:setPosition(ccp(cellSize.width / 2, cellSize.height / 2))
    name:addTo(cell)

    local div = display.newSprite(BASE_IMAGE_EXCHANGE .. "info_div.png")
    div:pos(name:x(), div:size().height / 2)
    div:addTo(cell)
end

function ChoiceList:cellTouched(table, cell)
    self.callback(self.cnt[cell:getIdx() + 1])
    self:removeFromParentAndCleanup(true)
end

return ChoiceList