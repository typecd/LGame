local SoundUtil = {}

function SoundUtil.playEffect(path, name, isLoop)
	local prefix = path.."_mp3/";
	local suffix = ".mp3"
	--TODO
	-- if System.isAndroid then 
 --        prefix = path.."_ogg/";
 --        suffix = ".ogg"
 --    end
	audio.playSound(prefix..name..suffix, isLoop);
end 

function SoundUtil.playMusic(path, name, isLoop)
	local prefix = path.."_mp3/";
	local suffix = ".mp3"
	--TODO
	-- if System.isAndroid then 
 --        prefix = path.."_ogg/";
 --        suffix = ".ogg"
 --    end
	audio.playMusic(prefix..name..suffix, isLoop);
end 

function SoundUtil.getSoundPath(path, name)
	local prefix = path.."_mp3/";
	local suffix = ".mp3";
	--TODO
	-- if System.isAndroid then 
 --        prefix = path.."_ogg/";
 --        suffix = ".ogg"
 --    end
	return prefix..name..suffix;
end

return SoundUtil