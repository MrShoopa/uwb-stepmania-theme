local t = Def.ActorFrame {};

t[#t+1]=DrillGameplay();
t[#t+1]=LoadActor(THEME:GetPathB("_Gameplay","Message"));

-- SPEED ASSIST
if not IsDrill() then
	t[#t+1] = LoadActor("speedassist",PLAYER_1);
	t[#t+1] = LoadActor("speedassist",PLAYER_2);
end;

-- [ja] 開始1.5秒間ゲーム停止
-- [ja] …の予定だったけど一部曲の背景動画がすごくずれるので0.5秒に変更
t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		if GetSMVersion()>=80 and TC_GetwaieiMode()==2 then
			local game = SCREENMAN:GetTopScreen();
			if game then
				self:queuecommand('StartPause');
				self:linear(0.5);
				self:queuecommand('ClearPause');
			end;
		end;
	end;
	StartPauseCommand=function(self)
		SCREENMAN:GetTopScreen():PauseGame(true);
	end;
	ClearPauseCommand=function(self)
		SCREENMAN:GetTopScreen():PauseGame(false);
	end;
};

-- [ja] デモ画面での曲名表示
if not GAMESTATE:IsDemonstration() then
	t[#t+1] = Def.ActorFrame{
		StandardDecorationFromFileOptional("SongTitle","SongTitle")..{
			OnCommand=function(self)
				self:zoomx(2);
				self:zoomy(0);
				self:sleep(0.5);
				self:linear(0.2);
				self:zoomx(1);
				self:zoomy(1);
			end;
		};
	};
end;

-- [ja] ゲームフレーム
t[#t+1] = LoadActor(THEME:GetPathG("_ScreenGameplay","Frame"));
if GetUserPref_Theme("UserWheelMode") == 'Jacket->Banner' then
	wheelmode = "JBN"
elseif GetUserPref_Theme("UserWheelMode") == 'Jacket->BG' then
	wheelmode = "JBG"
elseif GetUserPref_Theme("UserWheelMode") == 'Banner->Jacket' then
	wheelmode = "BNJ"
elseif GetUserPref_Theme("UserWheelMode") == 'BG->Jacket' then
	wheelmode = "BGJ"
else
	wheelmode = "JBN"
end;
local tmp={};
if GAMESTATE:IsDemonstration() then
	local title={};
	if _SONG():GetDisplaySubTitle()~="" then
		title={_SONG():GetDisplayMainTitle(),_SONG():GetDisplaySubTitle()};
	elseif SplitTitle(_SONG():GetDisplayMainTitle())[2]~="" then
		title=SplitTitle(_SONG():GetDisplayMainTitle());
	else
		title={_SONG():GetDisplayMainTitle()};
	end;
	t[#t+1]=Def.ActorFrame{
		InitCommand=cmd(zoomx,2;zoomy,0;x,SCREEN_LEFT+20;y,(not IsReverse(PLAYER_1)) and SCREEN_BOTTOM-120 or SCREEN_TOP+120);
		OnCommand=cmd(sleep,1;linear,0.3;zoomx,1;zoomy,1;);
		OffCommand=cmd(linear,0.3;zoomx,2;zoomy,0;);
		Def.Quad{
			InitCommand=cmd(diffuse,0,0,0,0.5;zoomto,SCREEN_WIDTH/2-40,100;horizalign,left;)
		};
		Def.Quad{
			InitCommand=function(self)
				self:zoomto( 88,88 );
				self:diffuse(0.1,0.1,0.1,0.75);
				self:horizalign(left);
				self:x(6);
				self:y(0);
			end;
		};
		Def.Banner{
			InitCommand=function(self)
				local wmode=GetUserPref_Theme("UserWheelMode");
				local song=_SONG();
				local bn="";
				if wmode == 'Jacket->Banner' then
					bn=GetSongGPath_JBN(song);
				elseif wmode == 'Jacket->BG' then
					bn=GetSongGPath_JBG(song);
				elseif wmode == 'Banner->Jacket' then
					bn=GetSongGPath_BNJ(song);
				elseif wmode == 'BG->Jacket' then
					bn=GetSongGPath_BGJ(song);
				elseif wmode == 'Text' then
					bn=GetSongGPath_JBN(song);
				else
					bn=GetSongGPath_JBN(song);
				end;
				if FILEMAN:DoesFileExist(bn) then
					self:LoadBackground(bn);
				else
					self:Load(THEME:GetPathG("_MusicWheel","NotFound"));
				end;
				self:scaletofit( 0,0,80,80 );
				self:horizalign(left);
				self:x(10);
				self:y(0);
				if bn==_SONG():GetBannerPath() then
					self:rate(0.5);
				else
					self:rate(1.0);
				end;
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:x(100);
				self:y((#title==1) and -25 or -30);
				self:zoom(0.75);
				self:maxwidth((SCREEN_WIDTH/2-150)/0.75)
				self:diffuse(Color("Blue"));
				self:strokecolor(Color("Outline"));
				local gn=GetGroupParameter(_SONG():GetGroupName(),"Name");
				if gn~="" then
					self:settext(gn);
				else
					self:settext(_SONG():GetGroupName());
				end;
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:x(100);
				self:y((#title==1) and 23 or 30);
				self:zoom(0.75);
				self:maxwidth((SCREEN_WIDTH/2-150)/0.75)
				self:diffuse(Color("White"));
				self:strokecolor(Color("Outline"));
				self:settext("/ ".._SONG():GetDisplayArtist());
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:visible((#title==1) and false or true)
				self:x(100);
				self:y(13);
				self:zoom(0.75);
				self:maxwidth((SCREEN_WIDTH/2-150)/0.75)
				self:diffuse(Color("White"));
				self:strokecolor(Color("Outline"));
				self:settext(title[2] or "");
			end;
		};
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:horizalign(left);
				self:x(100);
				self:y((#title==1) and 2 or -8);
				self:maxwidth((SCREEN_WIDTH/2-150))
				self:diffuse(Color("White"));
				self:strokecolor(Color("Outline"));
				self:settext(title[1]);
			end;
		};
	};
end;

t[#t+1] = LoadActor("lyric");

t[#t+1]=LoadActor(THEME:GetPathB("ScreenGameplay","ready/ready"));

return t;
