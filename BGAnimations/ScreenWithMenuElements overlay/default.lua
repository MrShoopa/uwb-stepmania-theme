local t=Def.ActorFrame{
	OnCommand=function(self)
		TC_LoadChk(Var "LoadingScreen");
	end;
};
return t;

