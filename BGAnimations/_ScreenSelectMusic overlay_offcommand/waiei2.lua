local function GetSongBG(song)
	if song and song:HasBackground() then
		g=song:GetBackgroundPath()
	else
		g=THEME:GetPathG('common','fallback background');
	end;
	return g;
end
local alpha = PREFSMAN:GetPreference('BGBrightness');
local wheelmode = getWheelMode();
local size=190;
local weight=8;
local speed = 0.3;
local color = {0.5,0.7,1.0,0.0};
local t = Def.ActorFrame{};
t[#t+1]=LoadActor(THEME:GetPathG("_Song","bg/off"))..{
	OnCommand=cmd(
		Center;
		diffusealpha,0
	);
	OffCommand=cmd(
		zoom,1.2;
		sleep,0.5;
		linear,0.3;
		zoom,1.0;
		diffusealpha,1;
	);
};
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(Center);
	StartMessageCommand=cmd(playcommand,'Off');
	Def.Sprite {
		InitCommand=cmd(zoom,0);
		OffCommand=function(self)
			local g=GetBannerStat(_SONG2(),wheelmode);
			self:LoadBackground(g[1]);
			local w=self:GetWidth();
			local h=self:GetHeight();
			if w>h then
				local cr=(w-h)/w/2;
				self:cropleft(cr);
				self:cropright(cr);
			else
				self:cropleft(0);
				self:cropright(0);
			end;
			self:zoomto(size*2,0);
			self:smooth(speed);
			self:scaletocover(-size,-size,size,size);
			self:sleep(0.1);
			self:smooth(speed-0.1);
			self:scaletocover(-size*1.1,-size*1.1,size*1.1,size*1.1);
			self:diffusealpha(0);
		end;
	};
	Def.Quad{
		InitCommand=cmd(diffuse,color;blend,'BlendMode_Add';zoomto,SCREEN_WIDTH,weight;y,-size);
		OffCommand=function(self)
			self:cropleft(1);
			self:smooth(speed);
			self:cropleft(0);
			self:diffusealpha(1);
			self:cropright(0);
			self:smooth(speed);
			self:cropright(1);
		end;
	};
	Def.Quad{
		InitCommand=cmd(diffuse,color;blend,'BlendMode_Add';zoomto,SCREEN_WIDTH,weight;y,size);
		OffCommand=function(self)
			self:cropright(1);
			self:smooth(speed);
			self:cropright(0);
			self:diffusealpha(1);
			self:cropleft(0);
			self:smooth(speed);
			self:cropleft(1);
		end;
	};
	Def.Quad{
		InitCommand=cmd(diffuse,color;blend,'BlendMode_Add';zoomto,weight,SCREEN_HEIGHT;x,-size);
		OffCommand=function(self)
			self:cropbottom(1);
			self:smooth(speed);
			self:cropbottom(0);
			self:diffusealpha(1);
			self:croptop(0);
			self:smooth(speed);
			self:croptop(1);
		end;
	};
	Def.Quad{
		InitCommand=cmd(diffuse,color;blend,'BlendMode_Add';zoomto,weight,SCREEN_HEIGHT;x,size);
		OffCommand=function(self)
			self:croptop(1);
			self:smooth(speed);
			self:croptop(0);
			self:diffusealpha(1);
			self:cropbottom(0);
			self:smooth(speed);
			self:cropbottom(1);
		end;
	};
};

return t;