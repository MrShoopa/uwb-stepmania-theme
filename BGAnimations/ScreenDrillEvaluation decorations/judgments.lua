local INFO_CENTER_X,INFO_CENTER_Y=...;
local jud=GetUserPref_Theme("UserJudgementLabel");
local t=Def.ActorFrame{};
local _sg,_df;

t[#t+1]=Def.ActorFrame{
	Def.Actor{
		SetMessageCommand=function(self,params)
			if params and params.Scroll then
				self:finishtweening();
			end;
			sg=nil;
			if GetSelDrillResult()>0 then
				_,sg,_=GetDrillSong(GetLVInfo(""..GetSelDrillLevel().."-Song")[GetSelDrillResult()]);
			else
				for stage=1,GetDrillMaxStage() do
					_,_sg,_=GetDrillSong(GetLVInfo(""..GetSelDrillLevel().."-Song")[stage]);
				end;
			end;
		end;
	};
};
--[ja] Judgmentですの 
juds={"JudgmentLine_W1","JudgmentLine_W2","JudgmentLine_W3",
	"JudgmentLine_W4","JudgmentLine_W5","JudgmentLine_Miss","JudgmentLine_Held"};
judi={"W1","W2","W3","W4","W5","MS","OK"};
for i=1,7 do
	t[#t+1]=Def.ActorFrame{
		SetMessageCommand=function(self)
			self:x(INFO_CENTER_X);
			self:y(INFO_CENTER_Y-30);
		end;
		LoadFont("Common Normal")..{
			OnCommand=function(self)
				self:horizalign(left);
				self:diffuse(GameColor.Judgment[juds[i]]);
				self:strokecolor(Color("Outline"));
				self:maxwidth(75/0.66);
				self:zoom(0.66);
				self:x(-150);
				self:y(i*16)
			end;
			SetMessageCommand=function(self)
				self:settext(_JudgementLabel2(jud,juds[i]));
				if i==10 then
					if GetSelDrillResult()==0 then
						self:visible(false);
					else
						self:visible(true);
					end;
				else
					self:visible(true);
				end;
			end;
		};
		LoadFont("Common Normal")..{
			OnCommand=function(self)
				self:horizalign(right);
				self:diffuse(GameColor.Judgment[juds[i]]);
				self:strokecolor(Color("Outline"));
				self:maxwidth(40/0.66);
				self:zoom(0.66);
				self:x(-30);
				self:y(i*16)
			end;
			SetMessageCommand=function(self)
				self:settext(GetDrillScore(judi[i],GetSelDrillResult()));
				if i==8 then
					if GetSelDrillResult()==0 then
						self:visible(false);
					else
						self:visible(true);
					end;
				else
					self:visible(true);
				end;
			end;
		};
	};
end;
return t;