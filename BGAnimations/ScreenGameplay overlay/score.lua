local pn=...;
local scoremode=GetUserPref_Theme("UserCustomScore") or "DancePoints";
local percentscore=PREFSMAN:GetPreference("DancePointsForOni") or true;
local p=(pn==PLAYER_1) and 1 or 2;
local score=0.0;
local pss=STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
return Def.ActorFrame{
	JudgmentMessageCommand = function(self, params)
		if params.TapNoteScore and
		   params.TapNoteScore ~= 'TapNoteScore_AvoidMine' and
		   params.TapNoteScore ~= 'TapNoteScore_HitMine' and
		   params.TapNoteScore ~= 'TapNoteScore_CheckpointMiss' and
		   params.TapNoteScore ~= 'TapNoteScore_CheckpointHit' and
		   params.TapNoteScore ~= 'TapNoteScore_None'
		then
			self:finishtweening();
			self:queuecommand("SetScore");
		end;
	end;
	SetScoreCommand=function(self)
		if pss then
			if scoremode=="DancePoints" then
				if percentscore then
					score=pss:GetActualDancePoints();
				else
					score=(pss:GetPercentDancePoints())*100;
				end;
			else
				score=pss:GetScore();
			end;
		else
			score=0;
		end;
	end;
	Def.RollingNumbers{
		File=THEME:GetPathF("ScoreDisplayNormal","Text");
		InitCommand=function(self)
			if scoremode=="DDR A" or scoremode=="SuperNOVA2" then
				self:Load("RollingNumbersScoreDDRA");
			elseif scoremode=="DancePoints" then
				if percentscore then
					self:Load("RollingNumbersScoreDP_Point");
				else
					self:Load("RollingNumbersScoreDP_Percent");
				end;
			else
				self:Load("RollingNumbersScoreDefault");
			end;
			self:diffuse(BoostColor(PlayerColor(pn),1.1));
			self:diffusetopedge(BoostColor(PlayerColor(pn),1.75));
			TC_ScoreCommand(self);
			self:targetnumber(0);
		end;
		SetScoreCommand=function(self)
			self:targetnumber(1.0*score);
		end;
	};
};