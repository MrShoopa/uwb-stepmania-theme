local Params = { 
	NumParticles = 15,
	VelocityXMin = -45,
	VelocityXMax = 45,
	VelocityYMin = 40,
	VelocityYMax = 70,
	VelocityZMin = 0,
	VelocityZMax = 0,
	BobRateZMin = 0.4,
	BobRateZMax = 0.7,
	ZoomMin = 0.5,
	ZoomMax = 1,
	SpinZ = 360,
	BobZ = 52,
	FMin = 1,
	FMax = 3,
	RZMin = 0,
	RZMax = 360,
	RXMin = 0,
	RXMax = 360,
	AMin = 50,
	AMax = 255,
};

local haishin=GetUserPref_Theme("UserHaishin");
local hideFancyElements = ((GetUserPrefB("UserPrefFancyUIBG") and GetUserPrefB("UserPrefFancyUIBG") or true) == false)
local t = Def.ActorFrame{};
if hideFancyElements then return t; end

local tParticleInfo = {}

local rate=2.5;
for i=1,Params.NumParticles do
	tParticleInfo[i] = {
		X = Params.VelocityXMin ~= Params.VelocityXMax and math.random(Params.VelocityXMin, Params.VelocityXMax) or Params.VelocityXMin,
		Y = Params.VelocityYMin ~= Params.VelocityYMax and math.random(Params.VelocityYMin, Params.VelocityYMax) or Params.VelocityYMin,
		Z = Params.VelocityZMin ~= Params.VelocityZMax and math.random(Params.VelocityZMin, Params.VelocityZMax) or Params.VelocityZMin,
		Zoom = math.random(Params.ZoomMin*1000,Params.ZoomMax*1000) / 1000,
		BobZRate = math.random(Params.BobRateZMin*1000,Params.BobRateZMax*1000) / 1000,
		Age = math.random(rate*10)*0.1,
		F = math.random(Params.FMin,Params.FMax),
		RX = math.random(Params.RXMin,Params.RXMax),
		RZ = math.random(Params.RZMin,Params.RZMax),
		A = math.random(Params.AMin,Params.AMax),
	};
	t[#t+1] = LoadActor( "ptc_"..tParticleInfo[i].F )..{
	Name="Particle"..i;
	InitCommand=function(self)
		self:basezoom(tParticleInfo[i].Zoom);
		self:x(math.random(SCREEN_LEFT+(self:GetWidth()/2),SCREEN_RIGHT-(self:GetWidth()/2)));
		self:y(math.random(SCREEN_TOP+(self:GetHeight()/2),SCREEN_BOTTOM-(self:GetHeight()/2)));
		tParticleInfo[i].Age = math.random(rate*10)*0.1;
	--	self:rotationx(tParticleInfo[i].RX);
		self:rotationz(math.random(360));
	end;
	OnCommand=cmd(diffuse,ColorLightTone(color("#FFb4FF"));diffusealpha,tParticleInfo[i].A/(206));
	};
end

local function UpdateParticles(self,DeltaTime)
	if haishin=="Off" then
		tParticles = self:GetChildren();
		for i=1, Params.NumParticles do
			local p = tParticles["Particle"..i];
			tParticleInfo[i].Age = tParticleInfo[i].Age + DeltaTime;
			p:zoom(math.min(tParticleInfo[i].Age * rate*((tParticleInfo[i].F==3) and 0.5 or 1),4));
			tParticleInfo[i].RZ=tParticleInfo[i].RZ+1;
			p:rotationz(tParticleInfo[i].RZ*0.25*((tParticleInfo[i].F==3) and -0.7 or (tParticleInfo[i].F==2) and 0.5 or 1));
			if tParticleInfo[i].Age * rate >= 4 then
				tParticleInfo[i].Age=tParticleInfo[i].Age-4/rate;
				p:x(math.random(SCREEN_LEFT+(self:GetWidth()/2),SCREEN_RIGHT-(self:GetWidth()/2)));
				p:y(math.random(SCREEN_TOP+(self:GetHeight()/2),SCREEN_BOTTOM-(self:GetHeight()/2)));
				if tParticleInfo[i].Age * rate > 5 then
					p:diffusealpha(0);
				end;
			end;
			if tParticleInfo[i].Age * rate > 3 then
				p:diffusealpha(math.max(4-(tParticleInfo[i].Age * rate),0));
			elseif tParticleInfo[i].Age * rate < 1 then
				p:diffusealpha(tParticleInfo[i].Age * rate);
			else
				p:diffusealpha(1);
			end;
		end;
	end;
end;

t.InitCommand = cmd(fov,90;SetUpdateFunction,UpdateParticles);

return t;
