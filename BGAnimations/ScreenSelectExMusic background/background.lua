local t = Def.ActorFrame{};

local sys_group="";
local sys_stage="";
if GetEXFGroupName() then
	sys_group=GetEXFGroupName();
	sys_stage=GetEXFStage();
else
	sys_group=_SONG():GetGroupName();
	sys_stage=GetEXFStage();
end;
local bg=GetGroupParameter(sys_group,"Extra"..sys_stage.."BackGround");
local fn=split("%.",bg);

if bg~="" and FILEMAN:DoesFileExist("/Songs/"..sys_group.."/"..bg)  then
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			if string.lower(fn[#fn])~="lua" then self:Center(); end;
		end;
		LoadActor("/Songs/"..sys_group.."/"..bg);
	};
	t[#t+1] = Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,0,0,0,0);
		OnCommand=cmd(sleep,0.5;linear,0.2;diffusealpha,0.3);
	};
elseif bg~="" and FILEMAN:DoesFileExist("/AdditionalSongs/"..sys_group.."/"..bg) then
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			if string.lower(fn[#fn])~="lua" then self:Center(); end;
		end;
		LoadActor("/AdditionalSongs/"..sys_group.."/"..bg);
	};
	t[#t+1] = Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,0,0,0,0);
		OnCommand=cmd(sleep,0.5;linear,0.2;diffusealpha,0.3);
	};
else
	t[#t+1] = Def.ActorFrame{
		LoadActor(THEME:GetPathB("EXFolder","background"));
	};
end;

return t;