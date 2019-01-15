local lifeWidth,haishin=...;
local t=Def.ActorFrame{
	OnCommand=function(self)
	end;
	LoadActor(TC_GetPath("ScreenGameplay","Frame1-Bottom"))..{
		InitCommand=cmd(vertalign,bottom;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;);
		OnCommand=cmd(diffusealpha,0;sleep,0.25;zoomx,2;zoomy,0;linear,0.25;zoomx,1;zoomy,1;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
	};
};
for p=1,2 do
local pn=((p==1) and PLAYER_1 or PLAYER_2);
t[#t+1]=Def.ActorFrame{
	LoadActor(TC_GetPath("ScreenGameplay","Frame1-Top"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X;y,10;rotationy,(p==1) and 0 or 180);
		OnCommand=cmd(diffusealpha,0;sleep,0.25;addy,-100;linear,0.25;addy,100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.5;linear,0.25;diffusealpha,0);
	};
	LoadActor(TC_GetPath("ScreenGameplay","Frame2-Top"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;
			x,SCREEN_CENTER_X+((p==1) and -lifeWidth-lifeWidth/4-SCREEN_WIDTH/16 or lifeWidth+lifeWidth/4+SCREEN_WIDTH/16);y,10;
			rotationy,(p==1) and 0 or 180;);
		OnCommand=cmd(diffusealpha,0;addy,-100;sleep,0.5;linear,0.25;addy,100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,-100;diffusealpha,0);
	};
};
if (Var "LoadingScreen")~="ScreenHowToPlay" then
t[#t+1]=Def.ActorFrame{
	LoadActor("waiei1_difficulty",pn,lifeWidth,GetUserPref_Theme("UserDifficultyColor"),
		GetUserPref_Theme("UserDifficultyName"),GetUserPref_Theme("UserMeterType"));
};
end;
t[#t+1]=Def.ActorFrame{
	LoadActor(TC_GetPath("ScreenGameplay","Frame2-Bottom"))..{
		InitCommand=cmd(horizalign,right;vertalign,bottom;
			x,SCREEN_CENTER_X+((p==1) and -lifeWidth-lifeWidth/4-SCREEN_WIDTH/16 or lifeWidth+lifeWidth/4+SCREEN_WIDTH/16);y,SCREEN_BOTTOM-10;
			rotationy,(p==1) and 0 or 180;);
		OnCommand=cmd(diffusealpha,0;addy,100;sleep,0.5;linear,0.25;addy,-100;diffusealpha,1);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,100;diffusealpha,0);
	};
	LoadActor(TC_GetPath("ScreenGameplay","Frame-Light"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;
			x,SCREEN_CENTER_X;y,10;
			blend,"BlendMode_Add";rotationy,(p==1) and 0 or 180);
		OnCommand=cmd(diffusealpha,0;sleep,1.25;diffusealpha,1;linear,2;diffusealpha,0.5);
		OffCommand=cmd(diffusealpha,0.5;sleep,0.25;linear,0.25;diffusealpha,0);
	};
};
end;
t[#t+1]=Def.ActorFrame{
	LoadActor("waiei1_sidelight",lifeWidth,haishin)..{
		InitCommand=function(self)
			self:visible((Var "LoadingScreen")~="ScreenHowToPlay");
		end;
	};
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH,10;diffuse,0,0,0,1;x,SCREEN_CENTER_X;y,5);
	};
};

return t;