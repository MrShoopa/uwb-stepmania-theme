-- [ja] ゲーム 
local function _GAME()
	return string.lower(GAMESTATE:GetCurrentGame():GetName());
end

function DrillCode()
	if _GAME()~="pump" then
		return "Start,BackD,BackU,Select,Left,Left2=Left,Right,Right2=Right";
	else
		return "Start,BackD,BackU,Select,Left,Left3=Left,Left4=Left,Right,Right3=Right,Right4=Right,Center=Start";
	end;
end;

function DrillEvaluationCode()
	if _GAME()~="pump" then
		return "Start,Back,Select,Left,Left2=Left,Right,Right2=Right";
	else
		return "Start,Back,Select,Left,Left3=Left,Left4=Left,Right,Right3=Right,Right4=Right,Center=Start";
	end;
end;

function SelectMusicCloseFolder()
	if _GAME()~="pump" then
		return "UP-DOWN";
	else
		return "MenuUp-MenuDown";
	end;
end;

function SelectGroupCode()
	if _GAME()~="pump" then
		return "Start,BackD,BackU,Left,Left2=Left,Right,Right2=Right,Up,Up2=Up,Down,Down2=Down";
	else
		return "Start,BackD,BackU,Center=Start,Left,Left3=Left,Right,Right3=Right,Up,Up3=Up,Down,Down3=Down";
	end;
end;

function SelectMusicCode()
	if _GAME()~="pump" then
		return "ViewScore,ExFolder,ViewScore2=ViewScore,ExFolder2=ExFolder,CloseFolder,CloseFolder2=CloseFolder,Left,Left2=Left,Right,Right2=Right,Start,SelCWheel";
	else
		return "ViewScore2=ViewScore,ExFolder2=ExFolder,ViewScore3=ViewScore,ExFolder3=ExFolder,CloseFolder,CloseFolder3=CloseFolder,Left,Left3=Left,Right,Right3=Right,Start,Center=Start,SelCWheel,SelCWheel2=SelCWheel";
	end;
end;

function OpeningCode()
	if _GAME()~="pump" then
		return "Start,Back,Left,Left2=Left,Right,Right2=Right";
	else
		return "Start,Back,Left,Left3=Left,Left4=Left,Right,Right3=Right,Right4=Right,Center=Start";
	end;
end;

function ThemeLogoCode()
	if _GAME()~="pump" then
		return "Start,Back,Left,Left2=Left,Right,Right2=Right";
	else
		return "Start,Back,Left,Left3=Left,Left4=Left,Right,Right3=Right,Right4=Right,Center=Start";
	end;
end;

function CautionCode()
	if _GAME()~="pump" then
		return "Start,Back";
	else
		return "Start,Back,Center=Start";
	end;
end;

function GameplayCode()
	if _GAME()~="pump" then
		return "ScrollNomal,ScrollNomal2=ScrollNomal,ScrollReverse,ScrollReverse2=ScrollReverse,ScrollPIUNomal,ScrollPIUReverse,HiSpeedUp,HiSpeedUp2=HiSpeedUp,HiSpeedDown,HiSpeedDown2=HiSpeedDown";
	else
		return "ScrollNomal,ScrollNomal3=ScrollNomal,ScrollReverse,ScrollReverse3=ScrollReverse,ScrollPIUNomal,ScrollPIUReverse,HiSpeedUp,HiSpeedUp3=HiSpeedUp,HiSpeedDown,HiSpeedDown3=HiSpeedDown";
	end;
end;

function EvaluationNormalCode()
	if _GAME()~="pump" then
		return "SwitchSongTitle,SwitchSongTitle2=SwitchSongTitle,SwitchSongTitle3=SwitchSongTitle,SwitchSongTitle4=SwitchSongTitle,ShowPopup,ShowPopup2=ShowPopup,Tweet,Tweet2=Tweet";
	else
		return "SwitchSongTitle3=SwitchSongTitle,SwitchSongTitle4=SwitchSongTitle,SwitchSongTitle5=SwitchSongTitle,SwitchSongTitle6=SwitchSongTitle,ShowPopup,ShowPopup3=ShowPopup,Tweet,Tweet2=Tweet";
	end;
end;

function EvaluationSummaryCode()
	if _GAME()~="pump" then
		return "PrevSong,PrevSong2=PrevSong,NextSong,NextSong2=NextSong";
	else
		return "PrevSong,PrevSong3=PrevSong,PrevSong4=PrevSong,NextSong,NextSong3=NextSong,NextSong4=NextSong";
	end;
end;

function SelectThemeColorsCode()
	if _GAME()~="pump" then
		return "Start,BackD,BackU,Left,Left2=Left,Right,Right2=Right,Up,Up2=Up,Down,Down2=Down";
	else
		return "Start,BackD,BackU,Center=Start,Left,Left3=Left,Right,Right3=Right,Up,Up3=Up,Down,Down3=Down";
	end;
end;
function CustomCode()
	if _GAME()~="pump" then
		return "Start-Down,Back-Down,Select-Down,LeftM-Down,Left1-Down,RightM-Down,Right1-Down,UpM-Down,Up1-Down,DownM-Down,Down1-Down,EffectUp-Down,EffectDown-Down,Start-Up,Back-Up,Select-Up,LeftM-Up,Left1-Up,RightM-Up,Right1-Up,UpM-Up,Up1-Up,DownM-Up,Down1-Up,EffectUp-Up,EffectDown-Up";
	else
		return "Start-Down,Back-Down,Select-Down,LeftM-Down,Left2-Down=Left1-Down,RightM-Down,Right2-Down=Right1-Down,UpM-Down,Up2-Down=Up1-Down,DownM-Down,Down2-Down=Down1-Down,Center-Down=Start-Down,EffectUp-Down,EffectDown-Down,Start-Up,Back-Up,Select-Up,LeftM-Up,Left2-Up=Left1-Up,RightM-Up,Right2-Up=Right1-Up,UpM-Up,Up2-Up=Up1-Up,DownM-Up,Down2-Up=Down1-Up,Center-Up=Start-Up,EffectUp-Up,EffectDown-Up";
	end;
end;
