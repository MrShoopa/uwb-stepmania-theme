return Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("0,0,0,1");cropbottom,1;fadebottom,1);
		OnCommand=function(self)
			(cmd(decelerate,0.5;cropbottom,0;fadebottom,0))(self);
			self:queuecommand("Announcer");
		end;
		AnnouncerCommand=function(self)
			ResetAnnouncer();
		end;
	};
};