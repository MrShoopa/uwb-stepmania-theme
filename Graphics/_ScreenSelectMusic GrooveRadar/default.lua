local pn=...;
local t=Def.ActorFrame{};

local RadarPrm={"Stream","Chaos","Freeze","Air","Voltage"};
local keymode=false;

local showvalue=GetUserPref_Theme("UserShowRadarValue") or 'All';
local overlimit=GetUserPref_Theme("UserRadarOverLimit") or 'On';

local song=nil;
if TC_GetwaieiMode()==2 then
	t[#t+1]=Def.ActorFrame{
		InitCommand=cmd(player,pn);
		LoadActor(TC_GetPath("GrooveRadar","grooveradar"),pn);
	};
else
	t[#t+1]=Def.ActorFrame{
		InitCommand=cmd(player,pn);
		LoadActor(TC_GetPath("GrooveRadar","underlay"))..{
			InitCommand=function(self)
				self:diffuse(PlayerColor(pn));
				self:diffusealpha(0.8);
			end;
		};
		LoadActor(TC_GetPath("GrooveRadar","overlay"))..{
			InitCommand=function(self)
				self:diffusealpha(0.3);
			end;
		};
	};
end;
t[#t+1]=Def.ActorFrame{
	LoadActor(TC_GetPath("GrooveRadar","autogen"))..{
		InitCommand=function(self)
			self:player(pn);
			self:diffuse(PlayerColor(pn));
			self:playcommand("Changed");
		end;
		ChangedCommand=function(self)
			song=_SONG();
			if step then
				if step:IsAutogen() then
					self:stoptweening();
					self:x((pn==PLAYER_1) and -42 or 42);
					self:y(-55);
					self:zoomy(1);
					--self:blend("BlendMode_Add")
					self:glowblink();
					self:effectperiod(0.80);
					self:visible(1);
				else
					self:visible(0);
				end;
			else
				self:visible(0);
			end;
		end;
	};
	Def.GrooveRadar {
		InitCommand=cmd(diffuse,BoostColor(PlayerColor(pn),1.8);zoom,1.3;
			visible,(showvalue~='Key'));
		ChangedCommand=function(self)
			local rv=GAMESTATE:GetCurrentSteps(pn):GetRadarValues(pn);
			local v={};
			if not song or not GetEXFCurrentSong_ShowStepInfo() then
				self:SetEmpty(pn);
			else
				v[#v+1]=yaGetRadarVal(song,pn,'Stream',false,overlimit)*0.01;
				v[#v+1]=yaGetRadarVal(song,pn,'Voltage',false,overlimit)*0.01;
				v[#v+1]=yaGetRadarVal(song,pn,'Air',false,overlimit)*0.01;
				v[#v+1]=yaGetRadarVal(song,pn,'Freeze',false,overlimit)*0.01;
				v[#v+1]=yaGetRadarVal(song,pn,'Chaos',false,overlimit)*0.01;
				self:SetFromValues(pn,v);
			end;
		end;
	};
	Def.GrooveRadar {
		InitCommand=cmd(diffuse,1.0,1.0,1.0,0.5;zoom,1.3;
			visible,(showvalue~='Pad'));
		ChangedCommand=function(self)
			local rv=GAMESTATE:GetCurrentSteps(pn):GetRadarValues(pn);
			local v={};
			local song=_SONG();
			if not song or not GetEXFCurrentSong_ShowStepInfo() then
				self:SetEmpty(pn);
			else
				v[#v+1]=yaGetRadarVal(song,pn,'Stream',true,overlimit)*0.01;
				v[#v+1]=yaGetRadarVal(song,pn,'Voltage',true,overlimit)*0.01;
				v[#v+1]=yaGetRadarVal(song,pn,'Air',true,overlimit)*0.01;
				v[#v+1]=yaGetRadarVal(song,pn,'Freeze',true,overlimit)*0.01;
				v[#v+1]=yaGetRadarVal(song,pn,'Chaos',true,overlimit)*0.01;
				self:SetFromValues(pn,v);
			end;
		end;
	};
};

local radar_name={"STR","CHA","FRZ","AIR","VOL"};
for i=1,5 do
t[#t+1]=Def.ActorFrame{
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:player(pn);
			self:x(55.0*math.sin(2*math.pi*(i-1)/5));
			self:y(55.0*math.cos(2*math.pi*(i-1)/5)*(-1));
			self:rotationz(360*(i-1)/5);
			self:diffuse(Color("White"));
			self:strokecolor(0,0,0,0.5);
			self:diffusealpha(0);
			self:settextf("%s",radar_name[i]);
			self:zoom(0);
			self:sleep(0.3);
		end;
		OnCommand=function(self)
			self:decelerate(0.2);
			self:diffusealpha(1.0);
			self:zoom(0.5);
		end;
	};
};
--local show_val=GetUserPref_Theme("UserShowRadarValue");
local show_val=true;
if show_val then
	t[#t+1]=Def.ActorFrame{
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:player(pn);
				self:x(55.0*math.sin(2*math.pi*(i-1)/5));
				self:y(55.0*math.cos(2*math.pi*(i-1)/5)*(-1));
				self:rotationz(360*(i-1)/5);
				self:diffuse(Color("White"));
				self:strokecolor(0,0,0,0.2);
				self:diffusealpha(0);
				self:settext("");
				self:zoom(0);
				self:sleep(0.3);
			end;
			OnCommand=function(self)
				self:decelerate(0.2);
				self:diffusealpha(0.75);
				self:zoom(0.5);
			end;
			ChangedCommand=function(self)
				if not song or not GetEXFCurrentSong_ShowStepInfo() then
					self:settext("");
				else
					if showvalue=='All' then
						local v1=yaGetRadarVal(_SONG2(),pn,RadarPrm[i],false,overlimit);
						local v2=yaGetRadarVal(_SONG2(),pn,RadarPrm[i],true,overlimit);
						self:settextf("%s\n\n%s",math.floor(v1*2),math.floor(v2*2));
					elseif showvalue=='Pad' then
						local v1=yaGetRadarVal(_SONG2(),pn,RadarPrm[i],false,overlimit);
						self:settextf("%s\n\n",math.floor(v1*2));
					elseif showvalue=='Key' then
						local v2=yaGetRadarVal(_SONG2(),pn,RadarPrm[i],true,overlimit);
						self:settextf("%s\n\n",math.floor(v2*2));
					end;
				end;
			end;
		};
	};
	end;
end;

local old_step=nil;
local function update(self)
	if _SONG() then
		local st=_STEPS2(pn);
		if old_step~=st then
			old_step=st;
			self:playcommand("Changed");
		end;
	else
		if old_step~=nil then
			old_step=nil;
			self:playcommand("Changed");
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update);

return t;