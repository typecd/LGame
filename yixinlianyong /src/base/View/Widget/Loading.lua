local Loading = class("Loading",function()
	return display.newLayer();
end);
local LOAD_TAG = 888;

--[[创建 Loading Loading:showLoading，删除 Loading Loading:removeLoading

可用参数：

-    delay: 延时显示
-    text: loading 显示文字
-	 during: loading 时间
-    callback: 到时间后的回调
-    Vertical 是否竖屏 默认 false 
]]--
function Loading:ctor(params)
	self:setNodeEventEnabled(true);
	if params and params.delay then
		self:performWithDelay(function()
			self:show(params);
		end, params.delay);
	else
		self:show(params or {});
	end
end

function Loading:show(params)
	local text = params.text or "connecting..."
	local during = params.during or 10;

	local layer = display.newLayer();
	layer:setTouchEnabled(true);
	layer:registerScriptTouchHandler(function()
		return true;
	end, false, -140, true)
	self:addChild(layer);

	local bg = display.newScale9Sprite(BASE_IMAGE .. "load_bg.png");
	bg:pos(display.cx, display.cy)
	bg:addTo(self);



	local flower = display.newSprite(BASE_IMAGE .. "load_flower.png");
	flower:addTo(self);

	self.scheduler = scheduler.scheduleGlobal(function()
		local rotation = flower:getRotation()
		flower:setRotation(rotation + 30);
	end, 0.05);

	local content = display.newTTFLabel({text = text})
	content:addTo(self);

	local width = flower:size().width + content:size().width + 60;
	local height = math.max(content:size().height + 30 , 61);
	bg:setContentSize(CCSizeMake(width, height));
	flower:pos(display.cx - width/2 + flower:size().width, display.cy);
	content:pos(display.cx + 30, display.cy);

	self:performWithDelay(function()
		self:removeFromParentAndCleanup(true);
		if params.callback then 
			params.callback();
		end 
	end, during);
	local vertical = params.vertical or false;
	if vertical == true then
		bg:setRotation(-90)
		flower:pos(display.cx,display.cy - width/2 + flower:size().width);
		content:pos(display.cx,display.cy + 30);
		flower:setRotation(-90)
		content:setRotation(-90)
	end 
end 

function Loading:onEnter()

end 

function Loading:onExit()
	if self.scheduler then
		scheduler.unscheduleGlobal(self.scheduler);
		self.scheduler = nil
	end
end 

function Loading:showLoading(params)
	local loading = Loading.new(params);
	local scene = display.getRunningScene();
	tag = LOAD_TAG
	if params and params.tag then 
		tag = params.tag
	end
	scene:addChild(loading, tag, tag);
end 

function Loading:removeLoading(tag)
	tag = tag or LOAD_TAG
	local scene = display.getRunningScene();
	if scene:getChildByTag(tag) then
		scene:removeChildByTag(tag, true);
	end 
end

return Loading;