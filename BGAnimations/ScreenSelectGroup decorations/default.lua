local grData={};
local grSys={};
local sys_selgroup;

local _SpaceX={-SCREEN_WIDTH/4*2.5,-SCREEN_WIDTH/2,-SCREEN_WIDTH/4*1.5,-SCREEN_WIDTH/4,0
		,SCREEN_WIDTH/4,SCREEN_WIDTH/4*1.5,SCREEN_WIDTH/2,SCREEN_WIDTH/4*2.5};
local _SpaceY=160;

local t=Def.ActorFrame{
};
local t2=Def.ActorFrame{
	OnCommand=function(self)
		self:playcommand("ChangeGroup");
	end;
	ChangeGroupMessageCommand=function(self)
		grData=getenv("grData");
		grSys=getenv("grSys");
		sys_selgroup=grSys["Selected"];
		self:queuecommand("Set");
	end;
	Def.Quad{
		InitCommand=cmd(Center;diffuse,0,0,0,0;fadetop,0.05;fadebottom,0.05;
			zoomto,SCREEN_WIDTH,SCREEN_HEIGHT-60);
		OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,0.66;)
	};
	LoadActor(TC_GetPath("Wheel","group underlay"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-10-_SpaceY);
			self:zoomto(SCREEN_WIDTH*1.5,40);
		end;
		OnCommand=cmd(diffusealpha,0;linear,0.2;);
		SetCommand=function(self)
			self:diffuse(grSys["Color-"
				..grSortMode[(((grSys["Sort"]-1)+(#grSortMode-1))%#grSortMode)+1]]);
			self:diffusealpha(0.8);
			if grSys["Move"]=="down" then
				self:queuecommand("Down");
			elseif grSys["Move"]=="up" then
				self:queuecommand("Up");
			end;
		end;
		UpCommand=function(self)
			self:finishtweening();
			self:y(SCREEN_CENTER_Y-10);
			self:zoomto(SCREEN_WIDTH*1.5,256);
			self:diffusealpha(0.5);
			self:linear(0.2);
			self:diffusealpha(0.8);
			self:y(SCREEN_CENTER_Y-10-_SpaceY);
			self:zoomto(SCREEN_WIDTH*1.5,40);
		end;
		DownCommand=function(self)
			self:finishtweening();
			self:y(SCREEN_CENTER_Y-10-_SpaceY*1.5);
			self:zoomto(SCREEN_WIDTH*1.5,0);
			self:diffusealpha(0.0);
			self:linear(0.2);
			self:diffusealpha(0.8);
			self:y(SCREEN_CENTER_Y-10-_SpaceY);
			self:zoomto(SCREEN_WIDTH*1.5,40);
		end;
	};
	LoadActor(TC_GetPath("Wheel","group underlay"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-10+_SpaceY);
			self:zoomto(SCREEN_WIDTH*1.5,40);
		end;
		OnCommand=cmd(diffusealpha,0;linear,0.2;);
		SetCommand=function(self)
			self:diffuse(grSys["Color-"
				..grSortMode[((grSys["Sort"])%#grSortMode)+1]]);
			self:diffusealpha(0.8);
			if grSys["Move"]=="down" then
				self:queuecommand("Down");
			elseif grSys["Move"]=="up" then
				self:queuecommand("Up");
			end;
		end;
		UpCommand=function(self)
			self:finishtweening();
			self:y(SCREEN_CENTER_Y-10+_SpaceY*1.5);
			self:zoomto(SCREEN_WIDTH*1.5,0);
			self:diffusealpha(0.0);
			self:linear(0.2);
			self:diffusealpha(0.8);
			self:y(SCREEN_CENTER_Y-10+_SpaceY);
			self:zoomto(SCREEN_WIDTH*1.5,40);
		end;
		DownCommand=function(self)
			self:finishtweening();
			self:y(SCREEN_CENTER_Y-10);
			self:zoomto(SCREEN_WIDTH*1.5,256);
			self:diffusealpha(0.5);
			self:linear(0.2);
			self:diffusealpha(0.8);
			self:y(SCREEN_CENTER_Y-10+_SpaceY);
			self:zoomto(SCREEN_WIDTH*1.5,40);
		end;
	};
	LoadActor(TC_GetPath("Wheel","group underlay"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-10);
			self:zoomto(SCREEN_WIDTH*1.5,256);
		end;
		OnCommand=cmd(diffusealpha,0;linear,0.2;);
		SetCommand=function(self)
			self:diffuse(grSys["Color-"..grSortMode[grSys["Sort"]]]);
			self:diffusealpha(0.5);
			if grSys["Move"]=="down" then
				self:queuecommand("Down");
			elseif grSys["Move"]=="up" then
				self:queuecommand("Up");
			end;
		end;
		UpCommand=function(self)
			self:finishtweening();
			self:diffusealpha(0.8);
			self:y(SCREEN_CENTER_Y-10+_SpaceY);
			self:zoomto(SCREEN_WIDTH*1.5,40);
			self:linear(0.2);
			self:y(SCREEN_CENTER_Y-10);
			self:zoomto(SCREEN_WIDTH*1.5,256);
			self:diffusealpha(0.5);
		end;
		DownCommand=function(self)
			self:finishtweening();
			self:diffusealpha(0.8);
			self:y(SCREEN_CENTER_Y-10-_SpaceY);
			self:zoomto(SCREEN_WIDTH*1.5,40);
			self:linear(0.2);
			self:y(SCREEN_CENTER_Y-10);
			self:zoomto(SCREEN_WIDTH*1.5,256);
			self:diffusealpha(0.5);
		end;
	};
	LoadActor(THEME:GetPathG("_wheel/_sort/sort","name"))..{
		InitCommand=function(self)
			self:horizalign(right);
			self:x(SCREEN_CENTER_X-100);
			self:y(SCREEN_CENTER_Y-100);
		end;
		OnCommand=cmd(addx,-200;linear,0.2;addx,200);
	};
	LoadActor(THEME:GetPathG("_wheel/_sort/sort","name"))..{
		InitCommand=function(self)
			self:horizalign(right);
			self:x(SCREEN_CENTER_X+100);
			self:y(SCREEN_CENTER_Y-100);
			self:rotationz(180);
		end;
		OnCommand=cmd(addx,200;linear,0.2;addx,-200);
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:horizalign(right);
			self:y(SCREEN_CENTER_Y-101);
			self:skewx(-0.1)
			self:maxwidth(SCREEN_CENTER_X-190);
			self:diffuse(Color("White"));
			self:strokecolor(Color("Black"));
		end;
		OnCommand=cmd(x,SCREEN_CENTER_X-350;linear,0.2;);
		SetCommand=function(self)
			self:x(SCREEN_CENTER_X-150);
			self:settext(grSys["Name-"..grSortMode[grSys["Sort"]]]);
			self:strokecolor(BoostColor(grSys["Color-"..grSortMode[grSys["Sort"]]],0.3));
			if grSys["Move"]=="up" or grSys["Move"]=="down" then
				self:finishtweening();
				(cmd(diffusealpha,0;linear,0.2;diffusealpha,1))(self);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:horizalign(left);
			self:y(SCREEN_CENTER_Y-101);
			self:skewx(-0.1)
			self:maxwidth(SCREEN_CENTER_X-190);
			self:diffuse(Color("White"));
			self:strokecolor(Color("Black"));
		end;
		OnCommand=cmd(x,SCREEN_CENTER_X+340;linear,0.2;);
		SetCommand=function(self)
			self:x(SCREEN_CENTER_X+140);
			self:settextf("% 3d / % 3d",sys_selgroup,grData["Max"]);
			self:strokecolor(BoostColor(grSys["Color-"..grSortMode[grSys["Sort"]]],0.3));
			if grSys["Move"]=="up" or grSys["Move"]=="down" then
				self:finishtweening();
				(cmd(diffusealpha,0;linear,0.2;diffusealpha,1))(self);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-11-_SpaceY-8);
			self:skewx(-0.1)
			self:zoom(0.75);
			self:maxwidth(620/0.75);
			self:diffuse(Color("White"));
			self:strokecolor(Color("Black"));
			self:diffusealpha(0.5);
		end;
		OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,0.5);
		SetCommand=function(self)
			self:finishtweening();
			self:settext(grSys["Name-"
				..grSortMode[(((grSys["Sort"]-1)+(#grSortMode-1))%#grSortMode)+1]]);
			if grSys["Move"]=="up" or grSys["Move"]=="down" then
				(cmd(diffusealpha,0;linear,0.2;diffusealpha,0.5))(self);
			end;
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-11+_SpaceY+8);
			self:skewx(-0.1)
			self:zoom(0.75);
			self:maxwidth(620/0.75);
			self:diffuse(Color("White"));
			self:strokecolor(Color("Black"));
			self:diffusealpha(0.5);
		end;
		OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,0.5);
		SetCommand=function(self)
			self:finishtweening();
			self:settext(grSys["Name-"
				..grSortMode[((grSys["Sort"])%#grSortMode)+1]]);
			if grSys["Move"]=="up" or grSys["Move"]=="down" then
				(cmd(diffusealpha,0;linear,0.2;diffusealpha,0.5))(self);
			end;
		end;
	};
	LoadActor(THEME:GetPathG("EditMenu","Left"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-11-_SpaceY+20);
			self:rotationz(90);
		end;
		OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,1);
	};
	LoadActor(THEME:GetPathG("EditMenu","Left"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-11+_SpaceY-20);
			self:rotationz(-90);
		end;
		OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,1);
	};
	LoadActor(THEME:GetPathG("EditMenu","Left"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X-130);
			self:y(SCREEN_CENTER_Y);
			self:rotationz(0);
		end;
		OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,1);
	};
	LoadActor(THEME:GetPathG("EditMenu","Left"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X+130);
			self:y(SCREEN_CENTER_Y);
			self:rotationz(180);
		end;
		OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,1);
	};
};
local M=3
local sel;
for i=-M,M do
t2[#t2+1]=Def.ActorFrame{
	Def.Actor{
		OnCommand=function(self)
			sel=((sys_selgroup+grData["Max"]+i-1)%grData["Max"])+1;
		end;
		SetCommand=function(self)
			sel=((sys_selgroup+grData["Max"]+i-1)%grData["Max"])+1;
		end;
	};
	Def.Sprite{
		OnCommand=function(self)
			self:Load(grData[""..sel.."-Jacket"]);
			self:scaletofit(0,0,90+((i==0) and 90 or 0),90+((i==0) and 90 or 0));
			self:x(SCREEN_CENTER_X+_SpaceX[i+M+2]);
			self:y(SCREEN_CENTER_Y-30+((i==0) and 0 or 45));
			if string.find(grSortMode[grSys["Sort"]],"^dif.*") then
				self:diffuse(ColorLightTone2(grSys["Color-"..grSortMode[grSys["Sort"]]]));
			else
				self:diffuse(1,1,1,1);
			end;
		end;
		SetCommand=function(self)
			self:Load(grData[""..sel.."-Jacket"]);
			if grSys["Move"]=="down" then
				self:queuecommand("Down");
			elseif grSys["Move"]=="up" then
				self:queuecommand("Up");
			elseif grSys["Move"]=="left" then
				self:queuecommand("Left");
			elseif grSys["Move"]=="right" then
				self:queuecommand("Right");
			end;
			self:diffusealpha(1-math.abs(i*0.25));
		end;
		OffCommand=cmd(linear,0.2;zoomy,0);
		UpCommand=function(self)
			self:finishtweening();
			if string.find(grSortMode[grSys["Sort"]],"^dif.*") then
				self:diffuse(ColorLightTone2(grSys["Color-"..grSortMode[grSys["Sort"]]]));
			else
				self:diffuse(1,1,1,1);
			end;
			self:scaletofit(0,0,90+((i==0) and 90 or 0),90+((i==0) and 90 or 0));
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-30+((i==0) and 0 or 45));
			self:diffusealpha(0);
			self:linear(0.2);
			self:x(SCREEN_CENTER_X+_SpaceX[i+M+2]);
			self:y(SCREEN_CENTER_Y-30+((i==0) and 0 or 45));
			self:diffusealpha(1-math.abs(i*0.25));
		end;
		DownCommand=function(self)
			self:finishtweening();
			if string.find(grSortMode[grSys["Sort"]],"^dif.*") then
				self:diffuse(ColorLightTone2(grSys["Color-"..grSortMode[grSys["Sort"]]]));
			else
				self:diffuse(1,1,1,1);
			end;
			self:scaletofit(0,0,90+((i==0) and 90 or 0),90+((i==0) and 90 or 0));
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-30+((i==0) and 0 or 45));
			self:diffusealpha(0);
			self:linear(0.2);
			self:x(SCREEN_CENTER_X+_SpaceX[i+M+2]);
			self:y(SCREEN_CENTER_Y-30+((i==0) and 0 or 45));
			self:diffusealpha(1-math.abs(i*0.25));
		end;
		LeftCommand=function(self)
			self:finishtweening();
			self:scaletofit(0,0,90+((i-1==0) and 90 or 0),90+((i-1==0) and 90 or 0));
			self:x(SCREEN_CENTER_X+_SpaceX[i+M+1]);
			self:y(SCREEN_CENTER_Y-30+((i-1==0) and 0 or 45));
			self:linear(0.1);
			self:scaletofit(0,0,90+((i==0) and 90 or 0),90+((i==0) and 90 or 0));
			self:x(SCREEN_CENTER_X+_SpaceX[i+M+2]);
			self:y(SCREEN_CENTER_Y-30+((i==0) and 0 or 45));
		end;
		RightCommand=function(self)
			self:finishtweening();
			self:scaletofit(0,0,90+((i+1==0) and 90 or 0),90+((i+1==0) and 90 or 0));
			self:x(SCREEN_CENTER_X+_SpaceX[i+M+3]);
			self:y(SCREEN_CENTER_Y-30+((i+1==0) and 0 or 45));
			self:linear(0.1);
			self:scaletofit(0,0,90+((i==0) and 90 or 0),90+((i==0) and 90 or 0));
			self:x(SCREEN_CENTER_X+_SpaceX[i+M+2]);
			self:y(SCREEN_CENTER_Y-30+((i==0) and 0 or 45));
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=cmd(zoom,0.6);
		SetCommand=function(self)
			self:x(SCREEN_CENTER_X+_SpaceX[i+M+2]);
			self:y(SCREEN_CENTER_Y+85);
			self:diffuse(Color("White"));
			self:strokecolor(Color("Black"));
			if grData and grData[""..sel.."-Songs"]==1 then
				self:settext(grData[""..sel.."-Name"]..(i==0 and "\n1 Song" or ""));
			else
				self:settext(grData[""..sel.."-Name"]..(i==0 and "\n"..grData[""..sel.."-Songs"].." Songs" or ""));
			end;
			if i==0 then
				self:zoom(0.6);
				self:maxwidth(280/0.6);
			else
				self:zoom(0.4);
				self:maxwidth(240);
			end;
			self:diffusealpha(1-math.abs(i*0.25));
		end;
		OffCommand=cmd(linear,0.2;zoomy,0);
	};
};
end;
t[#t+1]=t2;
return t;