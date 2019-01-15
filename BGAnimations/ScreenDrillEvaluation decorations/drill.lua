local BASE_TOP_CENTER_X=SCREEN_CENTER_X+_HS2
local BASE_TOP_CENTER_Y=SCREEN_CENTER_Y-108;
local DJACKET_CENTER_X=BASE_TOP_CENTER_X-170;
local DJACKET_CENTER_Y=BASE_TOP_CENTER_Y;
local DTITLE_CENTER_X=BASE_TOP_CENTER_X+90;
local DTITLE_CENTER_Y=BASE_TOP_CENTER_Y;

local BASE_BOTTOM_CENTER_X=SCREEN_CENTER_X+_HS2
local BASE_BOTTOM_CENTER_Y=SCREEN_CENTER_Y+90;
local SJACKET_CENTER_X=BASE_BOTTOM_CENTER_X-170;
local SJACKET_CENTER_Y=BASE_BOTTOM_CENTER_Y+25;
local INFO_CENTER_X=BASE_BOTTOM_CENTER_X+80;
local INFO_CENTER_Y=BASE_BOTTOM_CENTER_Y;
local BORDER_CENTER_X=INFO_CENTER_X-55;
local BORDER_CENTER_Y=INFO_CENTER_Y-60;
local STITLE_CENTER_X=INFO_CENTER_X;
local STITLE_CENTER_Y=BORDER_CENTER_Y;
local BORDER_W=210;
local BORDER_W2=BORDER_W/2;
local BORDER_W100=BORDER_W/100;

return Def.ActorFrame{
--Base(TOP)
	Def.Quad{
	--LoadActor(THEME:GetPathG("_SelectMusic/white","banner"))..{
		OnCommand=function(self)
			self:zoomto(510,170);
			self:diffuse(1.0,1.0,1.0,0.66);
			self:x(BASE_TOP_CENTER_X);
			self:y(BASE_TOP_CENTER_Y);
		end;
	};
--Jacket 
	Def.Banner{
		OnCommand=function(self)
			self:Load(GetDRInfo("Jacket"));
			self:scaletofit(-75,-75,75,75);
			self:x(DJACKET_CENTER_X);
			self:y(DJACKET_CENTER_Y);
		end;
	};
--Title 
	LoadFont("Common Normal")..{
		InitCommand=cmd(maxwidth,300;);
		OnCommand=function(self)
			self:diffuse(Str2Color(GetDRInfo("Color")));
			local c1=Str2Color(GetDRInfo("Color"))[1];
			local c2=Str2Color(GetDRInfo("Color"))[2];
			if tonumber(c2)<0.8 then
				self:strokecolor(Color("White"));
			else
				self:strokecolor(Color("Outline"));
			end;
			self:settext(GetDRInfo("Title"));
			self:x(DTITLE_CENTER_X);
			self:y(DTITLE_CENTER_Y-65);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(maxwidth,300;);
		OnCommand=function(self)
			self:diffuse(Str2Color(GetLVInfo(""..GetSelDrillLevel().."-Color")));
			local c1=Str2Color(GetLVInfo(""..GetSelDrillLevel().."-Color"))[1];
			local c2=Str2Color(GetLVInfo(""..GetSelDrillLevel().."-Color"))[2];
			if tonumber(c2)<0.8 then
				self:strokecolor(Color("White"));
			else
				self:strokecolor(Color("Outline"));
			end;
			self:settext(GetLVInfo(""..GetSelDrillLevel().."-Name"));
			self:x(DTITLE_CENTER_X);
			self:y(DTITLE_CENTER_Y-30);
		end;
	};
	LoadActor(THEME:GetPathG("_Drills/drill","result"))..{
		InitCommand=function(self)
			self:x(DTITLE_CENTER_X);
			self:y(DTITLE_CENTER_Y+30);
			self:animate(false);
		end;
		OnCommand=function(self)
			if GetDrillFailed() then
				self:setstate(1);
				self:diffuseshift();
			else
				self:setstate(0);
				self:diffuseblink();
				self:effectcolor1(1,1,1,1);
				self:effectcolor2(1,1,1,0.66);
				self:effecttiming(0.1,0,0.1,0);
			end;
			self:diffusealpha(0);
			self:zoom(2);
			self:sleep(0.5);
			self:linear(0.5);
			self:zoom(1);
			self:diffusealpha(1);
		end;
	};
};