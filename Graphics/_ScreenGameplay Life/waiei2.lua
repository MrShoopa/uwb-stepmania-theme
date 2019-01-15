local life_type,mem,maxlife,lifeWidth,haishin,pn=...;
local lifeWidth_2=lifeWidth/2;

local t=Def.ActorFrame{
	InitCommand=cmd(rotationy,(pn==PLAYER_1) and 0 or 180;);
	OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
	LoadActor("lifeframe_underlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(1);
			self:zoomtowidth(lifeWidth-2);
		end;
	};
	LoadActor("lifeframe_underlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(0);
			self:horizalign(right);
			self:x(-(lifeWidth-2)/2);
		end;
	};
	LoadActor("lifeframe_underlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(2);
			self:horizalign(left);
			self:x((lifeWidth-2)/2);
		end;
	};
	LoadActor("lifeframe_left")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:x(-(lifeWidth-2)/2);
			self:diffuse(0,0,0,0.25);
		end;
	};
	LoadActor("lifeframe_left")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:rotationz(180);
			self:x((lifeWidth-2)/2);
			self:diffuse(0,0,0,0.25);
		end;
	};
	LoadActor("lifeframe_left")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:x(-(lifeWidth-2)/2);
			if haishin=='Off' then
				self:diffuseshift();
				self:effectcolor1(1,1,1,0);
				self:effectcolor2(1,1,1,0);
				self:effectclock("bgm");
			else
				self:diffuse(col_lb);
			end;
			self:blend("BlendMode_Add");
		end;
		BarTimerMessageCommand=function(self,params)
			if params.Player==pn then
				local col = params.ColorLight;
				if haishin=='Off' then
					self:effectcolor1(col);
					self:effectcolor2(col[1],col[2],col[3],0.25);
				else
					self:diffuse(col);
				end;
			end;
		end;
	};
	LoadActor("lifeframe_left")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:rotationz(180);
			self:x((lifeWidth-2)/2);
			if haishin=='Off' then
				self:diffuseshift();
				self:effectcolor1(1,1,1,0);
				self:effectcolor2(1,1,1,0);
				self:effectclock("bgm");
			else
				self:diffuse(col_lb);
			end;
			self:blend("BlendMode_Add");
		end;
		BarTimerMessageCommand=function(self,params)
			if params.Player==pn then
				local col = params.ColorLight;
				if haishin=='Off' then
					self:effectcolor1(col);
					self:effectcolor2(col[1],col[2],col[3],0.25);
				else
					self:diffuse(col);
				end;
			end;
		end;
	};
	LoadActor("lifeframe_border_l")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:x(-(lifeWidth-2)/2);
		end;
	};
	LoadActor("lifeframe_border_l")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:rotationz(180);
			self:x((lifeWidth-2)/2);
		end;
	};
	LoadActor("life in")..{
		InitCommand=function(self)
			self:zoomto(lifeWidth-4,32);
			self:blend("BlendMode_Add");
		end;
		BarTimerMessageCommand=function(self,params)
			if params.Player==pn then
				if params.Life>0.0 then
					local p=params.Life;
					if life_type=='battery8' then
						p=p*maxlife/8;
					elseif life_type=='battery4' then
						p=p*maxlife/4;
					end;
					self:cropright(1-p);
				else
					self:cropright(1);
				end;
				local beat2 = (haishin=='On') and 0 or 0.05*(params.Beat*10%10);
				self:croptop(0.5-beat2);
				self:cropbottom(beat2);
				self:y(beat2*32-8);
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(lifeWidth-4,16);
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
					if life_type=='battery8' then
						p=p*maxlife/8;
					elseif life_type=='battery4' then
						p=p*maxlife/4;
					end;
					self:cropright(1-p);
				else
					self:cropright(1);
				end;
				self:diffusealpha(0.5);
				self:blend("BlendMode_Add");
			end;
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(lifeWidth-4,2);
			self:diffuse(1,1,1,0.2);
			self:blend("BlendMode_Add");
		end;
		BarTimerMessageCommand=function(self,params)
			if params.Player==pn then
				if params.Life>0.0 then
					local p=params.Life;
					if life_type=='battery8' then
						p=p*maxlife/8;
					elseif life_type=='battery4' then
						p=p*maxlife/4;
					end;
					self:cropright(1-p);
				else
					self:cropright(1);
				end;
				local beat_=(params.Beat+0.1);
				self:y(8-16.0*(beat_%1.0));
				self:diffusealpha(0.4-(beat_%1.0)*0.4);
			end;
		end;
	};
	LoadActor("lifeframe_overlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(1);
			self:zoomtowidth(lifeWidth-4);
		end;
	};
	LoadActor("lifeframe_overlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(0);
			self:horizalign(right);
			self:x(-(lifeWidth-4)/2);
		end;
	};
	LoadActor("lifeframe_overlay")..{
		InitCommand=function(self)
			self:animate(false);
			self:setstate(2);
			self:horizalign(left);
			self:x((lifeWidth-4)/2);
		end;
	};
	LoadActor("light center")..{
		InitCommand=cmd(zoomtowidth,lifeWidth*2;blend,"BlendMode_Add");
		OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
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
};
if life_type~='bar' then
	for l=1,mem-1 do
		t[#t+1]=LoadActor("life border")..{
			InitCommand=cmd(x,(lifeWidth/mem)*l-lifeWidth/2);
			OnCommand=cmd(diffusealpha,0;sleep,1.0;linear,0.25;diffusealpha,1);
		};
	end;
end;

return t;