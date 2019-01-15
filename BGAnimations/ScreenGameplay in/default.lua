-- [ja] オンライン対戦で任意の文字列を送信する 
local t = Def.ActorFrame {};
local backup={"",""};
if IsNetSMOnline() then
	t[#t+1]=Def.Actor{
		OnCommand=function(self)
			for p=1,2 do
				if GAMESTATE:IsPlayerEnabled("PlayerNumber_P"..p) then
					local ps = GAMESTATE:GetPlayerState("PlayerNumber_P"..p);
					local po = string.lower(ps:GetPlayerOptionsString("ModsLevel_Preferred"));
					local tmp=split(",",po);
					backup[p]="0% skew,no skew";
					for o=1,#tmp do
						if string.find(tmp[o],".*skew") then
							backup[p]=tmp[o];
							break;
						end;
					end;
					GAMESTATE:ApplyPreferredModifiers("PlayerNumber_P"..p,"1234567% skew")
					--														~~~~~~ ｺｺ 
				end;
			end;
			self:sleep(0.5);
			self:queuecommand("Clear");
		end;
		ClearCommand=function(self)
			for p=1,2 do
				if GAMESTATE:IsPlayerEnabled("PlayerNumber_P"..p) then
					GAMESTATE:ApplyPreferredModifiers("PlayerNumber_P"..p,backup[p])
				end;
			end;
		end;
	};
end;
return t;