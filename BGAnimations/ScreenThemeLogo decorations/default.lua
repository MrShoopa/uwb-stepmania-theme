local text="zoom,2;diffusealpha,0;spring,1.0;zoom,1;diffusealpha,1";
local t=Def.ActorFrame{
	LoadActor(THEME:GetPathG("ScreenTitleMenu","logo"))..{
		OnCommand=function(self)
			self:Center();
			self:queuecommand("On2");
		end;
		On2Command=loadstring("return cmd("..text..");")();
	};
};
return t;