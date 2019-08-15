local ListView = class("ListView",function()
	return display.newNode();
end)

function ListView:ctor(params)
  assert(type(params) == "table","ListView invalid params");
  local size = params.size;
  -- local delegate = params.delegate;
  local cellSize = params.cellSize;
  local getCell = params.getCell;
  local priority = params.priority or (kCCMenuHandlerPriority + 1)
  self.getCell = getCell;
  self.updateCell = params.updateCell
  local cellCount = params.cellCount;
  local cellTouched = params.cellTouched or ListView.tableCellTouched;
 	local table = CCTableView:create(params.size);
  self.table = table;
  local direction = params.direction or kCCScrollViewDirectionVertical
  local fillOrder = params.fillOrder or kCCTableViewFillTopDown
 	table:setDirection(direction);
 	table:setVerticalFillOrder(fillOrder);

  table:registerScriptHandler(cellTouched,CCTableView.kTableCellTouched)
  table:registerScriptHandler(cellSize,CCTableView.kTableCellSizeForIndex)
  table:registerScriptHandler(cellCount,CCTableView.kNumberOfCellsInTableView)  
  -- table:registerScriptHandler(ListView.scrollViewDidScroll,CCTableView.kTableViewScroll)
  -- table:registerScriptHandler(ListView.scrollViewDidZoom,CCTableView.kTableViewZoom)
  table:registerScriptHandler(handler(self, self.tableCellAtIndex),CCTableView.kTableCellSizeAtIndex)

  table:reloadData()
  table:addTo(self);

  table:setTouchEnabled(true);
  table:setTouchPriority(priority);
end 

function ListView.scrollViewDidScroll(view)
    print("scrollViewDidScroll")
end

function ListView.scrollViewDidZoom(view)
    print("scrollViewDidZoom")
end

function ListView.tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function ListView.cellSizeForTable(table,idx) 
    return 160,60
end

function ListView:tableCellAtIndex(table, idx)
    local cell = self.table:dequeueCell()
    if cell == nil then
      cell = CCTableViewCell:new();
      -- cell:autorelease()
      self.getCell(self, cell, idx)
    else
      if self.updateCell then
        self.updateCell(self, cell, idx)
      else
        cell:removeAllChildrenWithCleanup(true);
        self.getCell(self, cell, idx)
      end
    end

    return cell
end

function ListView.numberOfCellsInTableView(table)
   return 10;
end

function ListView:reloadData()
	self.table:reloadData();
end 

function ListView:setTouchEnabled(enable)
    self.table:setTouchEnabled(enable);
end

function ListView:getContentOffset()
    return self.table:getContentOffset()
end

function ListView:setContentOffset(offset)
    self.table:setContentOffset(offset, false)
end

function ListView:addScrollBar(x)
    local gapX = x or 10
    addBarToTable(self.table, self.table:x() + self.table:getViewSize().width - gapX, self.table:y() + self.table:getViewSize().height / 2);
end

return ListView;