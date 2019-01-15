local ssclogo;
if FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory().."../_fallback/BGAnimations/ScreenInit background/ssc (doubleres).png") then
	ssclogo=true;
else
	ssclogo=false;
end;
local t = Def.ActorFrame{};
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
--[[
local f=SaveFile("test.txt");
f:Write("TEST")
CloseFile(f);
_SYS((FILEMAN:DoesFileExist("test.txt")) and "2T" or "2F");
--]]
		--[ja] テーマカラー強制変更
		local tcol=GetUserPref_Theme("UserColor") and GetUserPref_Theme("UserColor") or "Blue (Defalut)";
		if FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory()..waieiDir().."SetColor.cfg") then
			local f=OpenFile(THEME:GetCurrentThemeDirectory()..waieiDir().."SetColor.cfg");
			local tcname=f:GetLine();
			local tclist={};
			tclist=FILEMAN:GetDirListing(THEME:GetCurrentThemeDirectory()..waieiDir().."ThemeColors/");
			for i=1,#tclist do
				if string.lower(tcname)..".cfg"==string.lower(tclist[i]) then
					SetUserPref_Theme("UserColor",tcname);
					local p=OpenFile(THEME:GetCurrentThemeDirectory()..waieiDir().."ThemeColors/"..tcname..".cfg");
					local tcpath=p:GetLine().."/";
					CloseFile(p);
					SetUserPref_Theme("UserColorPath",tcpath);
					break;
				end;
			end;
			CloseFile(f);
			local f=SaveFile(THEME:GetCurrentThemeDirectory()..waieiDir().."SetColor.cfg");
			tcname="false";
			f:Write(tcname);
			CloseFile(f);
		end;
		self:Center();
	end;
	OnCommand=function(self)
		TC_LoadChk();
	end;
	Def.Quad {
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;
			diffuse,color("1,1,1,1");diffusebottomedge,color("0.8,0.9,1.0,1"));
	};
	LoadActor(THEME:GetPathB("ScreenInit","decorations/waiei"))..{
		InitCommand=cmd(x,-50;diffusealpha,0;);
		OnCommand=cmd(linear,0.3;x,0;diffusealpha,1;
			sleep,2;linear,0.3;x,50;diffusealpha,0;);
	};
	Def.Sprite{
		InitCommand=function(self)
			self:visible(ssclogo);
			if ssclogo then
				self:Load(THEME:GetCurrentThemeDirectory().."../_fallback/BGAnimations/ScreenInit background/ssc (doubleres).png");
			else
				self:Load(THEME:GetCurrentThemeDirectory()..waieiDir().."Graphics/_blank.gif");
			end;
			self:x(-50);
			self:diffusealpha(0);
		end;
		OnCommand=cmd(sleep,2.3;linear,0.3;diffusealpha,1;x,0;
			sleep,2;linear,0.3;x,50;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathB("ScreenInit","decorations/caution"))..{
		InitCommand=cmd(x,-50;diffusealpha,0;);
		OnCommand=cmd(sleep,5.6;linear,0.3;diffusealpha,1;x,0;);
	};
};
t[#t+1] = LoadActor( THEME:GetPathB("_Arcade","decorations") );
return t