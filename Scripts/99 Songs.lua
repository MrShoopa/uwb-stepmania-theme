local Group={};
local Song={};

local function SetSongColors(group,colorstring)
	local colors={};
	local g_col_t=split(":",colorstring);
	if g_col_t[1]~="" then
		for c=1,#g_col_t do
			local g_col_fol=split("|",g_col_t[c]);
			-- [ja] このグループのデフォルトカラー 
			if c==1 then
				colors['*']=Str2Color(g_col_fol[1]);
			end;
			for f=2,#g_col_fol do
				colors[string.lower(g_col_fol[f])]=Str2Color(g_col_fol[1]);
			end;
		end;
	end;
	local songs=SONGMAN:GetSongsInGroup(group);
	for s=1,#songs do
		local fol=string.lower(GetSong2Folder(songs[s]));
		if colors['*'] then
			if colors[fol] then
				Song[group..'/'..fol..'-color']=colors[fol];
			else
				Song[group..'/'..fol..'-color']=colors['*'];
			end;
		else
			Song[group..'/'..fol..'-color']=nil;
		end;
	end;
end;
local function SetSongMeterTypes(group,meterstring)
	local meters={};
	local g_met_t=split(":",meterstring);
	if g_met_t[1]~="" then
		for m=1,#g_met_t do
			local g_met_fol=split("|",g_met_t[m]);
			-- [ja] このグループのデフォルトメータータイプ 
			if m==1 then
				meters['*']=string.lower(g_met_fol[1]);
			end;
			for f=2,#g_met_fol do
				meters[string.lower(g_met_fol[f])]=string.lower(g_met_fol[1]);
			end;
		end;
	end;
	local songs=SONGMAN:GetSongsInGroup(group);
	for s=1,#songs do
		local fol=string.lower(GetSong2Folder(songs[s]));
		if meters['*'] then
			if meters[fol] then
				Song[group..'/'..fol..'-metertype']=meters[fol];
			else
				Song[group..'/'..fol..'-metertype']=meters['*'];
			end;
		else
			Song[group..'/'..fol..'-metertype']='ddr';
		end;
	end;
end;

--[ja] 現在の設定の難易度数値を記録する 
local function SetSongMeter(group)
	local meter_cnv=GetUserPref_Theme("UserMeterType");
	local songs=SONGMAN:GetSongsInGroup(group);
	for s=1,#songs do
		local fol=string.lower(GetSong2Folder(songs[s]));
		local steps=songs[s]:GetAllSteps();
		for st=1,#steps do
			local ty=steps[st]:GetStepsType();
			local df=steps[st]:GetDifficulty();
			if meter_cnv=='DDR X' then
				local ddd=songs[s];
				Song[group..'/'..fol..'-'..ty..'-'..df]=GetConvertDifficulty_DDRX(songs[s],steps[st],GetSongs_str(group..'/'..fol,'metertype'));
			elseif meter_cnv=='LV100' then
				Song[group..'/'..fol..'-'..ty..'-'..df]=GetConvertDifficulty_LV100(songs[s],steps[st]);
			else
				Song[group..'/'..fol..'-'..ty..'-'..df]=steps[st]:GetMeter();
			end;
		end;
	end;
end;

