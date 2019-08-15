local Button = class("Button",function()
	return display.newNode();
end)

local size2t = function(size)
	return {width = size.width, height = size.height}
end

local point2t = function(point)
    return {x = point.x, y = point.y}
end

local rect2t = function(rect)
	return {origin = point2t(rect.origin), size = size2t(rect.size)}
end

function Button:ctor(params)
    assert(type(params) == "table","Button invalid params");

    if params.delegate then
    	self.delegate = params.delegate
    end
    
    self.callback = params.callback;
    self.data = params.data;
    self.normal = params.normal;
    self.pressed = params.pressed;
    self.disabled = params.disabled;
    self.touchRect = params.touchRect;
    self.delay = params.delay or 0.2;
	self.canTouch = true;
	self.isDoubleClick = false;
	self.noSwallow = params.noSwallow;
	-- touch layer 
	local layer = display.newLayer();
	layer:setTouchEnabled(true);
	layer:registerScriptTouchHandler(function(...)
		return self:onTouch(...)
	end, false, params.priority, not params.noSwallow)

	layer:addTo(self);
	layer:setPosition(ccp(0, 0))
    layer:setAnchorPoint(ccp(0, 0))
	self.touchLayer = layer;


	self:initImage();
end

function Button:initImage()
	self.normal:addTo(self);
	self.pressed:addTo(self);
	self.pressed:hide();
	self.disabled:addTo(self);
	self.disabled:hide();

	self:setContentSize(self.normal:size());

	self.normal:setCascadeColorEnabled(true);
	self.pressed:setCascadeColorEnabled(true);
end

function Button:onTouch(event, x, y)
	-- bba.log("Button(%s):onTouch : %s (%f,%f)",self,type,x,y)
	if not self.canTouch then 
		return false;
	end

	local pos = self:convertToNodeSpace(ccp(x, y))
	local rect = self.touchRect or self.normal:boundingBox();

	if event == "began" then
		-- if self.touchRect then 
		-- 	print("--- self.touchRect")
		-- 	bba.printTable(rect2t(self.touchRect));
		-- end 
		if rect:containsPoint(pos) then
			if not self:isVisible() then
				return false
			end
			self.pressed:show();
			self.normal:hide()
			self.cancled = false;
			self.startX = x;
			return true
		end 
	elseif event == "ended" then
		self.pressed:hide();
		self.normal:show()
		if not self.cancled and not self.isDoubleClick then
			self.isDoubleClick = true;
			local delay = CCDelayTime:create(self.delay)
			local callBack = CCCallFunc:create(function (  )
				self.isDoubleClick = false;
			end)
			self:runAction(transition.sequence({delay,callBack}))

			self.callback(self.delegate or self:getParent() or self,self.data);
		end
	elseif event == "moved" then
		if not rect:containsPoint(pos) then
			self.pressed:hide();
			self.normal:show()
			self.cancled = true;
		else 
			if self.noSwallow  then
				-- if math.abs(self.startX - x) > rect.size.width/2 then 
				if math.abs(self.startX - x) > 50 then 
					self.cancled = true
				else
					self.pressed:show();
					self.normal:hide()   
				end 
			else
				self.pressed:show();
				self.normal:hide() 
				self.cancled = false;	
			end 
		end 
	end
	
	return false
end

function Button:setTouchEnabled(enable)
	self.canTouch = enable;
end

function Button:hideAndBan(enable)
	self.canTouch = enable;
	self:setVisible(enable);
end

function Button:setEnabled(enabled)
	self.canTouch = enabled;
	if enabled then 
		self.normal:show();
		self.disabled:hide();
	else
		self.disabled:show();
		self.normal:hide();
	end 
end 

function Button:setUserData( data )
	self.data = data
end

--按钮上面有多个精灵 TODO optimzie
function Button:addMoreUI(sprs)
	local nml = self.normal:getChildByTag(10);
	local prs = self.pressed:getChildByTag(20);
	if nml then 
		nml:removeFromParentAndCleanup(true);
	end
	if prs then 
		prs:removeFromParentAndCleanup(true);
	end

	self.normal:addChild(sprs[1]);
	self.pressed:addChild(sprs[2]);
	sprs[1]:setTag(10);
	sprs[2]:setTag(20);
end

function Button:setName(name)
	self.name = name;
end

function Button:getName()
	return self.name or "";
end

function Button:setColor(color)
	self.normal:setColor(color);
	self.pressed:setColor(color);
end

function Button:setOpacity(opacity)
	self.normal:setOpacity(opacity);
	self.pressed:setOpacity(opacity);
end

function Button:flipX(b)
	self.normal:flipX(b);
	self.pressed:flipX(b);
	if self.pressed.highlightcover then 
		self.pressed.highlightcover:flipX(b);
	end 
	self.disabled:flipX(b);
end 

function Button:changeImage(normal, pressed, disabled)
	self.normal:removeFromParentAndCleanup(true);
	self.pressed:removeFromParentAndCleanup(true);
	self.disabled:removeFromParentAndCleanup(true);

	local normalImage = normal;
	local pressedImage = pressed and pressed or normal;
	local disabledIamge = disabled and disabled or normal;

    local normalSp = display.newSprite(normalImage);
    self.normal = normalSp;
    local pressedSp = display.newSprite(pressedImage);
    self.pressed = pressedSp;
    pressedSp:setScale(0.95);
    local highlightcover = display.newSprite(pressedImage);
    local blendFunc = ccBlendFunc:new();
    blendFunc.src = GL_DST_ALPHA
    blendFunc.dst = GL_ONE
    highlightcover:setBlendFunc(blendFunc);
    highlightcover:setOpacity(100);
    highlightcover:align(display.LEFT_BOTTOM, 0,0);
    highlightcover:addTo(pressedSp);

    local disabledSP = display.newSprite(disabledIamge);
    setShaderGray(disabledSP);
    self.disabled = disabledSP;

	self:initImage();
end

return Button;