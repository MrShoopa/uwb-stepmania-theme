local t = Def.ActorFrame {};

t[#t+1]=DrillGameplay();

if not IsDrill() then
	t[#t+1] = LoadActor("speedassist",PLAYER_1);
	t[#t+1] = LoadActor("speedassist",PLAYER_2);
end;

local wait=0;

if not GAMESTATE:IsDemonstration() then
	t[#t+1] = Def.ActorFrame{
		StandardDecorationFromFileOptional("SongTitle","SongTitle")..{
			OnCommand=function(self)
				self:zoomx(2);
				self:zoomy(0);
				self:sleep(wait+0.5);
				self:linear(0.2);
				self:zoomx(1);
				self:zoomy(1);
			end;
		};
	};
end;
t[#t+1] = LoadActor(THEME:GetPathG("_ScreenGameplay","Frame"));
t[#t+1] = StandardDecorationFromFileOptional("ScoreFrameP1","ScoreFrameP1");
t[#t+1] = StandardDecorationFromFileOptional("ScoreFrameP2","ScoreFrameP2");
t[#t+1] = Def.ActorFrame{
	LoadActor(THEME:GetPathB("ScreenGameplay","overlay/score"),PLAYER_1)..{
		InitCommand=cmd(player,PLAYER_1;
			x,THEME:GetMetric("ScreenGameplay","ScoreP1X");
			y,THEME:GetMetric("ScreenGameplay","ScoreP1Y"););
	};
	LoadActor(THEME:GetPathB("ScreenGameplay","overlay/score"),PLAYER_2)..{
		InitCommand=cmd(player,PLAYER_2;
			x,THEME:GetMetric("ScreenGameplay","ScoreP2X");
			y,THEME:GetMetric("ScreenGameplay","ScoreP2Y"););
	};
};
t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
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
if TC_GetwaieiMode()==2 then
	t[#t+1]=Def.ActorFrame{
		LoadActor("ready_waiei2");
	};
else
	t[#t+1]=Def.ActorFrame{
		LoadActor("ready_waiei1");
	};
end;

--[[
t[#t+1] = Def.ActorFrameTexture{
	Name = "ScreenTex";
	InitCommand=function(self)
		self:SetTextureName( "ScreenTex" );
		self:SetWidth(SCREEN_WIDTH);
		self:SetHeight(SCREEN_HEIGHT);
		self:EnableAlphaBuffer(true);
		self:Create();
	end;
	OnCommand=function(self)
		self:visible(true);
		self:Draw();
	end;
	Def.Quad{ OnCommand=cmd(Center;FullScreen;diffuse,0,0,0,1), },
	Def.Sprite{
		InitCommand=function(self)
			self:LoadBackground(_SONG2():GetBackgroundPath());
		end;
		OnCommand=cmd(Center;FullScreen;diffuse,1,1,1,PREFSMAN:GetPreference('BGBrightness')),
	},
	Def.ActorProxy{ Name = "ProxyUL"; OnCommand=function(self) self:x(0); self:y(0); self:SetTarget(SCREENMAN:GetTopScreen():GetChild('Underlay')); end },
	Def.ActorProxy{ Name = "ProxyUL"; OnCommand=function(self) self:x(0); self:y(0); self:SetTarget(SCREENMAN:GetTopScreen():GetChild('SongBackground')); end },
	Def.ActorProxy{ Name = "ProxyP1"; OnCommand=function(self) self:x(0); self:y(0); self:SetTarget(SCREENMAN:GetTopScreen():GetChild('PlayerP1')); end },
	Def.ActorProxy{ Name = "ProxyP2"; OnCommand=function(self) self:x(0); self:y(0); self:SetTarget(SCREENMAN:GetTopScreen():GetChild('PlayerP2')); end },
	--Def.ActorProxy{ Name = "ProxyOL"; OnCommand=function(self) self:x(0); self:y(0) self:SetTarget(SCREENMAN:GetTopScreen():GetChild('Overlay')); end },
};
local px={0,r,0,-r,0,0};
local py={0,0,0,0,-r,r};
local pz={r,0,-r,0,0,0};
local rx={0,0,0,0,90,-90};
local ry={0,90,180,270,0,0};
local b=Def.ActorFrame{
	FOV=90;
	InitCommand=cmd(SetDrawByZPosition,true);
	OnCommand=cmd(Center;rotationz,0;rotationx,0;linear,90;rotationz,360;rotationx,-360);
};
for i=1,6 do
	b[#b+1] = Def.Sprite{
		Texture = "ScreenTex";
		InitCommand=function(self)
			self:blend('BlendMode_Add');
			self:x(px[i]);
			self:y(py[i]);
			self:z(pz[i]);
			self:rotationx(rx[i]);
			self:rotationy(ry[i]);
		end;
	};
end;
local b=Def.ActorFrame{
	FOV=90;
	InitCommand=cmd(SetDrawByZPosition,true;rotationx,-30;bob);
	--InitCommand=cmd(SetDrawByZPosition,true;);
	--OnCommand=cmd(rotationx,0;linear,90;rotationx,-360);
};
local m=24;
for i=1,m do
b[#b+1] = Def.Sprite{
	Texture = "ScreenTex";
	InitCommand=function(self)
		local base=1.0/m;
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y);
		self:z(-150);
		self:cropleft(base*(i-1));
		self:cropright(base*(m-i));
		self:rotationy(45*i/m);
	end;
};
end;
t[#t+1] = b;
--]]

t[#t+1] = LoadActor("lyric");

return t;
