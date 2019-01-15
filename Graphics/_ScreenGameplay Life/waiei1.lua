local life_type,mem,maxlife,lifeWidth,haishin,pn=...;
local lifeWidth_2=lifeWidth/2;

local t=Def.ActorFrame{
	InitCommand=cmd(rotationy,(pn==PLAYER_1) and 0 or 180);
	OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
	OffCommand=cmd(stoptweening;diffusealpha,1;sleep,0.5;linear,0.25;addx,(pn==PLAYER_1) and -100 or 100;diffusealpha,0);
	LoadActor(TC_GetPath("Life","life left"))..{
		OnCommand=cmd(x,-lifeWidth_2-12;);
	};
	LoadActor(TC_GetPath("Life","life right"))..{
		OnCommand=cmd(x,lifeWidth_2+12;);
	};
	LoadActor(TC_GetPath("Life","life center"))..{
		OnCommand=cmd(zoomtowidth,lifeWidth;);
	};
	LoadActor(TC_GetPath("Life","light left"))..{
		OnCommand=function(self)
			(cmd(x,-lifeWidth_2-12;blend,"BlendMode_Add";))(self);
			if haishin=="Off" then
				(cmd(diffuseramp;effectcolor1,0,0.68,0.93,0.8;effectcolor2,0,0.68,0.93,0.3;effectclock,'beat';))(self);
			else
				self:diffuse(0,0.68,0.93,0.8);
			end;
		end;
		BarTimerMessageCommand=function(self,params)
			if params.Player==pn then
				local col = params.ColorLight;
				if haishin=='Off' then
					self:effectcolor1(col[1],col[2],col[3],0.8);
					self:effectcolor2(col[1],col[2],col[3],0.3);
				else
					self:diffuse(col[1],col[2],col[3],0.8);
				end;
			end;
		end;
	};
	LoadActor(TC_GetPath("Life","light right"))..{
		OnCommand=function(self)
			(cmd(x,lifeWidth_2+12;blend,"BlendMode_Add";))(self);
			if haishin=="Off" then
				(cmd(diffuseramp;effectcolor1,0,0.68,0.93,0.8;effectcolor2,0,0.68,0.93,0.3;effectclock,'beat';))(self);
			else
				self:diffuse(0,0.68,0.93,0.8);
			end;
		end;
		BarTimerMessageCommand=function(self,params)
			if params.Player==pn then
				local col = params.ColorLight;
				if haishin=='Off' then
					self:effectcolor1(col[1],col[2],col[3],0.8);
					self:effectcolor2(col[1],col[2],col[3],0.3);
				else
					self:diffuse(col[1],col[2],col[3],0.8);
				end;
			end;
		end;
	};
	LoadActor(TC_GetPath("Life","light center"))..{
		InitCommand=cmd(zoomtowidth,lifeWidth*2;blend,"BlendMode_Add");
		BarTimerMessageCommand=function(self,params)
			if params.Player==pn then
				local beat2 = (haishin=='On') and 0 or 0.1*(params.Beat*10%20);
				self:cropleft(0.5-(beat2/4));
				self:cropright(beat2/4);
				self:x((beat2/4)*(lifeWidth*2)-lifeWidth_2);
				self:diffuse(params.ColorBar);
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(lifeWidth-2,18);
			self:diffuse(0,0.68,0.93,1);
			self:blend("BlendMode_Add");
		end;
		BarTimerMessageCommand=function(self,params)
			if params.Player==pn then
				local col = params.ColorBar;
				if params.Mode=='HealthState_Hot' then
					local beat1 = 0.03*(params.Beat*10%10);
					self:diffuse(HSV((params.ColorHue+350)%360,1.0,1.0-(beat1/2)));
				else
					self:diffuse(col);
				end;
				if params.Life>0.0 then
					local p=params.Life;
					self:cropright(1-p);
				else
					self:cropright(1);
				end;
				self:diffusetopedge(0,0.15,0.3,0.5);
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(lifeWidth-2,8);
			self:y(-3);
			self:diffuse(0.8,0.8,0.8,0.5);
			self:diffusebottomedge(0.2,0.2,0.2,0);
			self:blend("BlendMode_Add");
		end;
		OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1;);
		BarTimerMessageCommand=function(self,params)
			if params.Player==pn then
				if params.Life>0.0 then
					local p=params.Life;
					self:cropright(1-p);
				else
					self:cropright(1);
				end;
			end;
		end;
	};
	Def.Quad{
		InitCommand=cmd(zoomto,lifeWidth-2,18;horizalign,left;x,-lifeWidth/2+1;
			diffuse,0,0,0,0;diffuseleftedge,0.0,0.0,0.0,0.3;);
		OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffuseleftedge,0.0,0.0,0.0,0.3;);
		BarTimerMessageCommand=function(self,params)
			if params.Player==pn then
				if params.Life>=1.0 then
					self:zoomtowidth((lifeWidth-2));
					self:diffuseleftedge(0,0,0,0.2);
				elseif params.Life>0.0 then
					local p=params.Life;
					self:zoomtowidth((lifeWidth-2)*p);
					self:diffuseleftedge(0,0,0,0.3);
				else
					self:zoomtowidth(0);
				end;
			end;
		end;
	};
};
if maxlife>1 then
	for l=1,maxlife-1 do
		t[#t+1]=LoadActor(TC_GetPath("Life","life border"))..{
			InitCommand=cmd(x,(lifeWidth/maxlife)*l-lifeWidth/2);
		};
	end;
end;

return t;