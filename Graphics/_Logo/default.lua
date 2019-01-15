return Def.ActorFrame{
	FOV=60;
	LoadActor("logo ring")..{
		InitCommand=function(self)
			self:diffusealpha(0.8);
			self:rotationy(-25);
			self:rotationx(-45);
			self:spin();
			self:effectmagnitude(0.0,0.0,5.0);
			self:blend("BlendMode_Add");
		end;
	};
	LoadActor("logo main");
};
