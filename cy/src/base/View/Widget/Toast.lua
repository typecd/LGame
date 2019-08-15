local Toast = class("Toast", function()
	return display.newLayer();
end)

local TOAST_TAG = 777;

local ToastVec = {};

function Toast:ctor(msg)
	self:setNodeEventEnabled(true);
	self:show(msg);
end

function Toast:show(msg)
	if msg == nil then
		return
	end
	local bg = display.newScale9Sprite(BASE_IMAGE .. "toast_bg.png");
	bg:pos(display.cx, display.cy + 50);
	bg:addTo(self);

	local conent = display.newTTFLabel({text = msg});
	conent:pos(display.cx, bg:y());
	conent:addTo(self);

	local width = math.max(conent:size().width + 30, bg:size().width);
	local height = math.max(conent:size().height + 20, 55);
	bg:setContentSize(CCSizeMake(width, 55));

	self:fadeOut(bg);
	self:fadeOut(conent);
	local seq = transition.sequence({
			CCScaleTo:create(0.1, 1.1),
			CCScaleTo:create(0.1, 1),
			CCDelayTime:create(3),
			CCCallFunc:create(function()
				self:removeFromParentAndCleanup(true);
			end)
		})
	self:runAction(seq);
end

function Toast:fadeOut(target)
	local seq = transition.sequence({
		CCDelayTime:create(2.2),
		CCFadeOut:create(1),
	})
	target:runAction(seq)
end

function Toast:onEnter()
	-- Toast.super.onEnter(self);
end 

function Toast:onExit()
	-- Toast.super.onExit(self);
	table.remove(ToastVec)
end 

function Toast:showToast(msg, isPortrait)	
	for i, toast in pairs(ToastVec) do 
		if isPortrait then
			toast:runAction(CCMoveBy:create(0.1, ccp(-60, 0)));
		else
			toast:runAction(CCMoveBy:create(0.1, ccp(0, 60)));
		end
	end 
	local toast = Toast.new(msg);
	if isPortrait then
		toast:setRotation(-90)
	end
	table.insert(ToastVec, 1, toast);
	local scene = display.getRunningScene();
	scene:addChild(toast,TOAST_TAG,TOAST_TAG);
end 

return Toast;