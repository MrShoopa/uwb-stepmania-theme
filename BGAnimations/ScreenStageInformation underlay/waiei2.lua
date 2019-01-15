local rander = string.lower(split(',',PREFSMAN:GetPreference('VideoRenderers'))[1]);
function GetSongBanner(song)
	if song then
		local path = song:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner")
end

local t=Def.ActorFrame{};
local song = _SONG();
local jacketmode=0;
local course=GAMESTATE:GetCurrentCourse();
local steps={};
local title={};


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

local s;
local function _S()
	if not s then
		s=_SONG2();
	end;
	return s;
end;

local scale=20;
local sizex=520;
local sizey=170;
local title={};
if rander=='opengl' then
	t[#t+1]= Def.ActorFrameTexture{
		Name = "InfoTex";
		InitCommand=function(self)
			self:SetTextureName( "InfoTex" );
			self:SetWidth(SCREEN_WIDTH/scale);
			self:SetHeight(SCREEN_HEIGHT/scale);
			self:EnableAlphaBuffer(true);
			self:Create();
		end;
		OnCommand=function(self)
			self:Draw();
			self:visible(true);
		end;
		Def.Quad{
			InitCommand=cmd(FullScreen;diffuse,0,0,0,1);
		};
		Def.Sprite{
			InitCommand=function(self)
				local s=_S();
				local g='';
				if s and s:HasBackground() then
					g=s:GetBackgroundPath()
				else
					g=THEME:GetPathG('common','fallback background');
				end;
				self:LoadBackground(g);
				self:scaletofit(0,0,SCREEN_WIDTH/scale,SCREEN_HEIGHT/scale);
			end;
			OnCommand=cmd(diffuse,1,1,1,PREFSMAN:GetPreference('BGBrightness'));
		};
	};
	t[#t+1]=Def.ActorFrame{
		Def.Sprite{
			Texture = "InfoTex";
			OnCommand=function(self)
				self:FullScreen();
				self:x(0);
				self:y(0);
				self:cropleft(0);
				self:cropright(0);
				self:croptop(0);
				self:cropbottom(0);
				self:sleep(1.0);
				self:accelerate(0.4);
				self:cropleft((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
				self:cropright((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
				self:croptop((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
				self:cropbottom((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
			end;
		};
		OnCommand=function(self)
			self:Center();
			self:SetDrawByZPosition(true);
			self:draworder(10000);
		end;
	};
else
	t[#t+1]=Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(blend,'BlendMode_Add';diffuse,0.8,0.9,1,0.5;FullScreen);
			OnCommand=function(self)
				self:x(0);
				self:y(0);
				self:cropleft(0);
				self:cropright(0);
				self:croptop(0);
				self:cropbottom(0);
				self:sleep(1.0);
				self:accelerate(0.4);
				self:cropleft((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
				self:cropright((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
				self:croptop((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
				self:cropbottom((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
			end;
		};
		OnCommand=function(self)
			self:Center();
			self:SetDrawByZPosition(true);
			self:draworder(10000);
		end;
		HereWeGoMessageCommand=cmd(diffusealpha,1.0;sleep,0.5;linear,0.5;diffusealpha,0);
	};
end;
t[#t+1]=Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(diffuse,Color('White'));
		OnCommand=function(self)
			self:FullScreen();
			self:x(0);
			self:y(0);
			self:linear(1.0);
			self:diffusealpha(0.25);
			self:accelerate(0.4);
			self:diffusealpha(0);
			self:zoomto(sizex,sizey);
		end;
	};
	LoadActor(THEME:GetPathG("_objects/_ready","frame"))..{
		InitCommand=cmd(diffusealpha,0);
		OnCommand=function(self)
			self:FullScreen();
			self:x(0);
			self:y(0);
			self:zoomx(SCREEN_WIDTH/sizex);
			self:zoomy(SCREEN_HEIGHT/sizey);
			self:sleep(1.0);
			self:accelerate(0.4);
			self:diffusealpha(1);
			self:zoomto(sizex+10,sizey+10);
		end;
	};
	Def.ActorFrame{
		OnCommand=function(self)
			self:addx(100);
			self:diffusealpha(0);
			self:sleep(1.0);
			self:accelerate(0.2);
			self:addx(-100);
			self:diffusealpha(1);
		end;
		Def.Quad{
			InitCommand=function(self)
				self:diffuse(0,0,0,0.5);
				self:zoomto(162,162);
				self:x(-175);
				self:y(0);
			end;
		};
		Def.Sprite{
			InitCommand=function(self)
				local s=_S();
				local g='';
				if s then
					local tmp={};
					tmp=GetBannerStat(s,GetWheelMode());
					g=tmp[1];
				else
					g=THEME:GetPathG('common','fallback jacket');
				end;
				self:LoadBackground(g);
				self:scaletofit(0,0,160,160);
				self:x(-175);
				self:y(0);
			end;
		};
		LoadFont("Common normal") .. {
			InitCommand=function(self)
				local s=_S();
				self:horizalign(left);
				title=GetSplitTitle(s);
				self:x(-70);
				if title[2]~="" then
					self:y(8);
				else
					self:y(20);
				end;
				self:maxwidth(310/1.2);
				self:zoom(1.2);
				self:settextf("%s",title[1]);
				self:strokecolor(0,0,0,0.5);
				self:diffusealpha(0);
				self:diffusealpha(1);
			end;
		};
		LoadFont("Common normal") .. {
			InitCommand=function(self)
				self:horizalign(left);
				self:x(-70);
				self:y(32);
				self:maxwidth(310/0.9);
				self:zoom(0.9);
				self:settextf("%s",title[2]);
				self:strokecolor(0,0,0,0.5);
				self:diffusealpha(0);
				self:diffusealpha(1);
			end;
		};
		LoadFont("Common normal") .. {
			Name="SARTIST";
			InitCommand=function(self)
				local s=_S();
				self:horizalign(left);
				self:x(-70);
				if title[2]~="" then
					self:y(60);
				else
					self:y(56);
				end;
				self:maxwidth(310);
				self:settextf("%s",s:GetDisplayArtist());
				self:strokecolor(0,0,0,0.5);
				self:diffusealpha(0);
				self:diffusealpha(1);
			end;
		};
	};
	OnCommand=function(self)
		self:Center();
		self:SetDrawByZPosition(true);
		self:draworder(10000);
	end;
};

--[[
local tmp={};
local zure=2;
local zure=2.5;
local dpos={1,5,7,3,0,2,8,6,4};
for i=1,9 do
	t[#t+1]=Def.ActorFrame{
		OnCommand=function(self)
			self:Center();
			self:diffusealpha(0);
			self:linear(0.5);
			self:diffusealpha(1);
		end;
		Def.Sprite{
			BeginCommand=function(self)
				self:LoadFromCurrentSongBackground();
				self:scaletofit(-SCREEN_CENTER_X,-SCREEN_CENTER_Y,SCREEN_CENTER_X,SCREEN_CENTER_Y);
				self:diffusealpha(0.1);
				self:x((math.floor(dpos[i]%3)-1)*zure);
				self:y((math.floor(dpos[i]/3)-1)*zure);
			end;
		};
	};
end;
t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		self:Center();
		self:diffusealpha(0);
	--	self:sleep(0.3);
		self:linear(0.2);
		self:diffusealpha(1);
	end;
	Def.Quad{
		BeginCommand=function(self)
			self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
			self:blend("BlendMode_Add");
			self:diffuse(0.64,0.8,1,0.5);
		end;
	};
	Def.Quad{
		BeginCommand=function(self)
			self:zoomto(280,280);
			self:diffuse(0,0,0,0.5);
			self:rotationz(-45);
			self:addy(-SCREEN_CENTER_Y-200);
			self:decelerate(0.3);
			self:addy(SCREEN_CENTER_Y+200);
			self:sleep(0.5);
			self:linear(1.0);
			self:rotationy(360);
			self:sleep(0.2);
		end;
	};
	Def.Sprite{
		BeginCommand=function(self)
			tmp=GetBannerStat(_SONG2(),wheelmode);
			self:Load(tmp[1]);
			self:scaletofit(-136,-136,136,136)
			self:rotationz(-45);
			self:addy(-SCREEN_CENTER_Y-200);
			self:sleep(0.4);
			self:decelerate(0.4);
			self:addy(SCREEN_CENTER_Y+200);
			self:linear(1.0);
			self:rotationy(360);
			self:sleep(0.2);
		end;
	};
	LoadActor(THEME:GetPathG("_objects/_wheel","glass"))..{
		BeginCommand=function(self)
			self:zoomto(276,276);
			self:diffusealpha(0);
			self:rotationz(-45);
			self:addy(-SCREEN_CENTER_Y-200);
			self:decelerate(0.3);
			self:addy(SCREEN_CENTER_Y+200);
			self:sleep(0.3);
			self:linear(0.2);
			self:diffusealpha(1);
			self:linear(1.0);
			self:rotationy(360);
			self:sleep(0.2);
		end;
	};
};


t[#t+1]=Def.ActorFrame{
	Lyric_Egg_S();
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y+100);
	end;
	OnCommand=cmd(diffusealpha,0;
		linear,0.2;diffusealpha,1;diffusealpha,1;
		sleep,1.3;linear,0.2;diffusealpha,0);
	Def.Actor{
		InitCommand=function(self)
			steps={GAMESTATE:GetCurrentSteps(GetSidePlayer(PLAYER_1)),GAMESTATE:GetCurrentSteps(GetSidePlayer(PLAYER_2))};
			if (not song) and course then
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
				local e = trail:GetTrailEntries()
				if #e > 0 then
					song = e[1]:GetSong()
					steps={e[1]:GetSteps(),e[1]:GetSteps()};
				end;
			end;
		end;
	};
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			title=GetSplitTitle(song);
			self:x(0);
			if title[2]~="" then
				self:y(-32);
			else
				self:y(-20);
			end;
			self:maxwidth(410/1.2);
			self:zoom(1.2);
			self:settextf("%s",title[1]);
			self:strokecolor(Color("Black"));
			self:diffusealpha(0);
			self:addx(-90);
			self:addx(90);
			self:diffusealpha(1);
		end;
	};
	LoadFont("Common normal") .. {
		InitCommand=function(self)
			self:x(0);
			self:y(-8);
			self:maxwidth(410/0.9);
			self:zoom(0.9);
			self:settextf("%s",title[2]);
			self:strokecolor(Color("Black"));
			self:diffusealpha(0);
			self:addx(-90);
			self:addx(90);
			self:diffusealpha(1);
		end;
	};
	LoadFont("Common normal") .. {
		Name="SARTIST";
		InitCommand=function(self)
			self:x(0);
			if title[2]~="" then
				self:y(20);
			else
				self:y(16);
			end;
			self:maxwidth(410);
			self:settextf("%s",song:GetDisplayArtist());
			self:strokecolor(Color("Black"));
			self:diffusealpha(0);
			self:addx(-90);
			self:addx(90);
			self:diffusealpha(1);
		end;
	};
};
--]]

return t;
