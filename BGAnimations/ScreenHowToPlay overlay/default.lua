local t = Def.ActorFrame {};
t[#t+1]=LoadActor(THEME:GetPathB("_Gameplay","Message"));

local lifeWidth=SCREEN_WIDTH/4;

if not GAMESTATE:IsDemonstration() then
	t[#t+1] = Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(diffuse,0,0,0,0;x,THEME:GetMetric("ScreenGameplay","SongTitleX");
								y,THEME:GetMetric("ScreenGameplay","SongTitleY"););
			OnCommand=cmd(horizalign,right;zoomto,480,0;diffusealpha,0;diffuseleftedge,0,0,0,0;
							sleep,0.5;linear,0.25;zoomto,280,16;diffusealpha,1;diffuseleftedge,0,0,0,0;);
			OffCommand=cmd(linear,0.25;zoomto,960,0;diffusealpha,0;);
		};
		Def.Quad{
			InitCommand=cmd(diffuse,0,0,0,0;x,THEME:GetMetric("ScreenGameplay","SongTitleX");
								y,THEME:GetMetric("ScreenGameplay","SongTitleY"););
			OnCommand=cmd(horizalign,left;zoomto,480,0;diffusealpha,0;diffuserightedge,0,0,0,0;
							sleep,0.5;linear,0.25;zoomto,280,16;diffusealpha,1;diffuserightedge,0,0,0,0;);
			OffCommand=cmd(linear,0.25;zoomto,960,0;diffusealpha,0;);
		};
		LoadFont("Common Normal")..{
			Text="How To Play";
			InitCommand=cmd(x,THEME:GetMetric("ScreenGameplay","SongTitleX");
								y,THEME:GetMetric("ScreenGameplay","SongTitleY"););
			OnCommand=function(self)
				self:zoomx(2);
				self:zoomy(0);
				self:sleep(0.5);
				self:linear(0.2);
				self:zoomx(0.5);
				self:zoomy(0.5);
			end;
			OffCommand=THEME:GetMetric("ScreenGameplay","SongTitleOffCommand");
		};
	};
--	t[#t+1] = StandardDecorationFromFileOptional("SongTitle","SongTitle");
end;

t[#t+1] = Def.ActorFrame{
	LoadActor("life");
	Def.Quad{
		InitCommand=cmd(diffuse,0,0,0,1;zoomto,SCREEN_WIDTH,20;vertalign,bottom;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM);
		OnCommand=cmd(diffusealpha,0;addy,20;linear,0.25;addy,-20;diffusealpha,1;diffusetopedge,0,0,0,0.5);
	};
	Def.Quad{
	--	InitCommand=cmd(diffuse,0.02,0.16,0.54,0;zoomto,SCREEN_WIDTH,10;vertalign,top;x,SCREEN_CENTER_X;y,SCREEN_TOP);
		InitCommand=cmd(diffuse,0,0,0,0;zoomto,SCREEN_WIDTH,10;vertalign,top;x,SCREEN_CENTER_X;y,SCREEN_TOP);
		OnCommand=cmd(diffusealpha,0;addy,-20;linear,0.25;addy,20;diffusealpha,1);
	};
};
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(y,SCREEN_CENTER_Y);
	LoadActor(THEME:GetPathG("_HowToPlay/htp","top"))..{
		OnCommand=cmd(x,SCREEN_CENTER_X;diffusealpha,0;zoom,1.5;
			linear,0.3;diffusealpha,1;zoom,1;sleep,2.5;
			linear,0.3;zoom,0.6;x,SCREEN_CENTER_X-120;y,100)
	};
	Def.Sprite{
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X-100);
			self:y(-60);
			self:queuecommand("Text1");
		end;
		Text1Command=function(self)
			self:Load(THEME:GetPathG("_HowToPlay/htp","text1"));
			self:diffusealpha(0);
			self:zoom(1.5);

			self:sleep(3.2*2-0.2);
			self:linear(0.2);
			self:diffusealpha(1);
			self:zoom(1);
			self:sleep(3.2*1.75-0.2);
			self:linear(0.2);
			self:diffusealpha(0);
			self:zoom(0.5);
			self:queuecommand("Text2");
		end;
		Text2Command=function(self)
			self:Load(THEME:GetPathG("_HowToPlay/htp","text2"));
			self:diffusealpha(0);
			self:zoom(1.5);

			self:sleep(3.2*0.25-0.2);
			self:linear(0.2);
			self:diffusealpha(1);
			self:zoom(1);
			self:sleep(3.2*1.75-0.2);
			self:linear(0.2);
			self:diffusealpha(0);
			self:zoom(0.5);
			self:queuecommand("Text3");
		end;
		Text3Command=function(self)
			self:Load(THEME:GetPathG("_HowToPlay/htp","text3"));
			self:diffusealpha(0);
			self:zoom(1.5);

			self:sleep(3.2*0.25-0.2);
			self:linear(0.2);
			self:diffusealpha(1);
			self:zoom(1);
			self:sleep(3.2*2.25-0.2);
			self:linear(0.2);
			self:diffusealpha(0);
			self:zoom(0.5);
			self:queuecommand("Text4");
		end;
		Text4Command=function(self)
			self:Load(THEME:GetPathG("_HowToPlay/htp","text4"));
			self:diffusealpha(0);
			self:zoom(1.5);

			self:sleep(3.2*0.25-0.2);
			self:linear(0.2);
			self:diffusealpha(1);
			self:zoom(1);
			self:sleep(3.2*2.25-0.2);
			self:linear(0.2);
			self:diffusealpha(0);
			self:zoom(0.5);
			self:queuecommand("Text5");
		end;
		Text5Command=function(self)
			self:Load(THEME:GetPathG("_HowToPlay/htp","text5"));
			self:diffusealpha(0);
			self:zoom(1.5);

			self:sleep(3.2*0.25-0.2);
			self:linear(0.2);
			self:diffusealpha(1);
			self:zoom(1);
			self:sleep(3.2*1.50-0.2);
			self:linear(0.2);
			self:diffusealpha(0);
			self:zoom(0.5);
			self:queuecommand("Text6");
		end;
		Text6Command=function(self)
			self:Load(THEME:GetPathG("_HowToPlay/htp","text6"));
			self:diffusealpha(0);
			self:zoom(1.5);

			self:sleep(3.2*0.25-0.2);
			self:linear(0.2);
			self:diffusealpha(1);
			self:zoom(1);
			self:sleep(3.2*1.50-0.2);
			self:linear(0.2);
			self:diffusealpha(0);
			self:zoom(0.5);
			self:queuecommand("Text7");
		end;
		Text7Command=function(self)
			self:Load(THEME:GetPathG("_HowToPlay/htp","text7"));
			self:diffusealpha(0);
			self:zoom(1.5);

			self:sleep(3.2*0.25-0.2);
			self:linear(0.2);
			self:x(SCREEN_CENTER_X-100);
			self:y(-60);
			self:diffusealpha(1);
			self:zoom(1);
			self:linear(0.5);
			self:x(SCREEN_CENTER_X-70);
			self:y(-90);
		end;
	};
};


return t;
