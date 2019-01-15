--[[
	アバター設定
	１：初期化（処理）
--]]

local sys_lock=true;
local t=Def.ActorFrame{};

local avaFile={''};
local avaName={C_GetLang('Main','New')};
local avaCnt=1;
-- [ja] アバター一覧取得 
local avalist=FILEMAN:GetDirListing("./Save/waiei/Avatars/",false,false);
for al=1,#avalist do
	local lavalist=string.lower(avalist[al]);
	if string.find(lavalist,'^.*%.ini$') then
		avaCnt=avaCnt+1;
		avaFile[avaCnt]="Save/waiei/Avatars/"..avalist[al]
		local d="_blue";
		local bl=GetTextBlock(avaFile[avaCnt],'main');
		local nm=GetBlockPrm(bl,'name');
		avaName[avaCnt]=nm;
	end;
end;

local char={
	'A','B','C','D','E','F','G',
	'H','I','J','K','L','M','N',
	'O','P','Q','R','S','T','U',
	'V','W','X','Y','Z','(',')',
	'a','b','c','d','e','f','g',
	'h','i','j','k','l','m','n',
	'o','p','q','r','s','t','u',
	'v','w','x','y','z','[',']',
	'1','2','3','4','5','6','7',
	'8','9','0','-','_','!',' ',
	C_GetLang('Name','Save'),C_GetLang('Name','Exit')
};

c_setenvg('file',avaFile);
c_setenvg('name',avaName);
c_setenvg('cnt' ,avaCnt);
c_setenvg('select_part',1);
c_setenvg('select_style',0);
c_setenvg('select_save',0);
c_setenvg('char',char);

t[#t+1]=Def.ActorFrame{
	OnCommand=function(self)
		C_SetNextScreen();
	end;
};

return t;