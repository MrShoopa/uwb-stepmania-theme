return Def.ActorFrame{
	OnCommand=cmd(sleep,TC_GetMetric('Wait','StageInformation'));
	LoadActor(THEME:GetPathB('ScreenWithMenuElements','in'));
}