local init=false;
local function InitGroups()
	Group={};
	Song={};
	local groups=SONGMAN:GetSongGroupNames();
	for gr=1,#groups do
		local dir="";
		local name="";
		local banner="";
		local jacket="";
		local meter="";
		local color="";
		local exf=false;
		local exf_name="";
		local exf_ja="";
		local exf_bn="";
		local exf_color="";
		Group[groups[gr]..'-dir']=groups[gr];
		if HasGroupIni(Group[groups[gr]..'-dir']) then
			local f=OpenFile(GetGroupParameter_Path(Group[groups[gr]..'-dir']));
			name=GetFileParameter(f,'name');
			meter=GetFileParameter(f,'metertype');
			color=GetFileParameter(f,'menucolor');
			exf=(GetFileParameter(f,'extra1list')~="");
			exf_name=GetFileParameter(f,'extraname');
			exf_ja=(GetFileParameter(f,'extrajacket')~='') and GetExFolderPath(groups[gr])..GetFileParameter(f,'extrajacket') or '';
			exf_bn=(GetFileParameter(f,'extrabanner')~='') and GetExFolderPath(groups[gr])..GetFileParameter(f,'extrabanner') or '';
			exf_color=GetFileParameter(f,'extracolor');
			CloseFile(f);
		end;
		Group[groups[gr]..'-name']=(name~="") and name or Group[groups[gr]..'-dir'];
		Group[groups[gr]..'-metertype']=(meter~="") and meter or "DDR";
		Group[groups[gr]..'-color']=color;
		Group[groups[gr]..'-banner']=SONGMAN:GetSongGroupBannerPath(groups[gr]);
		Group[groups[gr]..'-jacket']=GetGroupGPath(groups[gr]);
		Group[groups[gr]..'-exf']=exf;
		Group[groups[gr]..'-exf_name']=(exf_name~="") and exf_name or "EXFolder";
		Group[groups[gr]..'-exf_banner']=(exf_ja~="") and exf_bn or THEME:GetPathG("_wheel/exfolder","banner");
		Group[groups[gr]..'-exf_jacket']=(exf_ja~="") and exf_ja or Group[groups[gr]..'-jacket'];
		Group[groups[gr]..'-exf_color']=(exf_color~="") and Str2Color(exf_color) or Color('Red');
		SetSongColors(groups[gr],Group[groups[gr]..'-color']);
		SetSongMeterTypes(groups[gr],Group[groups[gr]..'-metertype']);
		SetSongMeter(groups[gr]);
		local songs=SONGMAN:GetSongsInGroup(groups[gr]);
		for s=1,#songs do
			local maintitle=songs[s]:GetTranslitMainTitle();
			local subtitle=songs[s]:GetTranslitSubTitle();
			if subtitle~="" then
				local title=SplitTitle(songs[s]:GetTranslitFullTitle());
				maintitle=title[1];
				subtitle=title[2];
			end;
			local artist=songs[s]:GetTranslitArtist();
		end;
	end;
	init=true;
end;
function InitSongs()
	if not init then
		InitGroups();
	end;
end;
function ReloadSongFlag()
	init=false;
end;
function GetGroups(group,prm)
	return Group[group..'-'..prm];
end;
function GetSongs(song,prm)
	return GetSongs_str(song:GetGroupName()..'/'..string.lower(GetSong2Folder(song)),prm);
end;
function GetSongs_str(path,prm)
	return Song[path..'-'..prm];
end;

-- [ja] ロード処理をしていない状態での楽曲情報取得 
-- [ja] ジュークボックスなどのゲーム画面読み込み時に使用 
function GetNoLoadSongPrm(song,prm)
	local ret='';
	if song then
		local lprm=string.lower(prm);
		local group=string.lower(song:GetGroupName());
		local song_group=string.lower(GetSong2Folder(song));
		if lprm=='metertype' or lprm=='menucolor' then
			local ini=string.lower(GetGroupParameter(group,lprm));
			local sp_ini=split(':',ini);
			local def_prm='';
			local cur_ret='';
			for i=1,#sp_ini do
				sp_sp_ini=split('|',sp_ini[i]);
				if i==1 then
					def_prm=sp_sp_ini[1];
				end;
				cur_ret=sp_sp_ini[1];
				if #sp_sp_ini>1 then
					for j=2,#sp_sp_ini do
						if sp_sp_ini[j]==song_group then
							ret=cur_ret;
							break;
						end;
					end;
				end;
				if ret~='' then
					break;
				end;
			end;
			if ret=='' then
				ret=def_prm;
			end;
		else
			ret=GetSMParameter(song,prm);
		end;
	end;
	return ret;
end;


--[ja] 現在選択中のホイールのタイプ 
local wh_style="Song";
function wh_GetCurrentType()
	return wh_style;
end;
function wh_SetCurrentType(ty)
	wh_style=ty;
end;

--[ja] 現在選択中のSong 
local wh_song;
function wh_GetCurrentSong()
	return wh_song;
end;
function wh_SetCurrentSong(s)
	wh_song=s;
end;

--[ja] 現在選択中の表示名 
local wh_label="";
function wh_GetCurrentLabel()
	return wh_label;
end;
function wh_SetCurrentLabel(ln)
	wh_label=ln;
end;

--[ja] 現在選択中の楽曲のグループ名 
local wh_group="";
function wh_GetCurrentGroup()
	return wh_group;
end;
function wh_SetCurrentGroup(gp)
	wh_group=gp;
end;

--[ja] カスタムホイール 
function SetCustomWheel()
	if not IsNetSMOnline() then
    SetEXFLastPlayedGroup();
		if IsChallEXFolder_LastGroup() then
			--return "Return,EXFolder";
			return "EXFolder";
		end;
	end;
	--return "Return";
	return "";
end;

-- [ja] 曲単体の情報を一時的に取得 