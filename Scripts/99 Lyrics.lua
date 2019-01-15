local lrc_egg=false;

function Lyric_Egg_S()
	lrc_egg=GetUserPref_Theme("UserLyricEgg")=="true";
	local t=Def.ActorFrame{
		CodeCommand=function(self,params)
			if params.Name=="LyricEgg" then
				lrc_egg=(not lrc_egg);
			--	Setwaiei("LyricEgg",lrc_egg);
				SetUserPref_Theme("UserLyricEgg",lrc_egg);
			end;
		end;
		LoadActor(THEME:GetPathS("Common","start"))..{
			CodeCommand=function(self,params)
				if params.Name=="LyricEgg" then
					self:stop();
					self:play();
				end;
			end;
		};
	};
	return t;
end;

--[ja] 歌詞の点滅(SM5のバグ？)を防ぐため、あらかじめ表示時間を取得しておく 
local lrc_showed=1;
local lrc_max=0;
local lrc_table={};
local lrc_text={};
local lrc_time={};
local lrc_col={};
function LyricInit()
	local song=_SONG2();
	local lrc_type=0;
	lrc_showed=1;
	lrc_max=0;
	lrc_table={};
	lrc_text={};
	lrc_time={};
	lrc_col={};
	if not song:HasLyrics() then
		return;
	end;
	if not FILEMAN:DoesFileExist(song:GetLyricsPath()) then
		return;
	end;
	local group=song:GetGroupName();
	if string.lower(GetGroupParameter(group,"lyrictype"))=="old" then
		lrc_type=1;
	end;
	local f=OpenFile(song:GetLyricsPath());
	local tc="ffffff";
	while true do
		local l=f:GetLine();
		local ll=string.lower(l);
		--[ja] [00:00:00]XXX のパターンに合致 
		if string.find(ll,"^.*%[%d.*%].*") then
			lrc_max=lrc_max+1
			local t1=split("%[",l)[2];
			local t2=split("%]",t1);
		--[ja] [00:00.00]この書き方をしてることがあるので[00:00:00]に直す 
			t2[1]=string.gsub(t2[1],"%.",":");
			local t3=split(":",t2[1]);
			lrc_text[lrc_max]=string.gsub(t2[2],"|","\n");
			lrc_time[lrc_max]=string.format("%08.3f",tonumber(t3[1])*60+tonumber(t3[2])+tonumber("0."..t3[3]));
			lrc_table[lrc_max]=lrc_time[lrc_max].."]"..lrc_text[lrc_max].."]"..tc;
		elseif string.find(ll,"^.*%[col.*%].*") then
			local t1=split("x",ll);
			tc=t1[2];
		end;
		if f:AtEOF() then
			break;
		end;
	end;
	CloseFile(f);
	-- [ja] アルファベット順ソート 
	table.sort(lrc_table,
		function(a,b)
			return (a < b)
		end);
	local cnt=0;
	for i=1,lrc_max do
		cnt=cnt+1;
		local t1=split("%]",lrc_table[i]);
		if lrc_type==1 and cnt>1 then
			if tonumber(t1[1])-lrc_time[cnt-1]>3 then
				lrc_time[cnt]=lrc_time[cnt-1]+3;
				lrc_text[cnt]="";
				lrc_col[cnt]=lrc_col[cnt-1];
				cnt=cnt+1;
			end;
		end;
		lrc_time[cnt]=tonumber(t1[1]);
		lrc_text[cnt]=t1[2];
		lrc_col[cnt]=t1[3];
	end;
	if lrc_type==1 and cnt>1 then
		cnt=cnt+1;
		lrc_time[cnt]=lrc_time[cnt-1]+3;
		lrc_text[cnt]="";
		lrc_col[cnt]=lrc_col[cnt-1];
	end;
	lrc_max=cnt;
end;

local lrc_anime=0.2;
local lrc_chksec=0.1;
local course_song;
function LyricSet()
	local t=Def.ActorFrame{
		FOV=50;
		InitCommand=function(self)
			local rp=0;
			for pn in ivalues(PlayerNumber) do
				if IsReverse(pn) then
					rp=rp+1;
				end;
			end;
			if GAMESTATE:IsDemonstration() then
				(THEME:GetMetric("ScreenGameplay","LyricDisplaySetOneReverseCommand"))(self);
			elseif rp==0 then
				(THEME:GetMetric("ScreenGameplay","LyricDisplaySetNoReverseCommand"))(self);
			elseif rp==GAMESTATE:GetNumPlayersEnabled() then
				(THEME:GetMetric("ScreenGameplay","LyricDisplaySetReverseCommand"))(self);
			else
				(THEME:GetMetric("ScreenGameplay","LyricDisplaySetOneReverseCommand"))(self);
			end;
			LyricInit();
			course_song=_SONG2();
		end;
		LrcCommand=function(self)
			local rp=0;
			for pn in ivalues(PlayerNumber) do
				if IsReverse(pn) then
					rp=rp+1;
				end;
			end;
			if GAMESTATE:IsDemonstration() then
				(THEME:GetMetric("ScreenGameplay","LyricDisplaySetOneReverseCommand"))(self);
			elseif rp==0 then
				(THEME:GetMetric("ScreenGameplay","LyricDisplaySetNoReverseCommand"))(self);
			elseif rp==GAMESTATE:GetNumPlayersEnabled() then
				(THEME:GetMetric("ScreenGameplay","LyricDisplaySetReverseCommand"))(self);
			else
				(THEME:GetMetric("ScreenGameplay","LyricDisplaySetOneReverseCommand"))(self);
			end;
		end;
		OnCommand=cmd(sleep,0.1;queuecommand,"Loop");
		LoadFont("Common Normal")..{
			Name="Lyric";
			InitCommand=cmd(strokecolor,Color("Black");shadowlengthy,5;diffusealpha,0;);
			LrcCommand=function(self)
				self:finishtweening();
				self:maxwidth(SCREEN_WIDTH-20);
				self:settext(lrc_text[lrc_showed-1]);
				self:diffuse(color("#"..lrc_col[lrc_showed-1]));
				if lrc_egg then
					self:maxwidth(SCREEN_WIDTH/1.5-40);
					self:x(40);
					self:y(-20);
					self:diffusealpha(0);
					self:zoom(4.2);
					self:rotationy(-180);
					self:linear(lrc_anime);
					self:rotationy(-45);
					self:diffusealpha(0.75);
					self:zoomx(1.5);
					self:zoomy(1.3);
				else
					self:diffusealpha(0);
					self:zoom(1.2);
					self:linear(lrc_anime);
					self:diffusealpha(0.75);
					self:zoom(1.0);
				end;
				if (lrc_showed-1)<lrc_max and lrc_text[lrc_showed]=="" then
					self:sleep(math.max(lrc_time[lrc_showed]-lrc_time[lrc_showed-1]-lrc_anime*2,0));
					self:linear(lrc_anime);
					self:diffusealpha(0);
				end;
			end;
		};
		LoopCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				if not course_song or course_song~=_SONG2() then
					self:queuecommand("Init");
				end;
			end;
			if lrc_max>0 then
				if lrc_time[lrc_showed] then
					if _MUSICSECOND()>=lrc_time[lrc_showed]-lrc_anime/2 then
						lrc_showed=lrc_showed+1;
						self:queuecommand("Lrc");
					end;
				end;
			end;
			self:sleep(lrc_chksec);
			self:queuecommand("Loop");
		end;
	};
	return t;
end;
