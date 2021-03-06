local function GetSongBanner(_song)
	if _song then
		local path = _song:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner")
end

local t;
local song;-- = SCREENMAN:GetTopScreen():GetNextCourseSong();
local steps;
local jacketmode=0;

t=Def.ActorFrame{
	Def.Quad{
		BeforeLoadingNextCourseSongMessageCommand=function(self)
			self:visible(false);
			song=SCREENMAN:GetTopScreen():GetNextCourseSong();
			steps=_STEPSNext(GetSidePlayer(PLAYER_1));
			if song then
				-- [ja] こっそりBGA to Lua 
				BGAtoLUA(song);
				-- [ja] こっそりコンフィグ設定登録
				SetwaieiInfo("BGScale",GetUserPref_Theme("UserBGScale"));
				SetwaieiInfo("Haishin",GetUserPref_Theme("UserHaishin"));
				--[[
				-- [ja] こっそりSM5非対応命令保存 
				local var;
				var=GetSMParameter(song,"menucolor");
				if var~="" then
					SetExtendedParameter(song,"menucolor",var);
				end;
				var=GetSMParameter(song,"metertype");
				if var~="" and var~="DDR" then	-- [ja] DDRはデフォルトなので保存する必要ない 
					SetExtendedParameter(song,"metertype",var);
				end;
				var=GetSMParameter(song,"bgaspectratio");
				if var~="" then 
					SetExtendedParameter(song,"BGAspectRatio",var);
				end;
				SetwaieiInfo("BGRatio",var);
				--]]
				var=ReadUOP(song,"bgaspectratio");
				SetwaieiInfo("BGRatio",var);
				--[ja] 動画の切り替え時と最初のステップの時間差が1秒未満の場合余白を設定 
				--     何故か3.9と比較してちょっと遅めに再生されるので0.1秒早めに再生することでゴリ押し回避 
				--     -10000.0とか設定されてると落ちるんで-4.0まで 
				var=GetSMParameter(song,"bgchanges");
				local prm;
				local min_offset=TC_GetMetric('Wait','GameplayIn');
				local min_sec=min_offset;
				if var~="" then
					local file_offset=0.0;
					prm=split(",",var);
					for i=1,#prm do
						if string.find(prm[i],".avi",0,true) or string.find(prm[i],".mpg",0,true)
							or string.find(prm[i],".mpeg",0,true) or string.find(prm[i],".flv",0,true)
							or string.find(prm[i],".mp4",0,true) then
							file_offset=tonumber(split("=",prm[i])[1]);
							break;
						end;
					end;
					local movie_start=PlayerBeat2Sec(GetSidePlayer(PLAYER_1),file_offset);
					local movie_offset=0;
					if movie_start<0 then
						movie_offset=-movie_start+0.1;	-- [ja] 完全に同じタイミングにするとフェード処理がされないので0.1秒多めにとる 
					else
						movie_offset=0;
					end;
					if movie_offset>min_offset then
						-- movie_start=movie_offset-0.1;
						min_sec=math.min(movie_offset,10.0);
					else
						min_sec=min_offset;
					end;
				end;
				var=GetSMParameter(song,"fgchanges");
				if var~="" then
					local file_offset=0.0;
					prm=split(",",var);
					for i=1,#prm do
						if string.find(prm[i],".avi",0,true) or string.find(prm[i],".mpg",0,true)
							or string.find(prm[i],".mpeg",0,true) or string.find(prm[i],".flv",0,true)
							or string.find(prm[i],".mp4",0,true) then
							file_offset=tonumber(split("=",prm[i])[1]);
							break;
						end;
					end;
					local movie_start=PlayerBeat2Sec(GetSidePlayer(PLAYER_1),file_offset);
					local movie_offset=0;
					if movie_start<0 then
						movie_offset=-movie_start+0.1;	-- [ja] 完全に同じタイミングにするとフェード処理がされないので0.1秒多めにとる 
					else
						movie_offset=0;
					end;
					if movie_offset>min_offset then
						-- movie_start=movie_offset-0.1;
						min_sec=math.min(movie_offset,10.0);
					else
						min_sec=min_offset;
					end;
				end;
				SetwaieiInfo("BGStart",math.max(min_sec,min_offset));
				--
			end;
		end;
		ChangeCourseSongInMessageCommand=cmd(playcommand,"BeforeLoadingNextCourseSong");
	};
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;Center;);
		StartCommand=cmd(diffuse,Color("Black");diffusealpha,1.0-PREFSMAN:GetPreference("BGBrightness"));
		FinishCommand=cmd(diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_Ready","Background")) .. {
		Name="BG";
		InitCommand=cmd(Center;);
		StartCommand=cmd(diffusealpha,0;zoom,2;linear,0.25;diffusealpha,1;zoomy,1.5;zoomtowidth,SCREEN_WIDTH;
		--sleep,1.5;
		linear,0.25;zoomy,1;sleep,1.5);
		FinishCommand=cmd(diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_Ready","Light L")) .. {
		Name="RLIGHTL";
		InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;Center;blend,'BlendMode_Add';);
		StartCommand=cmd(diffuse,_DifficultyCOLOR(""..steps:GetDifficulty());addx,220;diffusealpha,0;
			--sleep,0.5;
			linear,0.45;addx,-220;diffusealpha,0.8;sleep,0.05;diffusealpha,1;sleep,0.5);
		FinishCommand=cmd(diffusealpha,0);
	};
	LoadActor(THEME:GetPathG("_Ready","Light R")) .. {
		Name="RLIGHTR";
		InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;Center;blend,'BlendMode_Add';);
		StartCommand=cmd(diffuse,_DifficultyCOLOR(""..steps:GetDifficulty());addx,-220;diffusealpha,0;
			--sleep,0.5;
			linear,0.45;addx,220;diffusealpha,0.8;sleep,0.05;diffusealpha,1;sleep,0.5);
		FinishCommand=cmd(diffusealpha,0);
		};
	Def.Sprite{
		Name="PICTG";
		StartCommand=function(self)
			self:LoadBackground(GetSongBanner(song));
			jacketmode=0;
			self:scaletofit(0,0,192,192);
			local cr=math.max((self:GetHeight()-(self:GetWidth()*0.3125))/2/self:GetHeight(),0.0);
			self:croptop(cr);
			self:cropbottom(cr);
			self:y(SCREEN_CENTER_Y);
			self:x(SCREEN_CENTER_X-210);
			self:diffusealpha(0);
			self:addx(-30);
		--	self:sleep(1.8);
			self:linear(0.2);
			self:addx(30);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
		FinishCommand=cmd(diffusealpha,0);
		--InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;Center;diffuse,Color("Blue");blend,'BlendMode_Add';);
