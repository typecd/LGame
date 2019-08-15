local UITools = {}

UITools.EDITBOX_TYPE_USRENAME = 1  -- 用户名		英文 + 数字
UITools.EDITBOX_TYPE_PASSWORD = 2  -- 密码		英文 + 数字 + 点 + 减号 + 下划线
UITools.EDITBOX_TYPE_NICKNAME = 3  -- 昵称		英文 + 数字 + 中文 + 下划线
UITools.EDITBOX_TYPE_PHONENUM = 4  -- 手机号		数字

-- 检查格式
function UITools.checkEditBoxText( text, textType )
	if #text < 1 then
		return false
	end

	local i = 1
	while (i <= #text) do
		local gap = 1
		local curByte = string.byte(text,i)

		if curByte > 127 then 
			gap = 3
		else
			gap = 1
		end

		--local char = string.sub(text, i, i + gap - 1)

		if textType == UITools.EDITBOX_TYPE_USRENAME then
			if curByte >= string.byte("a") and curByte <= string.byte("z") then 
				i = i + gap
			elseif curByte >= string.byte("A") and curByte <= string.byte("Z") then
				i = i + gap
			elseif curByte >= string.byte("0") and curByte <= string.byte("9") then
				i = i + gap
			else
				return false
			end
		elseif textType == UITools.EDITBOX_TYPE_PASSWORD then
			if curByte >= string.byte("a") and curByte <= string.byte("z") then 
				i = i + gap
			elseif curByte >= string.byte("A") and curByte <= string.byte("Z") then
				i = i + gap
			elseif curByte >= string.byte("0") and curByte <= string.byte("9") then
				i = i + gap
			elseif curByte == string.byte(".") or curByte == string.byte("-") or curByte == string.byte("_") then
				i = i + gap
			else
				return false
			end
		elseif textType == UITools.EDITBOX_TYPE_NICKNAME then
			if curByte >= string.byte("a") and curByte <= string.byte("z") then 
				i = i + gap
			elseif curByte >= string.byte("A") and curByte <= string.byte("Z") then
				i = i + gap
			elseif curByte >= string.byte("0") and curByte <= string.byte("9") then
				i = i + gap
			elseif curByte >= 127 then
				i = i + gap
			elseif curByte == string.byte("_") then
				i = i + gap
			else
				return false
			end
		elseif textType == UITools.EDITBOX_TYPE_PHONENUM then
			if curByte >= string.byte("0") and curByte <= string.byte("9") then
				i = i + gap
			else
				return false
			end
		end
	end

	return true
end

-- 获取字符长度
function UITools.getEditBoxTextLength( text )
	local length = 0
	local i = 1
	while (i <= #text) do   			-- utf8 汉字3位
		local gap = 1
		local curByte = string.byte(text,i)  	-- ASCII码

		if curByte > 127 then 
			length = length + 2
			gap = 3
		else
			length = length + 1
			gap = 1
		end

		i = i + gap 
	end

	return length
end

-- 截取字符
function UITools.subEditBoxText( text, length )
	local realLen = UITools.getEditBoxTextLength(text)
	if realLen <= length then
		return text
	else
		local i = 1
		local curLen = 0
		while (i <= #text) do
			local gap = 1
			local curByte = string.byte(text,i)

			if curByte > 127 then 
				curLen = curLen + 2
				gap = 3
			else
				curLen = curLen + 1
				gap = 1
			end

			i = i + gap

			if curLen > length then
				i = i - gap - 1
				local subText = string.sub(text, 1, i)
				return subText
			end
		end
	end
end

function UITools.converIcon2Sex(id)
	-- 0 is male 1 is female
	return id % 2 == 0;
end

function UITools.setShaderGray( node )
	setShader(node,"gray")
end

function UITools.setShaderNormal( node )
	setShader(node,"normal")
end

function UITools.setShaderAllGray( node )
	setShader(node,"grayAll")
end

function UITools.setShaderAllNormal( node )
	setShader(node,"normalAll")
end

function UITools.addSpriteFrames(path)
	display.addSpriteFramesWithFile(path..".plist", path..".png");
end

function UITools.removeSpriteFrames(path)
	display.removeSpriteFramesWithFile(path..".plist", path..".png");
end 

function UITools.createSpriteWithFrame(image)
	return display.newSprite(display.newSpriteFrame(image));
end

function UITools.createFrameAnim(params)
	local path = params.path;
	local image = params.image;
	local endFrame = params.endFrame;
	local interval = params.interval or 0.1;
	local start = params.start or 1;
	local remove = true;
	if params.remove ~= nil then 
		remove = params.remove;
	end 
	display.addSpriteFramesWithFile(path..".plist", path..".png");
    local frames = display.newFrames(image.."%d.png", start, endFrame);
    local sprite = display.newSprite(frames[start]);
    local animation = display.newAnimation(frames, interval);
    if params.once then 
    	transition.playAnimationOnce(sprite, animation, remove, params.callback, params.delay);
    else
        transition.playAnimationForever(sprite, animation, params.delay);
    end 

    if params.blend then
        local blendFunc = ccBlendFunc:new();
    	blendFunc.src = GL_DST_ALPHA
    	blendFunc.dst = GL_ONE
    	sprite:setBlendFunc(blendFunc); 
   	end 

    return sprite;
end 

function UITools.subText(text, length)
	local subText = text;
    if UITools.getEditBoxTextLength(subText) > length then
        subText = UITools.subEditBoxText(subText,length - 2)
        subText = subText .. "..."
    end
    return subText;
end 

function UITools.formatGold(gold)
	local ret = "";
	local len = #tostring(gold);
	if len > 10 then
		local number = math.floor(gold / 10^8);
		ret = string.format("%.2f", number / 10^2).."亿";
	elseif len > 7 then
		local number = math.floor(gold / 10^4);
		ret = string.format("%.2f", number / 10^2).."万";
	else  
		ret = getGoldNum(gold, true);
	end
	return ret;
end

function UITools.creatLabelSp(params)
    local num = params.num
    local plist = params.plist
    local isSprite = params.isSprite or false        -- sp or batch
    local isFloat = params.isFloat or false          -- 需要显示整数的小数位
    local isAddPlus = params.isAddPlus or false      -- 需要添加 ‘+’
    local isAddSub = params.isAddSub or false      	 -- 需要添加 ‘-’
    local isAddYuan = params.isAddYuan or false      -- 需要添加 ‘元’
    local isAddMul = params.isAddMul or false        -- 需要添加 ‘乘’
    local isAddSlash = params.isAddSlash or false    -- 需要添加 ‘/’

    if type(num) == "number" then
		if num < 0 then 
			num = num * -1;
		end
    	-- 如果是整数 需要显示小数位 入 1 -> 1.00
    	if math.floor(num) == num and isFloat then
    		num = num .. ".00"
    	end

    	-- 添加 + - 元
    	if isAddPlus then
    		num = "+" .. num
    	end

    	if isAddSub then
    		num = "-" .. num
    	end

    	if isAddYuan then
    		if CacheEngine.isOpenYuan() then
    			num = num .. "y"
    		else
    			num = num .. "j" .. "b"
    		end
    	end

        if isAddMul then
            num = "*" .. num
        end

        if isAddSlash then
        	num = num .. "/"
        end
    end

    local labelSp = nil

    if isSprite then
    	labelSp = createCustomFloatLabelSP(num, plist)
    else
    	labelSp = createCustomFloatLabel(num, plist)
    end
    
    return labelSp
end

function UITools.createLabelPlist(params)
	local plist = params.plist
	local text = params.text
	local frames = params.frames
	local keys = params.keys or frames
	local frameHead = params.frameHead or ""
	local interval = params.interval or 0
	if plist then
		UITools.addSpriteFrames(plist)
	end

	--check frames
	if frames == nil then
		return
	else
		local t = {}
		local index = 1
		local count = string.len(frames)
		while index <= count do
			local s = string.sub(frames,index,index)
			if s == "(" then
				local e = string.find(frames,")",index)
				if e == nil then
					return
				else
					if e-1 >= index+1 then
						local str = string.sub(frames,index+1,e-1)
						table.insert(t,str)
					end
					index = e+1
				end
			else
				table.insert(t,s)
				index = index + 1
			end
		end
		frames = t
	end

	local frameCount = #frames
	local keysCount = string.len(keys)
	local sMap = {}
	if keys then
		local index = 1
		local count = 1
		while true do
			if count > frameCount then
				break
			end
			local asc = string.byte(keys, index)
			local key = nil
			if asc >= 128 then
				key = string.sub(keys, index, index+2)
				index = index + 3
			else
				key = string.sub(keys, index, index)
				index = index+1
			end
			if key == nil then
				break
			end			
			sMap[key] = frames[count]		
			count = count + 1	
		end
	end

	local node = display.newNode()
	
	if text and string.len(text) > 0 then
		local sprs = {}
    	local len = 0   
    	local textLen = string.len(text)

		local index = 1
		local maxH = 0
		while true do
			if index > textLen then
				break
			end
			local asc = string.byte(text,index)
			local key = nil
			if asc >= 128 then
				key = string.sub(text, index, index+2)
				index = index + 3
			else
				key = string.sub(text, index, index)
				index = index+1
			end
			if key == nil then
				break
			end
			local frameName = sMap[key]
			if frameName then
				local spr = display.newSprite("#"..frameHead..frameName..".png")
				if spr ~= nil then
					spr.size = spr:getContentSize()
	                len = len + spr.size.width	                 
	                if spr.size.height > maxH then
	                	maxH = spr.size.height
	                end
	                table.insert(sprs,spr) 
				end
			end
		end
		if #sprs > 0 then
			len = len + (#sprs-1)*interval
			node:setContentSize(cc.size(len,maxH))
		    local posX = -len*0.5
		    table.foreach(sprs,function(i,v)
		        posX = posX + v.size.width*0.5
		        v:setPosition(cc.p(posX,0))
		        posX = posX + v.size.width*0.5 + interval
		        v:addTo(node)
		    end)
		end
	end
	return node
end

--根据分隔符分割字符串，返回table
function UITools.split(str, div)
	if str == nil or str == "" or div == nil then 
		return ;
	end

	local ret = {};
	for sub in string.gmatch(str .. div, "(.-)" .. div ) do 
		table.insert(ret, sub);
	end

	return ret;
end

function UITools.isRightEmail(str)
     if string.len(str or "") < 6 then return false end
     local b,e = string.find(str or "", '@')
     local bstr = ""
     local estr = ""
     if b then
         bstr = string.sub(str, 1, b-1)
         estr = string.sub(str, e+1, -1)
     else
         return false
     end
 
     -- check the string before '@'
     local p1,p2 = string.find(bstr, "[%w_]+")
     if (p1 ~= 1) or (p2 ~= string.len(bstr)) then return false end
     
     -- check the string after '@'
     if string.find(estr, "^[%.]+") then return false end
     if string.find(estr, "%.[%.]+") then return false end
     if string.find(estr, "@") then return false end
     if string.find(estr, "[%.]+$") then return false end
 
     _,count = string.gsub(estr, "%.", "")
     if (count < 1 ) or (count > 3) then
         return false
     end
 
     return true
 end

--清楚所有子节点，filterTag为过滤的节点
function UITools.removeAllChildWithFilter(parent, filterTag)
	local children = parent:getChildren();

	if children then
		local len = children:count();
		for i = len - 1, 0, -1 do
			local node = tolua.cast(children:objectAtIndex(i), "CCNode")
   			if node and node:getTag() ~= filterTag then
    			node:removeFromParentAndCleanup(true);
   			end
		end
    end
end

function UITools.showGuideFinger(parent, pos)
	local finger = display.newSprite(BASE_IMAGE_GUIDE .. "guide_finger.png");
	finger:setAnchorPoint(ccp(0, 1));
	finger:setPosition(pos);
	parent:addChild(finger, 10);
	
	finger:runAction(CCRepeatForever:create(transition.sequence({
		CCScaleTo:create(0.2, 0.8), CCScaleTo:create(0.6, 1)
	})));
end

function UITools.showGuideCircle(parent, pos)
	local cirW = 0;
	for i = 1, 4 do 
		local circle = display.newSprite(BASE_IMAGE_GUIDE .. "guide_circle" .. i .. ".png");
		circle:setPosition(pos);

		local delay = 0;
		local act = nil;
		if i == 1 then 
			cirW = circle:size().width;
			circle:setOpacity(120);
			act = transition.sequence({
				CCScaleTo:create(0.5, 1.1), CCScaleTo:create(0.5, 1)
			});
		else
			delay = (i - 2) * 0.3;
			local scale = cirW / circle:size().width;
			circle:setScale(cirW / circle:size().width);
			act = transition.sequence({
				transition.spawn({
					CCScaleTo:create(1, scale * 7), CCFadeTo:create(1, 0)
				}),
				CCScaleTo:create(0, scale),
				CCFadeTo:create(0, 255)
			});
		end
		circle:runAction(transition.sequence({
			CCDelayTime:create(delay),
			CCRepeat:create(act, 2),
			CCCallFunc:create(function()
				circle:removeFromParentAndCleanup(true);
			end);
		}));
		parent:addChild(circle, 9);
	end
end

function UITools.getScreenScale()
	local design_width = 1136
	local design_height = 640

	local designScale = design_width / design_height
	local realScale = CONFIG_SCREEN_WIDTH / CONFIG_SCREEN_HEIGHT

	if realScale < designScale then
		return realScale / designScale
	else
		return 1
	end
end

return UITools