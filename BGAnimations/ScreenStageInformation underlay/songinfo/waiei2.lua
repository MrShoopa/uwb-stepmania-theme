local rander = string.lower(split(',',PREFSMAN:GetPreference('VideoRenderers'))[1]);
local function GetSongBanner(song)
	if song then
		local path = song:GetBannerPath()
		if path then return path end
	end
	return THEME:GetPathG("Common","fallback banner");
end
local function GetSongBG(song)
	if song and song:HasBackground() then
		g=song:GetBackgroundPath()
	else
		g=THEME:GetPathG('common','fallback background');
	end;
	return g;
end

local t=Def.ActorFrame{};
local song = _SONG();
local jacketmode=0;
local course=GAMESTATE:GetCurrentCourse();
local steps={};
local title={};

local wheelmode = getWheelMode();

local s;
local function _S()
	if not s then
		s=_SONG2();
	end;
	return s;
end;

local scale=20;
local sizex=SCREEN_WIDTH+2;
local sizey=100;
local function TexOnCommand(self,alpha)
	self:x(0);
	self:y(0);
	self:cropleft(0);
	self:cropright(0);
	self:croptop(0);
	self:cropbottom(0);
	self:diffusealpha(0);
	self:linear(0.5);
	self:diffusealpha(alpha);
--[[	
	self:sleep(0.5);
	self:accelerate(0.4);
	self:cropleft((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
	self:cropright((SCREEN_WIDTH-sizex)/2/SCREEN_WIDTH);
	self:croptop((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
	self:cropbottom((SCREEN_HEIGHT-sizey)/2/SCREEN_HEIGHT);
--]]
end;
local title={};
t[#t+1]= Def.ActorFrame{
	Def.Actor{
		InitCommand=function(self)
			s=_S();
		end;
	};
	LoadActor(THEME:GetPathG('_Song','BG'))..{
		InitCommand=cmd(Center);
	};
	Def.Quad{
		InitCommand=cmd(FullScreen;Center;diffuse,0,0,0,0;
			linear,0.4;diffuse,0,0,0,1.0-PREFSMAN:GetPreference('BGBrightness'));
	};
};

t[#t+1]=LoadActor(
  THEME:GetPathG("_Filter", "blur"),
  THEME:GetPathG("_Song", "bg/blur"),
  GetwaieiBulrSize(), true, ""
);
t[#t+1]=LoadActor(THEME:GetPathG("_Song","bg"))..{
	OnCommand=cmd(
		Center;
		linear,0.3;
		diffusealpha,0
	);
};
local bn_w=160;
local bn_h= 90;
local g;
local w;
local h;
t[#t+1]=Def.ActorFrame{
	LoadActor(THEME:GetPathG("_objects/_ready","frame"))..{
		InitCommand=cmd(diffusealpha,0);
		OnCommand=function(self)
			self:zoomto(SCREEN_WIDTH+50,SCREEN_HEIGHT+50);
			self:x(0);
			self:y(0);
			self:accelerate(0.4);
			self:diffusealpha(1);
			--self:sleep(1.0);
			--self:zoomto(sizex+20,sizey+4);
		end;
	};
	--[[
	Def.ActorFrame{
		OnCommand=function(self)
			self:addx(100);
			self:diffusealpha(0);
			self:sleep(1.0);
			self:accelerate(0.2);
			self:addx(-100);
			self:diffusealpha(1);
		end;
		Def.Sprite{
			InitCommand=function(self)
				g=GetSongBanner(s);
				self:LoadBackground(g);
				w=self:GetWidth();
				h=self:GetHeight();
				self:visible(false);
			end;
		};
		Def.Quad{
			InitCommand=function(self)
				self:diffuse(0,0,0,0.5);
				self:zoomto(bn_w+2,bn_w*h/w+2);
				self:x(-175);
				self:y(0);
			end;
		};
		Def.Sprite{
			InitCommand=function(self)
				self:LoadBackground(g);
				if w/h>bn_w/bn_h then
					self:scaletofit(0,0,bn_w,bn_h);
				else
					self:scaletocover(0,0,bn_w,bn_h);
					local cr=(bn_w*h/w-bn_h)/2/(bn_w*h/w);
					self:croptop(cr);
					self:cropbottom(cr);
				end;
				self:x(-175);
				self:y(0);
			end;
		};
		LoadActor(THEME:GetPathG('_Song','title'),320,left)..{
			InitCommand=function(self)
				self:x(-70);
				self:y(0);
			end;
		};
	};
	--]]
	OnCommand=function(self)
		self:Center();
		self:SetDrawByZPosition(true);
		self:draworder(10000);
	end;
};

return t;
