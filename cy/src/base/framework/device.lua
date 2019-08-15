--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

--[[--

�ṩ�豸������ԵĲ�ѯ���Լ��豸���ܵķ���

����ܳ�ʼ��ɺ�device ģ���ṩ�������ԣ�

-   device.platform ���ص�ǰ����ƽ̨�����֣�����ֵ�� ios, android, mac, windows.
-   device.model �����豸�ͺţ�����ֵ�� unknown, iphone, ipad
-   device.language �����豸��ǰʹ�õ����ԣ�����ֵ��
    -   cn������
    -   fr������
    -   it���������
    -   gr������
    -   sp����������
    -   ru������
    -   jp������
    -   en��Ӣ��
-   device.writablePath �����豸�Ͽ���д�����ݵ���ѡ·����
    -   iOS �Ϸ���Ӧ�ó������ڵ� Documents Ŀ¼
    -   Android �Ϸ��ش洢���ĸ�Ŀ¼
    -   ����ƽ̨�ķ���ֵ�� quick-x-player ����
-   device.cachePath �����豸�Ͽ���д�����ݵĻ���Ŀ¼��
    -   iOS �Ϸ���Ӧ�ó������ڵ� Library/Caches Ŀ¼
    -   ����ƽ̨�ķ���ֵͬ device.writablePath
-   device.directorySeparator Ŀ¼�ָ������� Windows ƽ̨���� ��\��������ƽ̨���� ��/��
-   device.pathSeparator ·���ָ������� Windows ƽ̨���� ��;��������ƽ̨���� ��:��

-   android ƽ̨����Ҫ�� main Activity ��PSNative��ʼ��: 
    public void onCreate(Bundle savedInstanceState) {
        PSNative.init(this);

        ...
    }

]]
local device = {}

device.platform    = "unknown"
device.model       = "unknown"

local sharedApplication = CCApplication:sharedApplication()
local target = sharedApplication:getTargetPlatform()
if target == kTargetWindows then
    device.platform = "windows"
elseif target == kTargetMacOS then
    device.platform = "mac"
elseif target == kTargetAndroid then
    device.platform = "android"
elseif target == kTargetIphone or target == kTargetIpad then
    device.platform = "ios"
    if target == kTargetIphone then
        device.model = "iphone"
    else
        device.model = "ipad"
    end
end

local language_ = sharedApplication:getCurrentLanguage()
if language_ == kLanguageChinese then
    language_ = "cn"
elseif language_ == kLanguageChineseTW then
    language_ = "tw"
elseif language_ == kLanguageFrench then
    language_ = "fr"
elseif language_ == kLanguageItalian then
    language_ = "it"
elseif language_ == kLanguageGerman then
    language_ = "gr"
elseif language_ == kLanguageSpanish then
    language_ = "sp"
elseif language_ == kLanguageRussian then
    language_ = "ru"
else
    language_ = "en"
end

device.language = language_
device.writablePath = CCFileUtils:sharedFileUtils():getWritablePath()
-- device.cachePath = CCFileUtils:sharedFileUtils():getCachePath()
device.directorySeparator = "/"
device.pathSeparator = ":"
if device.platform == "windows" then
    device.directorySeparator = "\\"
    device.pathSeparator = ";"
end


printInfo("# device.platform              = " .. device.platform)
printInfo("# device.model                 = " .. device.model)
printInfo("# device.language              = " .. device.language)
printInfo("# device.writablePath          = " .. device.writablePath)
-- printInfo("# device.cachePath             = " .. device.cachePath)
printInfo("# device.directorySeparator    = " .. device.directorySeparator)
printInfo("# device.pathSeparator         = " .. device.pathSeparator)
printInfo("#")

--[[--

��ʾ�ָʾ��

�� iOS �� Android �豸����ʾϵͳ�Ļָʾ��������������������ʱ֪ͨ�û���Ҫ�ȴ���

]]
function device.showActivityIndicator()
    if DEBUG then
        printInfo("device.showActivityIndicator()")
    end
    if device.platform == "android" then
        luaj.callStaticMethod("org/cocos2dx/utils/PSNative", "showActivityIndicator", {}, "()V"); 
    elseif device.platform == "ios" then
        CCNative:showActivityIndicator()
    end
end

--[[--

����������ʾ�Ļָʾ��

]]
function device.hideActivityIndicator()
    if DEBUG then
        printInfo("device.hideActivityIndicator()")
    end
    if device.platform == "android" then
        luaj.callStaticMethod("org/cocos2dx/utils/PSNative", "hideActivityIndicator", {}, "()V"); 
    elseif device.platform == "ios" then
        CCNative:hideActivityIndicator()
    end
