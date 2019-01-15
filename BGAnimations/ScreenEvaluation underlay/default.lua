local summary=THEME:GetMetric( Var "LoadingScreen","Summary" );
local t = Def.ActorFrame {};
local group="";
local stage=0;
if IsEXFolder() then
	group=GetEXFGroupName();
	stage=GetEXFStage();
end;
if TC_GetwaieiMode()==1 then
	if (not GAMESTATE:HasEarnedExtraStage() and not summary and stage==0) or
		(stage==1 and GetGroupParameter(group,"extra1resultbackground")=="") or
		(stage==1 and GetGroupParameter(group,"extra1resultbackground")=="*") or
		(stage==2 and GetGroupParameter(group,"extra2resultbackground")=="") or
		(stage==2 and GetGroupParameter(group,"extra2resultbackground")=="*") or
		(stage==0 and GetGroupParameter(group,"earnedextrabackground")=="") then
		t[#t+1] = Def.ActorFrame {
			LoadActor(TC_GetPath("ScreenWithMenuElements","result")) .. {
				InitCommand=cmd(scaletoclipped,SCREEN_WIDTH+1,SCREEN_HEIGHT;Center);
				OffCommand=cmd(diffusealpha,1;linear,0.5;diffusealpha,0);
			};

		};
	end;
end;

return t;