--		OnCommand=cmd(diffusealpha,1;sleep,2.5;linear,0.5;diffusealpha,0;x,SCREEN_WIDTH;);
--		OnCommand=cmd(diffusealpha,1;sleep,2.5;cropright,0;diffuseleftedge,1,1,1,1;linear,0.5;diffusealpha,0;x,SCREEN_WIDTH;cropright,1;diffuseleftedge,1,1,1,0;);
	};
	Def.Sprite{
		Name="PICTF";
		BeforeLoadingNextCourseSongMessageCommand=function(self)
			self:LoadBackground(THEME:GetPathG("_Frame","Banner"));
		end;
		StartCommand=function(self)
		--[[
			if jacketmode==1 then
				self:LoadBackground(THEME:GetPathG("_Frame","Jacket"));
				self:scaletofit(0,0,200,200);
				self:y(SCREEN_CENTER_Y-40);
			else
		--]]
			self:scaletofit(0,0,200,200);
			self:y(SCREEN_CENTER_Y);
			self:x(SCREEN_CENTER_X-210);
			self:diffusealpha(0);
			self:addx(-30);
		--	self:sleep(1.8);
			self:linear(0.2);
			self:addx(30);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
		FinishCommand=cmd(diffusealpha,0);
		--InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;Center;diffuse,Color("Blue");blend,'BlendMode_Add';);
--		OnCommand=cmd(diffusealpha,1;sleep,2.5;linear,0.5;diffusealpha,0;x,SCREEN_WIDTH;);
--		OnCommand=cmd(diffusealpha,1;sleep,2.5;cropright,0;diffuseleftedge,1,1,1,1;linear,0.5;diffusealpha,0;x,SCREEN_WIDTH;cropright,1;diffuseleftedge,1,1,1,0;);
	};
	LoadFont("Common normal") .. {
		Name="STITLE";
		StartCommand=function(self)
			self:horizalign(left);
			self:x(SCREEN_CENTER_X-102);
			self:y(SCREEN_CENTER_Y-14);
			self:maxwidth(410/1.2);
			self:zoom(1.2);
			self:settextf("%s",song:GetDisplayFullTitle());
			self:strokecolor(Color("Outline"));
			self:diffusealpha(0);
			self:addx(-90);
		--	self:sleep(1.8);
			self:linear(0.2);
			self:addx(90);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
		FinishCommand=cmd(diffusealpha,0);
	};
	LoadFont("Common normal") .. {
		Name="SARTIST";
		StartCommand=function(self)
			self:horizalign(left);
			self:x(SCREEN_CENTER_X-100);
			self:y(SCREEN_CENTER_Y+16);
			self:maxwidth(410);
			self:settextf("%s",song:GetDisplayArtist());
			self:strokecolor(Color("Outline"));
			self:diffusealpha(0);
			self:addx(-90);
		--	self:sleep(1.8);
			self:linear(0.2);
			self:addx(90);
			self:diffusealpha(1);
			self:sleep(0.5);
		end;
		FinishCommand=cmd(diffusealpha,0);
	};
};

return t;
