local IapSGConfig   = require("module/IapSG/sub/IapSGConfig")
local IapSGBasePop  = require("module/IapSG/sub/IapSGBasePop")
local IapSGHelper   = require("module/IapSG/sub/IapSGHelper")

local IapSGStorePop = class("IapSGStorePop", IapSGBasePop)


IapSGStorePop.TAG = {
    BUTTON_CLOSE  = 100,
}

IapSGStorePop.ZORDER = 800

IapSGStorePop.TOUCH_PRIORITY = {
    BUTTON = IapSGBasePop.TOUCH_PRIORITY_BASE - 1,
    TABLE  = IapSGBasePop.TOUCH_PRIORITY_BASE - 1
}

function IapSGStorePop.show( ... )
    local store = IapSGStorePop.new(IapSGConfig.DEFAULT_CONFIG.STORE.LAYER_COLOR)
    store:setPosition(IapSGConfig.VISIBLE_CENTER)
    CCDirector:sharedDirector():getRunningScene():addChild(store, IapSGStorePop.ZORDER)
end

function IapSGStorePop:ctor()
    IapSGStorePop.super.ctor(self)
    self:setSwallowTouch(true)
    self:_initUI()
end

function IapSGStorePop:_initUI()
    -- bg
    local bgSP = display.newColorLayer(ccc4(255,130,84,255))  --display.newSprite(IapSGConfig.RESOURCE_PATH .. IapSGConfig.DEFAULT_CONFIG.STORE.BG)
    -- bgSP:setPosition(IapSGConfig.VISIBLE_CENTER);
    self._bgSP = bgSP
    self:addChild(bgSP);
    local title = display.newSprite(IapSGConfig.RESOURCE_PATH .. "shop.png")
    title:pos(display.cx,display.height )
    title:setAnchorPoint(ccp(0.5,1))
    self:addChild(title)

    local bgSize  = bgSP:size()
    -- close button
    local closeButton = display.newButton({
        normal   = IapSGConfig.RESOURCE_PATH .. IapSGConfig.DEFAULT_CONFIG.STORE.CLOSE_BUTTON.IMAGE,
        tag      = IapSGStorePop.TAG.BUTTON_CLOSE,
        delegate = self,
        priority = IapSGStorePop.TOUCH_PRIORITY.BUTTON,
        callback = IapSGStorePop.onButtonClick
    });
    local pos = IapSGConfig.DEFAULT_CONFIG.STORE.CLOSE_BUTTON.POS
    if pos == "CENTER" then
        pos = ccp(bgSize.width / 2,closeButton:getContentSize().height / 2 + 20)
    elseif pos == "RIGHT" then
        pos = ccp(bgSize.width - closeButton:getContentSize().width / 2
            ,bgSize.height - closeButton:getContentSize().height / 2)
    end    
    closeButton:setPosition(pos);
    bgSP:addChild(closeButton);
    -- items
    
    local tableConfig = IapSGConfig.DEFAULT_CONFIG.STORE.TABLE

    local tableView   = CCTableView:create(tableConfig.TABLE_SIZE);

    tableView:setPosition(ccp(bgSize.width / 2 - tableConfig.TABLE_SIZE.width / 2
        ,bgSize.height / 2 - tableConfig.TABLE_SIZE.height / 2))
    tableView:setDirection(kCCScrollViewDirectionVertical)
    tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    tableView:setTouchPriority(IapSGStorePop.TOUCH_PRIORITY.TABLE)

    tableView:registerScriptHandler(IapSGStorePop._cellSizeForTable, CCTableView.kTableCellSizeForIndex);
    tableView:registerScriptHandler(IapSGStorePop._tableCellAtIndex, CCTableView.kTableCellSizeAtIndex);
    tableView:registerScriptHandler(IapSGStorePop._numberOfCellsInTableView, CCTableView.kNumberOfCellsInTableView);
    tableView:reloadData();  

    tableView:addTo(bgSP) 

end


function IapSGStorePop._cellSizeForTable(tableView, idx)
    return IapSGConfig.DEFAULT_CONFIG.STORE.TABLE.CELL_HEIGHT,tableView:getContentSize().width
end

function IapSGStorePop._numberOfCellsInTableView(tableView)
    return math.ceil(#IapSGConfig.DEFAULT_CONFIG.STORE.TABLE.CELL_DATA / IapSGConfig.DEFAULT_CONFIG.STORE.TABLE.COL)
end


function IapSGStorePop._tableCellAtIndex(tableView, idx)
    local cell = tableView:dequeueCell();
    
    if not cell then
        cell = CCTableViewCell:new();
    else
        cell:removeAllChildrenWithCleanup(true)
    end

    IapSGStorePop._renderCell(cell,idx)

    return cell;
end

function IapSGStorePop._renderCell( cell,idx )

    local tableConig = IapSGConfig.DEFAULT_CONFIG.STORE.TABLE

    local colWidth,startX,startY = tableConig.TABLE_SIZE.width / tableConig.COL,0,0
    for i = 1,tableConig.COL do
        local dataIndex = idx*tableConig.COL + i
        local data = tableConig.CELL_DATA[dataIndex];
        if data then
            print(dataIndex)
            local itemButton = display.newButton({
                normal   = IapSGConfig.RESOURCE_PATH .. data.IMAGE,
                tag      = dataIndex,
                delegate = self,
                priority = IapSGStorePop.TOUCH_PRIORITY.BUTTON,
                callback = IapSGStorePop.onButtonClick
            });
            startX = colWidth*(i - 1) + colWidth / 2
            startY = itemButton:size().height / 2
            itemButton:setPosition(ccp(startX,startY))
            cell:addChild(itemButton)
        end
    end 

end

--处理触摸事件
function IapSGStorePop:_onTouch(event, x, y)

    local pos  = self:convertToNodeSpace(ccp(x, y))
    local pos1  = self._bgSP:convertToNodeSpace(ccp(x, y))
    local rect = CCRect(0,0,self._bgSP:getContentSize().width,self._bgSP:getContentSize().height)
    if event == "began" then
        if self._touchRect:containsPoint(pos) then
            if not rect:containsPoint(pos1) and IapSGConfig.DEFAULT_CONFIG.STORE.CLOSE_BUTTON.CLOSE_BY_TOUCH then
                self:removeFromParentAndCleanup(true)
            end 
            return self._swallow
        end 
    elseif event == "ended" then     
    elseif event == "moved" then
    end
    
    return false
end

--处理按钮事件
function IapSGStorePop:onButtonClick(tag)
    IapSGStorePop.super.onButtonClick(self,tag)

    if tag == IapSGStorePop.TAG.BUTTON_CLOSE then
        self:removeFromParentAndCleanup(true)
    else
        if type(tag) == 'number' then
            local config = IapSGConfig.DEFAULT_CONFIG.STORE.TABLE.CELL_DATA[tag]
            IapSGHelper:getInstance():startPay(config.ITEM_NO,config.COUNT)
        end

    end
end

return IapSGStorePop