end
--[[--

��ʾһ��������ť�ĵ����Ի���

~~~ lua

local function onButtonClicked(event)
    if event.buttonIndex == 1 then
        .... ���ѡ���� YES ��ť
    else
        .... ���ѡ���� NO ��ť
    end
end

device.showAlert("Confirm Exit", "Are you sure exit game ?", {"YES", "NO"}, onButtonClicked)

~~~

��û��ָ����ť����ʱ���Ի����Ĭ����ʾһ����OK����ť��
�ص�������õı���У�buttonIndex ָʾ���ѡ������һ����ť����ֵ�ǰ�ť����ʾ˳��

@param string title �Ի������
@param string message ����
@param table buttonLabels ���������ť����ı�����
@param function listener �ص�����

]]
function device.showAlert(title, message, buttonLabels, listener)
    if type(buttonLabels) ~= "table" then
        buttonLabels = {tostring(buttonLabels)}
    else
        table.map(buttonLabels, function(v) return tostring(v) end)
    end

    if DEBUG then
        printInfo("device.showAlert() - title: %s", title)
        printInfo("    message: %s", message)
        printInfo("    buttonLabels: %s", table.concat(buttonLabels, ", "))
    end

	if device.platform == "android" then
		local tempListner = function(event)
			if type(event) == "string" then
				event = require("framework.json").decode(event)
				event.buttonIndex = tonumber(event.buttonIndex)
			end
			if listener then listener(event) end
		end
		luaj.callStaticMethod("org/cocos2dx/utils/PSNative", "createAlert", {title, message, buttonLabels, tempListner}, "(Ljava/lang/String;Ljava/lang/String;Ljava/util/Vector;I)V");
	else
	    local defaultLabel = ""
	    if #buttonLabels > 0 then
	        defaultLabel = buttonLabels[1]
	        table.remove(buttonLabels, 1)
	    end

	    CCNative:createAlert(title, message, defaultLabel)
	    for i, label in ipairs(buttonLabels) do
	        CCNative:addAlertButton(label)
	    end

	    if type(listener) ~= "function" then
	        listener = function() end
	    end

	    CCNative:showAlert(listener)
	end
end

--[[--

ȡ��������ʾ�ĶԻ���

��ʾ��ȡ���Ի��򣬲���ִ����ʾ�Ի���ʱָ���Ļص�������

]]
function device.cancelAlert()
    if DEBUG then
        printInfo("device.cancelAlert()")
    end
    CCNative:cancelAlert()
end

--[[--

�����豸�� OpenUDID ֵ

OpenUDID ��Ϊ�豸����� UDID��Ψһ�豸ʶ���룩����������ʶ���û����豸��

�� OpenUDID �����������⣺

-   ���ɾ����Ӧ�������°�װ����õ� OpenUDID �ᷢ���仯
-   iOS 7 ��֧�� OpenUDID

@return string �豸�� OpenUDID ֵ

]]
function device.getOpenUDID()
    local ret = CCNative:getOpenUDID()
    if DEBUG then
        printInfo("device.getOpenUDID() - Open UDID: %s", tostring(ret))
    end
    return ret
end

--[[--

���������ָ������ַ

~~~ lua

-- ����ҳ
device.openURL("http://dualface.github.com/quick-cocos2d-x/")

-- ���豸�ϵ��ʼ����򣬲��������ʼ��������ռ��˵�ַ
device.openURL("mailto:nobody@mycompany.com")
-- �������������
local subject = string.urlencode("Hello")
local body = string.urlencode("How are you ?")
device.openURL(string.format("mailto:nobody@mycompany.com?subject=%s&body=%s", subject, body))

-- ���豸�ϵĲ��ų���
device.openURL("tel:123-456-7890")

~~~

@param string ��ַ���ʼ������ŵȵ��ַ���

]]
function device.openURL(url)
    if DEBUG then
        printInfo("device.openURL() - url: %s", tostring(url))
    end
    CCNative:openURL(url)
end

--[[--

��ʾһ������򣬲������û���������ݡ�

���û����ȡ����ťʱ��showInputBox() �������ؿ��ַ�����

@param string title �Ի������
@param string message ��ʾ��Ϣ
@param string defaultValue �����Ĭ��ֵ

@return string �û�������ַ���

]]
function device.showInputBox(title, message, defaultValue)
    title = tostring(title or "INPUT TEXT")
    message = tostring(message or "INPUT TEXT, CLICK OK BUTTON")
    defaultValue = tostring(defaultValue or "")
    if DEBUG then
        printInfo("device.showInputBox() - title: %s", tostring(title))
        printInfo("    message: %s", tostring(message))
        printInfo("    defaultValue: %s", tostring(defaultValue))
    end
    return CCNative:getInputText(title, message, defaultValue)
end


--[[--

��

@param int millisecond ��ʱ��(����) (������ʱ������android��Ч��Ĭ��200ms) 

android ��Ҫ����𶯷���Ȩ��
<uses-permission android:name="android.permission.VIBRATE" />  


]]

function device.vibrate(millisecond)
    if DEBUG then
        printInfo("device.vibrate(%s)", millisecond or "")
    end
 
    if device.platform == "android" then
        if millisecond then
            luaj.callStaticMethod("org/cocos2dx/utils/PSNative", "vibrate", {millisecond}, "(I)V");
        else      
            CCNative:vibrate()
        end     
    elseif device.platform == "ios" then
        CCNative:vibrate()
    else
        printInfo("%s platform unsupporte vibrate", device.platform)
    end
end

--[[
���ϵͳʱ�䣬��ȷ��΢��

@return cc_timeval

cc_timeval.tv_sec  seconds
cc_timeval.tv_usec microSeconds

~~~ lua

-- sample
    local tm = device.gettime()
    printInfo("%d:%d", tm.tv_sec, tm.tv_usec)  
~~~

]]
function device.gettime()
    local tm = cc_timeval:new()
    CCTime:gettimeofdayCocos2d(tm, nil)

    if device.platform == "windows" then
        tm.tv_sec = os.time()
    end
    return tm
end

--[[
���ʱ����ȷ������

@param cc_timeval tm_start ��ʼʱ��
@param cc_timeval tm_end   ����ʱ��
@return double             ʱ���(����)         

~~~ lua

-- sample
    local tm_start = device.gettime()
    --do something
    local tm_end   = device.gettime()
    local timesub  = device.timersub(tm_start, tm_end)
    printInfo(timesub)  
~~~

]]

function device.timersub(tm_start, tm_end)
    return CCTime:timersubCocos2d(tm_start, tm_end)
end

return device
