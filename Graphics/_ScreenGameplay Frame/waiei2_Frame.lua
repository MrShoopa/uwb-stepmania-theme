local lifeWidth,haishin=...;
local t=Def.ActorFrame{};
local top_width=math.max(SCREEN_WIDTH-300,400);
local bottom_width=SCREEN_WIDTH-440;
t[#t+1]=Def.ActorFrame{
	OnCommand=cmd(diffusealpha,0;sleep,0.2;linear,0.3;diffusealpha,1);
	LoadActor("frame_top")..{
		InitCommand=cmd(vertalign,top;horizalign,right;y,0;
			animate,false;setstate,0;x,SCREEN_CENTER_X-top_width/2;);
	};
	LoadActor("frame_top")..{
		InitCommand=cmd(vertalign,top;horizalign,center;zoomtowidth,top_width;y,0;
			animate,false;setstate,1;x,SCREEN_CENTER_X;);
	};
	LoadActor("frame_top")..{
		InitCommand=cmd(vertalign,top;horizalign,left;y,0;
			animate,false;setstate,2;x,SCREEN_CENTER_X+top_width/2;);
	};
};
t[#t+1]=Def.ActorFrame{
	OnCommand=cmd(diffusealpha,0;sleep,0.2;linear,0.3;diffusealpha,1);
	LoadActor("frame_bottom")..{
		InitCommand=cmd(vertalign,bottom;horizalign,right;y,SCREEN_BOTTOM;
			animate,false;setstate,0;x,SCREEN_CENTER_X-bottom_width/2;);
	};
	LoadActor("frame_bottom")..{
		InitCommand=cmd(vertalign,bottom;horizalign,center;y,SCREEN_BOTTOM;zoomtowidth,bottom_width;
			animate,false;setstate,1;x,SCREEN_CENTER_X;);
	};
	LoadActor("frame_bottom")..{
		InitCommand=cmd(vertalign,bottom;horizalign,left;y,SCREEN_BOTTOM;
			animate,false;setstate,2;x,SCREEN_CENTER_X+bottom_width/2;);
	};
};
t[#t+1]=Def.ActorFrame{
	LoadActor("waiei2_sidelight",lifeWidth,haishin)..{
		InitCommand=function(self)
			self:visible((Var "LoadingScreen")~="ScreenHowToPlay");
		end;
	};
};
if (Var "LoadingScreen")~="ScreenHowToPlay" then
	for p=1,2 do
	local pn=((p==1) and PLAYER_1 or PLAYER_2);
	t[#t+1]=Def.ActorFrame{
		LoadActor("waiei2_difficulty",pn,lifeWidth,GetUserPref_Theme("UserDifficultyColor"),
			GetUserPref_Theme("UserDifficultyName"),GetUserPref_Theme("UserMeterType"));
	};
	end;
end;

return t;