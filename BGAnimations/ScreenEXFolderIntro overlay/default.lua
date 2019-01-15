local sys_group=GetEXFGroupName();
local exstage=GetEXFStage();
InitEXFolder(GetEXFGroupName(),GetEXFStage());
if GetEXFTotalSongs()<=0 then
	return Def.ActorFrame{
		OnCommand=function(self)
			KillEXFolder();
			SCREENMAN:SetNewScreen("ScreenSelectMusic");
		end;
	};
end;
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
if introTime=="" then
	introTime=10;
else
	introTime=math.min(tonumber(introTime),60);
end;
if introSkip=="" then
	introSkip=true;
else
	introSkip=tobool(introSkip);
end;
local t=Def.ActorFrame{};
if introFile~="" then
	local fn=split("%.",introFile);
	if FILEMAN:DoesFileExist(songdir..sys_group.."/"..introFile) then
		t[#t+1]=Def.ActorFrame{
			OffMessageCommand=function(self)
				self:sleep(1);
				self:queuecommand("NextScreen");
			end;
			NextScreenCommand=function(self)
				SCREENMAN:SetNewScreen("ScreenSelectExMusic");
			end;
			CodeCommand=function(self,params)
				if introSkip then
					if params.Name=="Start" or params.Name=="Back" then
						mflag=true;
						if string.lower(fn[#fn])=="lua" then
							-- [ja] Luaの場合は1秒置いて切り替え処理をユーザーに任せる 
							MESSAGEMAN:Broadcast("Off");
						else
							self:queuecommand("NextScreen");
						end;
					end;
				end;
			end;
		};
	end;
else
	t[#t+1]=Def.ActorFrame{
		OnCommand=function(self)
			SCREENMAN:SetNewScreen("ScreenSelectExMusic");
		end;
	};
end;
local oTime=0;
local nTime=0;
local mTimer=introTime;
local mflag=false;
local wait=1.0/60;
local function update(self,dt)
	nTime=nTime+dt;
	if not mflag and (mTimer-nTime)<=1 then
		mflag=true;
		MESSAGEMAN:Broadcast("Off");
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update);
return t;