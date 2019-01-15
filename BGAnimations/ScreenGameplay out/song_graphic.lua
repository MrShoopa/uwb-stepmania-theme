local t=Def.ActorFrame{};
local song=_SONG();
if not song then
	return t;
end;
local ret=GetBannerStat(song,'JBG');
g=ret[1];

t[#t+1]=Def.Quad{
	InitCommand=cmd(zoomto,SCREEN_WIDTH,0;Center;
		blend,"BlendMode_Add";);
	OffCommand=function(self)
		self:zoomy(0);
		if GAMESTATE:GetEarnedExtraStage()=='EarnedExtraStage_Extra1' then
			self:diffuse(0.7,0.1,0.1,1);
			self:diffusealpha(1);
			self:linear(0.3);
			self:zoomy(SCREEN_HEIGHT+1);
			self:linear(2);
			self:diffusealpha(0);
		elseif GAMESTATE:GetEarnedExtraStage()=='EarnedExtraStage_Extra2' then
			self:diffuse(0.75,0.85,1,1);
			self:diffusealpha(1);
			self:linear(0.3);
			self:zoomy(SCREEN_HEIGHT+1);
			self:linear(2);
			self:diffusealpha(0);
		end;
	end;
};

-- [ja]曲終了時のジャケット表示
t[#t+1]=Def.ActorFrame{
	Def.Sprite{
		InitCommand=function(self)
			self:diffusealpha(0);
		end;
		OnCommand=function(self)
			self:LoadBackground(g);
			self:rate(0.5);
			self:sleep(math.max(TC_GetMetric('Wait','GameplayOut')-2.5,0));
			if TC_GetwaieiMode()==2 then
				self:rotationy(180);
				self:scaletofit(0,0,484,484);
				self:Center();
				self:diffuse(0,0,0,0);
				self:decelerate(0.2);
				self:rotationy(0);
				self:scaletofit(0,0,364,364);
				self:Center();
				self:diffuse(0,0,0,0.5);
				self:sleep(1.0);
				self:linear(0.3);
				self:scaletofit(0,0,0,0);
				self:rotationz(90);
				self:Center();
				self:diffuse(0,0,0,0);
			else
				self:scaletofit(0,0,484,484);
				self:Center();
				self:diffuse(0,0,0,0);
				self:decelerate(0.2);
				self:scaletofit(0,0,364,364);
				self:Center();
				self:diffuse(0,0,0,0.5);
			end;
		end;
	};
	Def.Sprite{
		InitCommand=function(self)
			self:diffusealpha(0);
		end;
		OnCommand=function(self)
			self:LoadBackground(g);
			self:rate(0.5);
			self:sleep(math.max(TC_GetMetric('Wait','GameplayOut')-2.5,0));
			if TC_GetwaieiMode()==2 then
				self:rotationy(180);
				self:scaletofit(0,0,480,480);
				self:Center();
				self:diffusealpha(0);
				self:decelerate(0.2);
				self:rotationy(0);
				self:scaletofit(0,0,360,360);
				self:Center();
				self:diffusealpha(1);
				self:sleep(1.0);
				self:linear(0.3);
				self:scaletofit(0,0,0,0);
				self:rotationz(90);
				self:Center();
				self:diffuse(0,0,0,0);
			else
				self:scaletofit(0,0,480,480);
				self:Center();
				self:diffusealpha(0);
				self:decelerate(0.2);
				self:scaletofit(0,0,360,360);
				self:Center();
				self:diffusealpha(1);
			end;
		end;
	};
}

return t;