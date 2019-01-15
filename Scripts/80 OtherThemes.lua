-- [ja] 他テーマの独自機能用 とそれに対応するための関数

-- *************************************************************** CyberiaStyle

--[[
メモ : 
	02 PCheckCS.lua
	ScreenOptionsRFileCreate underlay.lua
--]]

-- *************************************************************** 対応用関数 

-- [ja] ライバル名の取得 
function GetCSRivalName(rivalname)
	local under=string.find(rivalname,'_',0,true);
	if under then
		return string.sub(rivalname,under+1);
	else
		return rivalname;
	end;
end;
-- [ja] 現在選択中のステップに該当するCS用ライバルデータのスコアテキストを取得 
function GetCSRivalParameter(song,st,rivalname)
	local ret='';
	if st then
		local steptype=st:GetStepsType();
		local difficulty=ToEnumShortString(st:GetDifficulty());
		local group=song:GetGroupName();
		local song_group=string.lower(GetSong2Folder(song));
		local folder='./CSRealScore/'..rivalname..'/Songs/'..group..'/'..song_group..'/';
		local flist=FILEMAN:GetDirListing(folder,false,false);
		if #flist>0 then
			local file=flist[1];
			if FILEMAN:DoesFileExist(folder..file) then
				local f=OpenFile(folder..file);
				ret=GetFileParameter(f,''..steptype..'_'..difficulty..'/CS');
				CloseFile(f);
			end;
		end;
	end;
	return ret;
end;

-- [ja] CS用ライバルデータのスコアテキストからダンスポイント（%）を取得 
function GetCSRivalPercent(st,str)
	if st and str~='' then
		local sp_str=split(':',str);
		--[[
			[1] 日付
			[2] グレード
			[3] ダンスポイント（スコア）
		--]]
		if #sp_str>=3 then
			local mpn=GAMESTATE:GetMasterPlayerNumber();
			local radar=st:GetRadarValues(mpn);
			local total=radar:GetValue('RadarCategory_TapsAndHolds');
			local long=radar:GetValue('RadarCategory_Holds')+radar:GetValue('RadarCategory_Rolls');
			local max_dp=(total+long)*3;
			return tonumber(sp_str[3])/max_dp;
		else
			return 0;
		end;
		return 0;
	end;
	return 0;
end;