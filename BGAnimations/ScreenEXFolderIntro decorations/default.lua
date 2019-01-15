local sys_group=GetEXFGroupName();
local exstage=GetEXFStage();
local introFile=GetGroupParameter(sys_group,"Extra"..exstage.."IntroFile");
local introTime=GetGroupParameter(sys_group,"Extra"..exstage.."IntroTime");
local introSkip=GetGroupParameter(sys_group,"Extra"..exstage.."IntroSkip");
local introSound="";
if string.find(introFile,"^.*,.*$") then
	local sp=split(",",introFile);
	introFile=sp[1];
	introSound=sp[2];
end;
local songdir="/Songs/";
if FILEMAN:DoesFileExist("/AdditionalSongs/"..sys_group.."/"..introFile) then
	songdir="/AdditionalSongs/";
end;
if introSound=="" or not FILEMAN:DoesFileExist(songdir..sys_group.."/"..introSound) then
	introSound=THEME:GetPathS("ScreenEXFolderIntro","music");
else
	introSound=songdir..sys_group.."/"..introSound;
end;
local t=Def.ActorFrame{};
if introFile~="" then
	local fn=split("%.",introFile);
	if FILEMAN:DoesFileExist(songdir..sys_group.."/"..introFile) then
		t[#t+1]=Def.ActorFrame{
			InitCommand=function(self)
				if string.lower(fn[#fn])~="lua" then
					self:Center();
				end;
			end;
			LoadActor(songdir..sys_group.."/"..introFile)..{
				OnCommand=function(self)
					if string.lower(fn[#fn])~="lua" then
						self:scaletofit(-SCREEN_CENTER_X,-SCREEN_CENTER_Y,SCREEN_CENTER_X,SCREEN_CENTER_Y);
					end;
				end;
			};
			LoadActor(introSound)..{
				OnCommand=cmd(play);
			};
		};
	end;
end;
return t;