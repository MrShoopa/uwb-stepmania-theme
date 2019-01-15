local key_name={
'Start','Back','Select','Up','Down','Left','Right',
'MenuUp','MenuDown','MenuLeft','MenuRight',
'EffectUp','EffectDown',
};
local t = Def.ActorFrame{
	OnCommand=function(self)
		self:sleep(0.01);
		self:queuecommand('On2');
	end;
	On2Command=function(self)
		CPKeyReset();
	end;
	CodeCommand=function(self,params)
		local down=false;
		if params.Name == 'Start-Down' then
			C_SetKey(params.PlayerNumber,"Start",true);
			C_SetHoldKey(params.PlayerNumber,"Start",true);
			down=true;
		end;
		if params.Name == 'Start-Up' then
			C_SetKey(params.PlayerNumber,"Start",false);
			C_SetHoldKey(params.PlayerNumber,"Start",false);
			down=false;
		end;
		if params.Name == 'Back-Down' then
			C_SetKey(params.PlayerNumber,"Back",true);
			C_SetHoldKey(params.PlayerNumber,"Back",true);
			down=true;
		end;
		if params.Name == 'Back-Up' then
			C_SetKey(params.PlayerNumber,"Back",false);
			C_SetHoldKey(params.PlayerNumber,"Back",false);
			down=false;
		end;
		if params.Name == 'Select-Down' then
			C_SetKey(params.PlayerNumber,"Select",true);
			C_SetHoldKey(params.PlayerNumber,"Select",true);
			down=true;
		end;
		if params.Name == 'Select-Up' then
			C_SetKey(params.PlayerNumber,"Select",false);
			C_SetHoldKey(params.PlayerNumber,"Select",false);
			down=false;
		end;
		if params.Name == 'EffectUp-Down' then
			C_SetKey(params.PlayerNumber,"EffectUp",true);
			C_SetHoldKey(params.PlayerNumber,"EffectUp",true);
			down=true;
		end;
		if params.Name == 'EffectUp-Up' then
			C_SetKey(params.PlayerNumber,"EffectUp",false);
			C_SetHoldKey(params.PlayerNumber,"EffectUp",false);
			down=false;
		end;
		if params.Name == 'EffectDown-Down' then
			C_SetKey(params.PlayerNumber,"EffectDown",true);
			C_SetHoldKey(params.PlayerNumber,"EffectDown",true);
			down=true;
		end;
		if params.Name == 'EffectDown-Up' then
			C_SetKey(params.PlayerNumber,"EffectDown",false);
			C_SetHoldKey(params.PlayerNumber,"EffectDown",false);
			down=false;
		end;
		if params.Name == 'Up1-Down' then
			C_SetKey(params.PlayerNumber,"Up",true);
			C_SetKey(params.PlayerNumber,"MenuUp",true);
			C_SetHoldKey(params.PlayerNumber,"Up",true);
			C_SetHoldKey(params.PlayerNumber,"MenuUp",true);
			down=true;
		end;
		if params.Name == 'Up1-Up' then
			C_SetKey(params.PlayerNumber,"Up",false);
			C_SetKey(params.PlayerNumber,"MenuUp",false);
			C_SetHoldKey(params.PlayerNumber,"Up",false);
			C_SetHoldKey(params.PlayerNumber,"MenuUp",false);
			down=false;
		end;
		if params.Name == 'Down1-Down' then
			C_SetKey(params.PlayerNumber,"Down",true);
			C_SetKey(params.PlayerNumber,"MenuDown",true);
			C_SetHoldKey(params.PlayerNumber,"Down",true);
			C_SetHoldKey(params.PlayerNumber,"MenuDown",true);
			down=true;
		end;
		if params.Name == 'Down1-Up' then
			C_SetKey(params.PlayerNumber,"Down",false);
			C_SetKey(params.PlayerNumber,"MenuDown",false);
			C_SetHoldKey(params.PlayerNumber,"Down",false);
			C_SetHoldKey(params.PlayerNumber,"MenuDown",false);
			down=false;
		end;
		if params.Name == 'Left1-Down' then
			C_SetKey(params.PlayerNumber,"Left",true);
			C_SetKey(params.PlayerNumber,"MenuLeft",true);
			C_SetHoldKey(params.PlayerNumber,"Left",true);
			C_SetHoldKey(params.PlayerNumber,"MenuLeft",true);
			down=true;
		end;
		if params.Name == 'Left1-Up' then
			C_SetKey(params.PlayerNumber,"Left",false);
			C_SetKey(params.PlayerNumber,"MenuLeft",false);
			C_SetHoldKey(params.PlayerNumber,"Left",false);
			C_SetHoldKey(params.PlayerNumber,"MenuLeft",false);
			down=false;
		end;
		if params.Name == 'Right1-Down' then
			C_SetKey(params.PlayerNumber,"Right",true);
			C_SetKey(params.PlayerNumber,"MenuRight",true);
			C_SetHoldKey(params.PlayerNumber,"Right",true);
			C_SetHoldKey(params.PlayerNumber,"MenuRight",true);
			down=true;
		end;
		if params.Name == 'Right1-Up' then
			C_SetKey(params.PlayerNumber,"Right",false);
			C_SetKey(params.PlayerNumber,"MenuRight",false);
			C_SetHoldKey(params.PlayerNumber,"Right",false);
			C_SetHoldKey(params.PlayerNumber,"MenuRight",false);
			down=false;
		end;
		if params.Name == 'UpM-Down' then
			C_SetKey(params.PlayerNumber,"MenuUp",true);
			C_SetHoldKey(params.PlayerNumber,"MenuUp",true);
			down=true;
		end;
		if params.Name == 'UpM-Up' then
			C_SetKey(params.PlayerNumber,"MenuUp",false);
			C_SetHoldKey(params.PlayerNumber,"MenuUp",false);
			down=false;
		end;
		if params.Name == 'DownM-Down' then
			C_SetKey(params.PlayerNumber,"MenuDown",true);
			C_SetHoldKey(params.PlayerNumber,"MenuDown",true);
			down=true;
		end;
		if params.Name == 'DownM-Up' then
			C_SetKey(params.PlayerNumber,"MenuDown",false);
			C_SetHoldKey(params.PlayerNumber,"MenuDown",false);
			down=false;
		end;
		if params.Name == 'LeftM-Down' then
			C_SetKey(params.PlayerNumber,"MenuLeft",true);
			C_SetHoldKey(params.PlayerNumber,"MenuLeft",true);
			down=true;
		end;
		if params.Name == 'LeftM-Up' then
			C_SetKey(params.PlayerNumber,"MenuLeft",false);
			C_SetHoldKey(params.PlayerNumber,"MenuLeft",false);
			down=false;
		end;
		if params.Name == 'RightM-Down' then
			C_SetKey(params.PlayerNumber,"MenuRight",true);
			C_SetHoldKey(params.PlayerNumber,"MenuRight",true);
			down=true;
		end;
		if params.Name == 'RightM-Up' then
			C_SetKey(params.PlayerNumber,"MenuRight",false);
			C_SetHoldKey(params.PlayerNumber,"MenuRight",false);
			down=false;
		end;
		if down then
			MESSAGEMAN:Broadcast("KeyDown");
		else
			MESSAGEMAN:Broadcast("KeyUp");
		end;
		for k=1,#key_name do
			C_SetKey(params.PlayerNumber,key_name[k],false);
		end;
	end;
	ScreenCancelMessageCommand=function(self,params)
		setenv('CP_ReturnScreen',params.Screen);
		self:sleep(0.5);
		self:queuecommand('Exit');
	end;
	ExitCommand=function(self)
		C_End(getenv('CP_ReturnScreen'));
	end;
	Def.Quad{
		InitCommand=cmd(Center;diffuse,0,0,0,0;FullScreen);
		ScreenCancelMessageCommand=cmd(linear,0.3;diffusealpha,1);
	};
	LoadActor(THEME:GetPathS('Screen','Cancel'))..{
		InitCommand=cmd(stop);
		ScreenCancelMessageCommand=cmd(play);
	};
};
return t;