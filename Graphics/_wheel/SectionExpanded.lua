local t = Def.ActorFrame{};
local c=Color("White");
t[#t+1]=Def.ActorFrame{
	SetCommand=function(self,params)
		if params then
			local g="";
			local gn=0;
			
			--[=[
			for i=1,SONGMAN:GetNumSongGroups() do
				if grData[""..i.."-Path"]==params.Text then
					gn=i;
					break;
				end;
			end;
			if grData then
				g=grData[""..gn.."-Jacket"];
				if not g or g=="" then
					g=grData[""..gn.."-Banner"];
				end;
				if not g or g=="" then
					-- call fallback
					g=THEME:GetPathG("Common","fallback jacket");
				end;
			else
				g=THEME:GetPathG("Common","fallback jacket");
			end;
			local gc;
			if string.find(grSortMode[grSys["Sort"]],"^dif.*") then
				gc=ColorLightTone2(grSys["Color-"..grSortMode[grSys["Sort"]]]);
			else
				gc=color("#ffffff");
			end;
			--]=]
			g=THEME:GetPathG("Common","fallback jacket");
			gc=color("#ffffff");

			local tc_paramas={};
			tc_paramas["Index"]=params.DrawIndex-math.round(tonumber(THEME:GetMetric("MusicWheel","NumWheelItems"))/2);
			tc_paramas["Label"]=params.Text;
			tc_paramas["Color"]=c;
			tc_paramas["Graphic"]=GetGroups(params.Text,"jacket") or g;
			tc_paramas["GraphicColor"]=gc;
			tc_paramas["NumSongs"]=0;
			tc_paramas["GroupName"]=GetGroups(params.Text,"name") or params.Text;
			TC_SetWheelFolder(params,tc_paramas);
		end;
	end;
	LoadActor(TC_GetPath("Wheel","SectionExpanded"))..{
		SetMessageCommand=function(self,params)
		end;
	};
};
return t;