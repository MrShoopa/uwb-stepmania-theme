local t=Def.ActorFrame{
	StartMessageCommand=cmd(playcommand,'Off');
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;Center;diffuse,0,0,0,0);
		OffCommand=cmd(sleep,0.2;linear,0.3;diffusealpha,1);
	};
	Def.Sprite{
		InitCommand=cmd(Center;diffusealpha,0);
		OffCommand=function(self)
			local song=_SONG();
			if song then
				local loaded;
				if song:HasBackground() then
					self:LoadBackground(song:GetBackgroundPath());
					loaded=1;
				elseif song:HasJacket() then
					self:LoadBackground(song:GetJacketPath());
					loaded=2;
				elseif song:HasBanner() then
					self:LoadBackground(song:GetBannerPath());
					loaded=3;
				else
					loaded=0;
				end;
				self:zoomtowidth(SCREEN_WIDTH);
				self:zoomtoheight(self:GetHeight()*SCREEN_WIDTH/self:GetWidth());
				self:sleep(0.2);
				self:blend("BlendMode_Add");
				(cmd(x,SCREEN_LEFT;y,SCREEN_TOP+200;cropleft,0.5;cropright,0;croptop,0.5;cropbottom,0;diffusealpha,0.8;linear,0.1;
						diffusealpha,0;x,SCREEN_LEFT;y,SCREEN_TOP+200;cropleft,0.5;croptop,0.5;sleep,0.05;
					x,SCREEN_RIGHT;y,SCREEN_CENTER_Y-50;cropleft,0;cropright,0.5;croptop,0;cropbottom,0.5;diffusealpha,0.8;linear,0.1;
						diffusealpha,0;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y-50;cropright,0.5;croptop,0;cropbottom,0.5;sleep,0.05;
					x,SCREEN_CENTER_X-30;y,SCREEN_BOTTOM-50;cropleft,0.25;cropright,0.25;croptop,0.25;cropbottom,0.25;diffusealpha,0.8;linear,0.1;
						diffusealpha,0))(self);
			end;
		end;
	};
	Def.Sprite{
		InitCommand=cmd(Center;diffusealpha,0);
		OffCommand=function(self)
			local song=_SONG();
			if song then
				if song:HasBackground() then
					self:LoadBackground(song:GetBackgroundPath());
				else
					self:Load(THEME:GetPathG("Common","fallback background"));
				end;
				self:zoomtowidth(SCREEN_WIDTH*2);
				self:zoomtoheight(self:GetHeight()*SCREEN_WIDTH/self:GetWidth()*2);
				self:sleep(0.55);
				(cmd(Center;diffusealpha,0.1;decelerate,0.3;
				diffusealpha,PREFSMAN:GetPreference("BGBrightness")/2;))(self);
				local ratio=GetSMParameter(song,"bgaspectratio");
				if ratio=="" then ratio="1.333333" end;
				if (bgs == 'Cover' and haishin=="Off") or
					(math.abs(PREFSMAN:GetPreference("DisplayAspectRatio")-tonumber(ratio))<= 0.01 and haishin=="Off") then
					self:scaletocover( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
				else
					self:scaletofit( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT );
				end;
				self:linear(0.1);
				self:diffusealpha(PREFSMAN:GetPreference("BGBrightness"));
			end;
		end;
	};
};
return t;