local t = Def.ActorFrame{};
if not IsDrill() and not GAMESTATE:IsCourseMode() then
	local c=waieiColor("WheelDefault");
	t[#t+1]=Def.ActorFrame{
		SetCommand=function(self,params)
			if params then
				local g;
				local c;
				local gn='';
				if params.Label=="EXFolder" then
					gn=GetGroups(GetEXFLastPlayedGroup(),'exf_name');
					g =GetGroups(GetEXFLastPlayedGroup(),'exf_jacket');
					c =GetGroups(GetEXFLastPlayedGroup(),'exf_color');
				else
					gn=GetGroups(GetEXFLastPlayedGroup(),'name');
					g =GetGroups(GetEXFLastPlayedGroup(),'gra');
					c =waieiColor("WheelDefault");
				end;
				local gc;
				--[=[
				if grData then
					g=grData[""..grSys["Selected"].."-Jacket"];
					if not g or g=="" then
						g=grData[""..grSys["Selected"].."-Banner"];
					end;
					if not g or g=="" then
						-- call fallback
						g=THEME:GetPathG("Common","fallback jacket");
					end;
				else
					g=THEME:GetPathG("Common","fallback jacket");
				end;
				local c;
				if params.Label=="EXFolder" then
					c=TC_GetColor("Wheel EXFolder");
				else
					c=TC_GetColor("Wheel Return");
				end;
				local gc;
				if string.find(grSortMode[grSys["Sort"]],"^dif.*") then
					gc=ColorLightTone2(grSys["Color-"..grSortMode[grSys["Sort"]]]);
				else
					gc=color("#ffffff");
				end;
				--]=]
				gc=color("#ffffff");

				local tc_paramas={};
				tc_paramas["Index"]=params.DrawIndex-math.round(tonumber(THEME:GetMetric("MusicWheel","NumWheelItems"))/2);
				tc_paramas["Label"]=params.Label;
				tc_paramas["Color"]=c;
				tc_paramas["Graphic"]=g;
				tc_paramas["GraphicColor"]=gc;
				tc_paramas["NumSongs"]=0;
				tc_paramas["GroupName"]=gn;
				TC_SetWheelFolder(params,tc_paramas);
			end;
		end;
		LoadActor(TC_GetPath("Wheel","Return"))..{
			SetMessageCommand=function(self,params)
				self:visible(params.Label~="EXFolder");
			end;
		};
		LoadActor(TC_GetPath("Wheel","EXFolder"),grData,grSys)..{
			SetMessageCommand=function(self,params)
				self:visible(params.Label=="EXFolder");
			end;
		};
	};
end;
return t;