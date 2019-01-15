--TrasitionTime
_TT={
	S_IN=0.4,
	S_OUT=0.4;
};
--HeaderSize
_HS=0;
_HS2=_HS/2

function GetMainBannerPath(song)
	local ret="";
	if song:HasBanner() and not song:HasPreviewVid() then
		ret=song:GetBannerPath();
	elseif song:HasPreviewVid() then
		ret=song:GetPreviewVidPath();
	elseif song:HasDisc() then
		ret=song:GetDiscPath();
	else
		ret="";
	end;
	return ret;
end;

function waieiColor(name)
	if name=="Text" then
		return Color("Blue");
	elseif name=="Dark" then
		return BoostColor(Color("Blue"),0.9);
	elseif name=="Light" then
		return BoostColor(Color("Blue"),1.2);
	elseif name=="Red" then
		return BoostColor(Color("Red"),0.9);
		elseif name=="WheelDefault" then
		return color("0.5,0.75,1.0,1.0");
	end;
end;

local function wheelHasG(song,mode)
	if mode=='jacket' then
		return song:HasJacket();
	elseif mode=='cd' then
		return song:HasCDImage();
	elseif mode=='disc' then
		return song:HasDisc();
	else
		return song:HasBanner();
	end
end;
local function wheelGetG(song,mode)
	if mode=='jacket' then
		return song:GetJacketPath();
	elseif mode=='cd' then
		return song:GetCDImagePath();
	elseif mode=='disc' then
		return song:GetDiscPath();
	else
		return song:GetBannerPath();
	end
end;
function GetBannerStat(song,wheelmode)
	local mode=split(',',TC_GetMetric('Wheel','Mode'));
	local mode1=mode[1] or 'jacket';
	local mode2=mode[2] or 'cd';
	local tmp={};
	local fall_bg=THEME:GetPathG("Common fallback","jacket");
	local fall_bn=THEME:GetPathG("Common fallback","banner");
	local jacket_cdtitle=song:GetJacketPath()==song:GetCDTitlePath();
	local g=fall_bg;
	tmp[2]=-1;
	if wheelmode=="JBN" then
		if wheelHasG(song,mode1) and wheelGetG(song,mode1)~=song:GetCDTitlePath()
			and not string.find(wheelGetG(song,mode1),'AlbumArtSmall',0,true)
			and not string.find(wheelGetG(song,mode1),'Folder',0,true) then
			g=wheelGetG(song,mode1);
			tmp[2]=3;
		elseif wheelHasG(song,mode2) and wheelGetG(song,mode2)~=song:GetCDTitlePath()
			and not string.find(wheelGetG(song,mode2),'AlbumArtSmall',0,true)
			and not string.find(wheelGetG(song,mode2),'Folder',0,true) then
			g=wheelGetG(song,mode2);
			tmp[2]=3;
		elseif song:HasBanner() then
			g=song:GetBannerPath();
			tmp[2]=1;
		elseif song:HasBackground() then
			g=song:GetBackgroundPath();
			tmp[2]=2;
		else
			g=fall_bg;
			tmp[2]=-1;
		end;
	elseif wheelmode=="JBG" then
		if wheelHasG(song,mode1) and wheelGetG(song,mode1)~=song:GetCDTitlePath()
			and not string.find(wheelGetG(song,mode1),'AlbumArtSmall',0,true)
			and not string.find(wheelGetG(song,mode1),'Folder',0,true) then
			g=wheelGetG(song,mode1);
			tmp[2]=3;
		elseif wheelHasG(song,mode2) and wheelGetG(song,mode2)~=song:GetCDTitlePath()
			and not string.find(wheelGetG(song,mode2),'AlbumArtSmall',0,true)
			and not string.find(wheelGetG(song,mode2),'Folder',0,true) then
			g=wheelGetG(song,mode2);
			tmp[2]=3;
		elseif song:HasBackground() then
			g=song:GetBackgroundPath();
			tmp[2]=2;
		elseif song:HasBanner() then
			g=song:GetBannerPath();
			tmp[2]=1;
		else
			g=fall_bg;
			tmp[2]=-1;
		end;
	elseif wheelmode=="BNJ" then
		if song:HasBanner() then
			g=song:GetBannerPath();
			tmp[2]=1;
		elseif wheelHasG(song,mode1) and wheelGetG(song,mode1)~=song:GetCDTitlePath()
			and not string.find(wheelGetG(song,mode1),'AlbumArtSmall',0,true)
			and not string.find(wheelGetG(song,mode1),'Folder',0,true) then
			g=wheelGetG(song,mode1);
			tmp[2]=3;
		elseif wheelHasG(song,mode2) and wheelGetG(song,mode2)~=song:GetCDTitlePath()
			and not string.find(wheelGetG(song,mode2),'AlbumArtSmall',0,true)
			and not string.find(wheelGetG(song,mode2),'Folder',0,true) then
			g=wheelGetG(song,mode2);
			tmp[2]=3;
		elseif song:HasBackground() then
			g=song:GetBackgroundPath();
			tmp[2]=2;
		else
			g=fall_bn;
			tmp[2]=-1;
		end;
	elseif wheelmode=="BGJ" then
		if song:HasBackground() then
			g=song:GetBackgroundPath();
			tmp[2]=2;
		elseif wheelHasG(song,mode1) and wheelGetG(song,mode1)~=song:GetCDTitlePath()
			and not string.find(wheelGetG(song,mode1),'AlbumArtSmall',0,true)
			and not string.find(wheelGetG(song,mode1),'Folder',0,true) then
			g=wheelGetG(song,mode1);
			tmp[2]=3;
		elseif wheelHasG(song,mode2) and wheelGetG(song,mode2)~=song:GetCDTitlePath()
			and not string.find(wheelGetG(song,mode2),'AlbumArtSmall',0,true)
			and not string.find(wheelGetG(song,mode2),'Folder',0,true) then
			g=wheelGetG(song,mode2);
			tmp[2]=3;
		elseif song:HasBanner() then
			g=song:GetBannerPath();
			tmp[2]=1;
		else
			g=fall_bg;
			tmp[2]=-1;
		end;
	end;
	tmp[1]=g;
	return tmp;
end;

function GameStyleDefaultChoice()
	if GAMESTATE:GetCurrentGame():GetName()=="dance" and GAMESTATE:GetNumPlayersEnabled()>=2 then
		return "Versus";
	else
		return "Single";
	end;
end;

function GetGameWaitTime(song)
	return math.max(song:GetFirstSecond()-3.0,0.0)
end;

-- [ja] 判定数からダンスポイントを取得 
function CalcDancePoints(w1,w2,w3,ok,total,hold)
	return (w1*3+w2*2+w3+ok*3)/((total+hold)*3);
end;

function GetPlayerSaveProfileFile(pn)
	local ret='';
	local dir=(pn==PLAYER_1) and PROFILEMAN:GetProfileDir('ProfileSlot_Player1') or PROFILEMAN:GetProfileDir('ProfileSlot_Player2');
	if dir~='' then
		if FILEMAN:DoesFileExist(dir..'waieiSettings.ini') then
			ret=dir..'waieiSettings.ini';
		end;
	end;
	return ret;
end;