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
	-- BGM 
t[#t+1] = Def.Sound {
	InitCommand=function(self)
		local bgm=GetGroupParameter(sys_group,"Extra"..sys_stage.."SelectBGM");
		if bgm~="" and FILEMAN:DoesFileExist("/Songs/"..sys_group.."/"..bgm)  then
			self:load("/Songs/"..sys_group.."/"..bgm);
		elseif bgm~="" and FILEMAN:DoesFileExist("/AdditionalSongs/"..sys_group.."/"..bgm) then
			self:load("/AdditionalSongs/"..sys_group.."/"..bgm);
		else
			self:load(THEME:GetPathS("ScreenSelectMusic","loop music"));
		end;
		self:stop();
		self:sleep(0.5);
		self:queuecommand("Play");
	end;
	PlayCommand=cmd(play);
};

return t;