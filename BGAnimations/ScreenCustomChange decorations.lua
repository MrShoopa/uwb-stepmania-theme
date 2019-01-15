-- [ja] カスタム内でカスタムを読んだ時、同じスクリーン名になることがあるので回避 
local t = Def.ActorFrame{
	Def.Actor{
		OnCommand=function(self)
			C_Init(C_GetChange());
		end;
	};
};
return t;