local lifeWidth,haishin=...;
local sec_sample=0;
local beat_sample={0,0};
local beat_player={0,0};
local player={GetSidePlayer(PLAYER_1),GetSidePlayer(PLAYER_2)}
local lighteff=GetUserPref_Theme("UserLightEffect") or 'Auto';
local song;
local t=Def.ActorFrame{
	InitCommand=cmd(playcommand,"Set");
	CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
	SetCommand=function(self)
		song=_SONG2();
		if song then
			sec_sample=song:GetSampleStart();
			beat_sample={math.round(_BEAT2(player[1],sec_sample)*10)*0.1,
				math.round(_BEAT2(player[2],sec_sample)*10)*0.1};
		end;
	end;
	LoadActor(TC_GetPath("ScreenGameplay","Frame-SideLight"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X-lifeWidth-lifeWidth/4-SCREEN_WIDTH/16+40;
			y,SCREEN_TOP-10;blend,"BlendMode_Add";);
		OnCommand=cmd(diffusealpha,0;addy,-100;sleep,0.5;linear,0.25;addy,100;);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,-100;diffusealpha,0);
		LightLeftCommand=function(self)
			self:diffusealpha(1-beat_player[1]);
		end;
	};
	LoadActor(TC_GetPath("ScreenGameplay","Frame-SideLight"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X+lifeWidth+lifeWidth/4+SCREEN_WIDTH/16-40;
			y,SCREEN_TOP-10;rotationy,180;blend,"BlendMode_Add";);
		OnCommand=cmd(diffusealpha,0;addy,-100;sleep,0.5;linear,0.25;addy,100;);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,-100;diffusealpha,0);
		LightRightCommand=function(self)
			self:diffusealpha(1-beat_player[2]);
		end;
	};
	LoadActor(TC_GetPath("ScreenGameplay","Frame-SideLight"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X-lifeWidth-lifeWidth/4-SCREEN_WIDTH/16+40;
			y,SCREEN_BOTTOM+10;rotationx,180;blend,"BlendMode_Add";);
		OnCommand=cmd(diffusealpha,0;addy,100;sleep,0.5;linear,0.25;addy,-100;);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,100;diffusealpha,0);
		LightLeftCommand=function(self)
			self:diffusealpha(1-beat_player[1]);
		end;
	};
	LoadActor(TC_GetPath("ScreenGameplay","Frame-SideLight"))..{
		InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_CENTER_X+lifeWidth+lifeWidth/4+SCREEN_WIDTH/16-40;
			y,SCREEN_BOTTOM+10;rotationx,180;rotationy,180;blend,"BlendMode_Add";);
		OnCommand=cmd(diffusealpha,0;addy,100;sleep,0.5;linear,0.25;addy,-100;);
		OffCommand=cmd(diffusealpha,1;sleep,0.25;linear,0.25;addy,100;diffusealpha,0);
		LightRightCommand=function(self)
			self:diffusealpha(1-beat_player[2]);
		end;
	};
};
local time=0;
local wait=1.0/30;
local sec_now=0;
local beat_now={0,0};
local function update(self,dt)
	time=time+dt;
	sec_now=_MUSICSECOND()+0.08;
	beat_now={_BEAT2(player[1],sec_now),_BEAT2(player[2],sec_now)};
	if time>=wait then
		time=time-wait;
		if (beat_now[1]>=beat_sample[1] and 
			(lighteff=='Auto')) or (lighteff=='Always') then
			beat_player[1]=(haishin=="On") and 0.00001 or 0.1*(_BEAT2(player[1],sec_now)*10%10);
			self:queuecommand("LightLeft");
		end;
		if (beat_now[2]>=beat_sample[2] and 
			(lighteff=='Auto')) or (lighteff=='Always') then
			beat_player[2]=(haishin=="On") and 0.00001 or 0.1*(_BEAT2(player[2],sec_now)*10%10);
			self:queuecommand("LightRight");
		end;
	end;
end;
t.InitCommand=cmd(SetUpdateFunction,update;);
return t;