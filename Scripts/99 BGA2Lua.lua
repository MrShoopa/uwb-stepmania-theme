-- BGAnimation.ini ->  Lua 
-- [ja] BGAnimation.iniをdefault.luaに変換 
-- [ja] 指定した曲の中に3.9用のBGAnimation.iniしか見つからなかった場合変換 
-- [ja] ただし、コンディションは未実装 

local function BGAtoLUA_130(song)
	local bga2lua_debug=false;
	local bga2lua_ver=1.30;
	local bgachk={"bgchanges","fgchanges"};
	local pref_bga2lua=GetUserPref_Theme("UserBGAtoLua");
	if pref_bga2lua=='Never' then return; end;
	local ret="";
	for b=1,2 do
		local bgadata="";
		if bgachk[b]=="fgchanges" then
			bgadata=GetSMParameter(song,"fgchanges");
		else
			bgadata=GetSMParameter(song,"bgchanges");
		end;
	--	bgadata=""
		if bgadata~="" then
			local songdir=song:GetSongDir();
			local bgaprm={};
			bgaprm=split(",",bgadata);
			local bgafind="";	-- [ja] 重複変換を回避するため一時変数に記録 
			local dirlist=FILEMAN:GetDirListing(songdir,true,false);
			for i=1,#bgaprm do
				if string.find(bgaprm[i],"=",0,true) then
					local tmp=string.lower(split("=",bgaprm[i])[2]);
					if not string.find(tmp,".jpg",0,true) and
						not string.find(tmp,".jpeg",0,true) and
						not string.find(tmp,".gif",0,true) and
						not string.find(tmp,".png",0,true) and
						not string.find(tmp,".bmp",0,true) and
						not string.find(tmp,".ogv",0,true) and
						not string.find(tmp,".avi",0,true) and
						not string.find(tmp,".mpg",0,true) and
						not string.find(tmp,".mpeg",0,true) and
						not string.find(tmp,".wmv",0,true) and
						not string.find(tmp,".flv",0,true) and
						not string.find(tmp,".mp4",0,true) and
						not string.find(bgafind,""..tmp..":") then
						bgafind=bgafind..""..tmp..":";
					end;
				end;
			end;
			bgafind=string.gsub(bgafind.."[END]",":%[END%]","");
			bga=split(":",bgafind);
			bgafind="";
			for i=1,#bga do
				local lua_update=true;
				if pref_bga2lua~='Always' and FILEMAN:DoesFileExist(songdir..bga[i].."/default.lua") then
					-- [ja] 更新タイミング「Auto」の場合、BGA2Luaの過去バージョンで変換されたlua以外は更新しない 
					local f_lua_chk=RageFileUtil.CreateRageFile();
					f_lua_chk:Open(songdir..bga[i].."/default.lua",1);
					local line=f_lua_chk:GetLine();
					local l_line=string.lower(line);
					f_lua_chk:Close();
					f_lua_chk:destroy();
					if string.find(l_line,"%-%- bga2lua") then
						_tmp=split(" ",l_line);
						if tonumber(_tmp[3]) and tonumber(_tmp[3])>=(bga2lua_debug and 9.99 or bga2lua_ver) then
							lua_update=false;
						end;
					else
						-- [ja] BGA2Luaを使用せずに作られているため、再変換してはいけない 
							lua_update=false;
					end;
				end;

				if lua_update then
					local lua_save=true;	-- [ja] フォルダ内の画像が1枚だけで、スクロール画像の場合はdefault.luaを作成しない方がいい 

					local f_lua_data="";
					f_lua_data="-- BGA2Lua "..string.format("%3.2f",(bga2lua_debug and 0.01 or bga2lua_ver)).."\n\n";

					if FILEMAN:DoesFileExist(songdir..bga[i].."/bganimation.ini") then
						-- [ja] BGAnimation.iniがある時の処理 
						f_lua_data=f_lua_data.."local t=Def.ActorFrame{\n\tOnCommand=function(self)\n\t\tself:Center();\n";
						if bga2lua_debug then
							f_lua_data=f_lua_data.."_SYS(\'"..bga[i].."\');\n";
						end;
						f_lua_data=f_lua_data.."\tend;\n\n";

						local f_ini=RageFileUtil.CreateRageFile();
						f_ini:Open(songdir..bga[i].."/bganimation.ini",1);
						
						local frame_fov=0;
						local layer_end=false;
						local layer_file="";
						local layer_text="";
						local layer_type=0;
						local layer_tile_vx=0;
						local layer_tile_vy=0;
						local layer_command="";
						local layer_condition="";
						while true do
							local line=f_ini:GetLine();
							local l_line=string.lower(line);
							
							if string.find(l_line,"#",0,true)==0 or string.find(l_line,"//",0,true)==0 then
								-- [ja] この行はコメント 
							else
							
								if f_ini:AtEOF() or string.find(l_line,"%[layer.*%]") then
									layer_end=true;
								elseif string.find(l_line,"^file=") then
									layer_file=split("=",line)[2];
								elseif string.find(l_line,"^text=") then
									layer_text=split("=",line)[2];
									layer_text=string.gsub(layer_text,"::","\\n");
								elseif string.find(l_line,"^type=") then
									local _tmp=split("=",l_line)[2];
									local _tmp=split(" ",_tmp)[1];
									local _tmp=split("\t",_tmp)[1];
									layer_type=tonumber(_tmp);
								elseif string.find(l_line,"^tilevelocityx=") then
									local _tmp=split("=",l_line)[2];
									local _tmp=split(" ",_tmp)[1];
									local _tmp=split("\t",_tmp)[1];
									layer_tile_vx=tonumber(_tmp);
								elseif string.find(l_line,"^tilevelocityy=") then
									local _tmp=split("=",l_line)[2];
									local _tmp=split(" ",_tmp)[1];
									local _tmp=split("\t",_tmp)[1];
									layer_tile_vy=tonumber(_tmp);
								elseif string.find(l_line,"^fov=") then
									local _tmp=split("=",l_line)[2];
									local _tmp=split(" ",_tmp)[1];
									local _tmp=split("\t",_tmp)[1];
									frame_fov=tonumber(_tmp);
								elseif string.find(l_line,"^.*command=") then
									layer_command=split("=",l_line)[2];
								elseif string.find(l_line,"^condition=") then
									layer_condition=split("=",l_line)[2];
								end;

								if layer_end then
									-- [ja] ここで解読処理 
									local output_command="";
									if layer_file~="" then
										if layer_text~="" then
											f_lua_data=f_lua_data.."\tLoadFont(\'"..layer_file.."\')..{\n";
											f_lua_data=f_lua_data.."\t\tText=\'"..layer_text.."\';\n";
											output_command=output_command.."\t\t\tself:diffuse(Color(\'White\'));\n";
											output_command=output_command.."\t\t\tself:strokecolor(Color(\'Outline\'));\n";
										elseif string.lower(layer_file)=="songbackground" then
											f_lua_data=f_lua_data.."\tDef.Banner{\n";
											output_command=output_command.."\t\t\tself:Load(GAMESTATE:GetCurrentSong():GetBackgroundPath());\n";
										elseif string.lower(layer_file)=="songbanner" then
											f_lua_data=f_lua_data.."\tDef.Banner{\n";
											output_command=output_command.."\t\t\tself:Load(GAMESTATE:GetCurrentSong():GetBannerPath());\n";
										elseif string.find(string.lower(layer_file),".*%.sprite$") then
											-- [ja] spriteファイル
											f_lua_data=f_lua_data.."\tDef.Sprite{\n"; 
											local f_lua_chk=RageFileUtil.CreateRageFile();
											f_lua_chk:Open(songdir..bga[i].."/"..layer_file,1);
											while true do
												local line=f_lua_chk:GetLine();
												if not string.find(line,".*%[.*%]$") then
													local l_line=string.lower(line);
													if string.find(l_line,"texture=") then
														-- [ja] layer_file の階層である必要がある 
														if string.find(layer_file,"/",0,true) then
															f_lua_data=f_lua_data.."\t\tTexture=\'";
															local tmp=split("/",layer_file);
															for j=1,#tmp-1 do
																f_lua_data=f_lua_data..tmp[j].."/";
															end;
															f_lua_data=f_lua_data..split("=",line)[2].."\';\n"; 
														else
															f_lua_data=f_lua_data.."\t\tTexture=\'"..split("=",line)[2].."\';\n"; 
														end;
													elseif line~="" then
														f_lua_data=f_lua_data.."\t\t"..line..";\n"; 
													end;
												end;
												if f_lua_chk:AtEOF() then
													break;
												end;
											end;
											f_lua_chk:Close();
											f_lua_chk:destroy();
										elseif string.find(string.lower(layer_file),".*%s%d+x%d+.*%..*$") then
											--[=[
											-- [ja] ファイル名が Name XxX.yyy 形式の場合、spriteファイルとして処理する 
											f_lua_data=f_lua_data.."\tDef.Sprite{\n"; 
											f_lua_data=f_lua_data.."\t\tTexture=\'"..layer_file.."\';\n";
											local tmp1=split(" ",string.lower(layer_file));
											local tmp2=split("%.",tmp1[#tmp1]);	-- [ja] XxX
											local tmp3=split("x",tmp2[1]);
											for j=1,tonumber(tmp3[1])*tonumber(tmp3[2]) do
												f_lua_data=f_lua_data.."\t\tFrame"..string.format("%04d",j-1).."="..(j-1)..";\n";
												f_lua_data=f_lua_data.."\t\tDelay"..string.format("%04d",j-1).."=0.1;\n";
											end;
											--]=]
											-- [ja] このタイプのファイル名はアニメーション+タイルが動作しないので画面いっぱい表示にする 
											-- [ja] ※妥協 
											if layer_type==3 then
												layer_type=0;
												output_command=output_command.."\t\t\tself:scaletocover(-SCREEN_CENTER_X,-SCREEN_CENTER_Y,SCREEN_CENTER_X,SCREEN_CENTER_Y);\n";
											end;
											f_lua_data=f_lua_data.."\tLoadActor(\'"..layer_file.."\')..{\n";
										else
											f_lua_data=f_lua_data.."\tLoadActor(\'"..layer_file.."\')..{\n";
										end;

										if layer_type==1 then
											output_command=output_command.."\t\t\tself:zoomto(640,480);\n";
										elseif layer_type==3 then
											output_command=output_command.."\t\t\tself:zoomto(640,480);\n";
											output_command=output_command.."\t\t\tself:customtexturerect(0,0,640/self:GetWidth(),480/self:GetHeight());\n";
											if layer_tile_vx~=0 or layer_tile_vy~=0 then
												output_command=output_command.."\t\t\tself:texcoordvelocity("..layer_tile_vx.."/self:GetWidth(),"..layer_tile_vy.."/self:GetHeight());\n";
											end;
										end;
										
										if layer_command~="" then
											-- [ja] コマンド分解・解析 
											local lua_cmd_full=split(";",layer_command);
											local lua_cmd_max=0;
											if lua_cmd_full[#lua_cmd_full]=="" then
												lua_cmd_max=#lua_cmd_full-1;
											else
												lua_cmd_max=#lua_cmd_full;
											end;
											for j=1,lua_cmd_max do
												if lua_cmd_full[j]~="" then
													local lua_cmd=split(",",lua_cmd_full[j]);
													if (j==lua_cmd_max and lua_cmd[1]=="sleep") or lua_cmd[1]=="" then
														-- [ja] sleepで終わる場合は動作がおかしくなる為省く 
													else
														-- [ja] 仕様変更などで使えなくなったコマンド 
														if lua_cmd[1]=="additiveblend" then
															output_command=output_command.."\t\t\tself:blend(\'BlendMode_Add\');\n";
															output_command=output_command.."\t\t\tself:diffusealpha("..lua_cmd[2]..");\n";
														else
														-- [ja] 今も使えるコマンド 
															output_command=output_command.."\t\t\tself:"..lua_cmd[1].."(";
															if #lua_cmd>1 then
																for k=2,#lua_cmd do
																	if k>2 then
																		output_command=output_command..","
																	end;
																	if lua_cmd[1]=="x" then
																		output_command=output_command.."-320";
																		if lua_cmd[k]~=0 then
																			output_command=output_command.."+"..lua_cmd[k];
																		end;
																	elseif lua_cmd[1]=="y" then
																		output_command=output_command.."-240";
																		if lua_cmd[k]~=0 then
																			output_command=output_command.."+"..lua_cmd[k];
																		end;
																	else
																		output_command=output_command..lua_cmd[k];
																	end;
																end;
															end;
															output_command=output_command..");\n";
														end;
													end;
												end;
											end;
										end;

										if output_command~="" then
											--f_lua_data=f_lua_data.."\t\tOnCommand=function(self)\n\t\t\tself:finishtweening();\n"..output_command.."\t\tend;\n";
											f_lua_data=f_lua_data.."\t\tOnCommand=function(self)\n"..output_command.."\t\tend;\n";
										end;
										f_lua_data=f_lua_data.."\t};\n\n";
									end;
									if f_ini:AtEOF() then
										break
									end;
									layer_end=false;
									layer_file="";
									layer_text="";
									layer_type=0;
									layer_tile_vx=0;
									layer_tile_vy=0;
									layer_command="";
									layer_condition="";
								end;

							end;

						end;

						if bgachk[b]=="bgchanges" then
							-- [ja] 左右帯 
							f_lua_data=f_lua_data.."\tDef.Quad{\n\t\tOnCommand=function(self)\n";
							f_lua_data=f_lua_data.."\t\t\tself:zoomto((SCREEN_WIDTH-640)/2,SCREEN_HEIGHT);\n";
							f_lua_data=f_lua_data.."\t\t\tself:horizalign(left);\n";
							f_lua_data=f_lua_data.."\t\t\tself:x(-SCREEN_CENTER_X+SCREEN_LEFT);\n";
							f_lua_data=f_lua_data.."\t\t\tself:diffuse(Color(\'Black\'));\n\t\tend;\n\t};\n";
							f_lua_data=f_lua_data.."\tDef.Quad{\n\t\tOnCommand=function(self)\n";
							f_lua_data=f_lua_data.."\t\t\tself:zoomto((SCREEN_WIDTH-640)/2,SCREEN_HEIGHT);\n";
							f_lua_data=f_lua_data.."\t\t\tself:horizalign(right);\n";
							f_lua_data=f_lua_data.."\t\t\tself:x(-SCREEN_CENTER_X+SCREEN_RIGHT);\n";
							f_lua_data=f_lua_data.."\t\t\tself:diffuse(Color(\'Black\'));\n\t\tend;\n\t};\n\n";
						end;

						if frame_fov~=0 then
							f_lua_data=f_lua_data.."\tFOV="..frame_fov..";\n\n"
						end;

						f_ini:Close();
						f_ini:destroy();

					elseif FILEMAN:DoesFileExist(songdir..bga[i].."/default.xml") then
						-- [ja] default.xmlがある時の処理 
						local f_xml=RageFileUtil.CreateRageFile();
						f_xml:Open(songdir..bga[i].."/default.xml",1);

						local txt=f_xml:Read();
						txt=string.gsub(line,"%s"," ");
						local tags=split("<",txt);
						local actor_sub=0;
						local child_sub=0;
						local actor_text={};
						local child_text={};

						local comment=false;
						local command=false;
						local command_text="";
						for _t=1,#tags do
							-- XX XX XX />
							local prm=split(" ",tags[_t]);
							if string.find(prm,"!--",0,true)==0 or comment then
								-- [ja] この行はコメント 
								if string.find(prm,".*%-%->") then
									comment=false;
								else
									comment=true;
								end;
							elseif string.find(prm,"ActorFrame",0,true)==0 then
								actor_sub=actor_sub+1;
								actor_text[actor_sub]="Def.ActorFrame{\n";
							elseif actor_sub>0 then
								prm=string.gsub(prm,'\"',"");
							end;
						end;

						f_xml:Close();
						f_xml:destroy();
						f_lua_data=f_lua_data.."local t=Def.ActorFrame{\n\tOnCommand=function(self)\n\t\tself:Center();\n";
						f_lua_data=f_lua_data.."\tend;\n\n";

					else
						-- [ja] BGAnimation.ini / default.xmlがない時の処理 
						f_lua_data=f_lua_data.."local t=Def.ActorFrame{\n\tOnCommand=function(self)\n\t\tself:Center();\n";
						if bga2lua_debug then
							f_lua_data=f_lua_data.."_SYS(\'"..bga[i].."\');\n";
						end;
						f_lua_data=f_lua_data.."\tend;\n\n";

						local filelist=FILEMAN:GetDirListing(songdir..bga[i].."/",false,false);
						-- [ja] この方法だと10枚以上あったとき重ね順うまくいかないような気がするけどどうしよう 
						table.sort(filelist,
							function(a,b)
								return (a < b)
							end);
						if #filelist==0 then
							lua_save=false;
						end;
						local layer=0;
						for j=1,#filelist do
							if FILEMAN:DoesFileExist(songdir..bga[i].."/"..filelist[j]) 
								and filelist[j]~="default.lua" then
								-- [ja] フォルダ・Luaではない
								layer=layer+1;
								local l_filelist=string.lower(filelist[j]);
								
								f_lua_data=f_lua_data.."\tLoadActor(\'"..filelist[j].."\')..{\n";

								local lua_command="";
								local lua_scroll_x=0;
								local lua_scroll_y=0;
								if string.find(l_filelist,"scrollleft",0,true) then
									lua_scroll_x=200;
								elseif string.find(l_filelist,"scrollright",0,true) then
									lua_scroll_x=-200;
								elseif string.find(l_filelist,"scrollup",0,true) then
									lua_scroll_y=200;
								elseif string.find(l_filelist,"scrolldown",0,true) then
									lua_scroll_y=-200;
								end;

								if (#filelist<=1 and (lua_scroll_x~=0 or lua_scroll_y~=0)) or #filelist==0 then
									lua_save=false;
								else
									if string.find(l_filelist,"stretchspin",0,true) then
										lua_command=lua_command.."\t\t\tself:zoomto(1280,960);\n";
										lua_command=lua_command.."\t\t\tself:spin();\n";
										lua_command=lua_command.."\t\t\tself:effectmagnitude(0,0,60);\n";
									elseif string.find(l_filelist,"stretch",0,true) then
										-- [ja] 3.9用を想定しているのでFullScreenではなく640x480 
										lua_command=lua_command.."\t\t\tself:zoomto(640,480);\n";
									elseif string.find(l_filelist,"tile",0,true) then
										-- [ja] 3.9用を想定しているのでFullScreenではなく640x480 
										lua_command=lua_command.."\t\t\tself:zoomto(640,480);\n";
										lua_command=lua_command.."\t\t\tself:customtexturerect(0,0,640/self:GetWidth(),480/self:GetHeight());\n";
									end;
									if lua_scroll_x~=0 or lua_scroll_y~=0 then
										lua_command=lua_command.."\t\t\tself:texcoordvelocity("..lua_scroll_x.."/self:GetWidth(),"..lua_scroll_y.."/self:GetHeight());\n";
									end;

									if lua_command~="" then
										f_lua_data=f_lua_data.."\t\tOnCommand=function(self)\n"..lua_command.."\t\tend;\n";
									end;
									f_lua_data=f_lua_data.."\t};\n\n";
								end;
							end
						end;
					end;

					if lua_save then
						local f_lua=RageFileUtil.CreateRageFile();
						f_lua:Open(songdir..bga[i].."/default.lua",2);
						f_lua_data=f_lua_data.."};\n\nreturn t;"
						f_lua:Write(f_lua_data);
						f_lua:Close();
						f_lua:destroy();
					end;
				end;

			end;
		end;
	end;
end;

local function BGAtoLUA_120(song)
	local bga2lua_debug=false;
	local bga2lua_ver=1.20;
	local bgachk={"bgchanges","fgchanges"};
	local pref_bga2lua=GetUserPref_Theme("UserBGAtoLua");
	if pref_bga2lua=='Never' then return; end;
	local ret="";
	for b=1,2 do
		local bgadata="";
		if bgachk[b]=="fgchanges" then
			bgadata=GetSMParameter(song,"fgchanges");
		else
			bgadata=GetSMParameter(song,"bgchanges");
		end;
	--	bgadata=""
		if bgadata~="" then
			local songdir=song:GetSongDir();
			local bgaprm={};
			bgaprm=split(",",bgadata);
			local bgafind="";	-- [ja] 重複変換を回避するため一時変数に記録 
			local dirlist=FILEMAN:GetDirListing(songdir,true,false);
			for i=1,#bgaprm do
				if string.find(bgaprm[i],"=",0,true) then
					local tmp=string.lower(split("=",bgaprm[i])[2]);
					if not string.find(tmp,".jpg",0,true) and
						not string.find(tmp,".jpeg",0,true) and
						not string.find(tmp,".gif",0,true) and
						not string.find(tmp,".png",0,true) and
						not string.find(tmp,".bmp",0,true) and
						not string.find(tmp,".ogv",0,true) and
						not string.find(tmp,".avi",0,true) and
						not string.find(tmp,".mpg",0,true) and
						not string.find(tmp,".mpeg",0,true) and
						not string.find(tmp,".wmv",0,true) and
						not string.find(tmp,".flv",0,true) and
						not string.find(tmp,".mp4",0,true) and
						not string.find(bgafind,""..tmp..":") then
						bgafind=bgafind..""..tmp..":";
					end;
				end;
			end;
			bgafind=string.gsub(bgafind.."[END]",":%[END%]","");
			bga=split(":",bgafind);
			bgafind="";
			for i=1,#bga do
				local lua_update=true;
				if pref_bga2lua~='Always' and FILEMAN:DoesFileExist(songdir..bga[i].."/default.lua") then
					-- [ja] 更新タイミング「Auto」の場合、BGA2Luaの過去バージョンで変換されたlua以外は更新しない 
					local f_lua_chk=RageFileUtil.CreateRageFile();
					f_lua_chk:Open(songdir..bga[i].."/default.lua",1);
					local line=f_lua_chk:GetLine();
					local l_line=string.lower(line);
					f_lua_chk:Close();
					f_lua_chk:destroy();
					if string.find(l_line,"%-%- bga2lua") then
						_tmp=split(" ",l_line);
						if tonumber(_tmp[3]) and tonumber(_tmp[3])>=(bga2lua_debug and 9.99 or bga2lua_ver) then
							lua_update=false;
						end;
					else
						-- [ja] BGA2Luaを使用せずに作られているため、再変換してはいけない 
							lua_update=false;
					end;
				end;

				if lua_update then
					local lua_save=true;	-- [ja] フォルダ内の画像が1枚だけで、スクロール画像の場合はdefault.luaを作成しない方がいい 

					local f_lua_data="";
					f_lua_data="-- BGA2Lua "..string.format("%3.2f",(bga2lua_debug and 0.01 or bga2lua_ver)).."\n\nlocal t=Def.ActorFrame{\n";
					f_lua_data=f_lua_data.."\tOnCommand=function(self)\n\t\tself:Center();\n";
					if bga2lua_debug then
						f_lua_data=f_lua_data.."_SYS(\'"..bga[i].."\');\n";
					end;
					f_lua_data=f_lua_data.."\tend;\n\n";

					if FILEMAN:DoesFileExist(songdir..bga[i].."/bganimation.ini") then
						-- [ja] BGAnimation.iniがある時の処理 
						local f_ini=RageFileUtil.CreateRageFile();
						f_ini:Open(songdir..bga[i].."/bganimation.ini",1);
						
						local frame_fov=0;
						local layer_end=false;
						local layer_file="";
						local layer_text="";
						local layer_type=0;
						local layer_tile_vx=0;
						local layer_tile_vy=0;
						local layer_command="";
						local layer_condition="";
						while true do
							local line=f_ini:GetLine();
							local l_line=string.lower(line);
							
							if string.find(l_line,"#",0,true)==0 or string.find(l_line,"//",0,true)==0 then
								-- [ja] この行はコメント 
							else
							
								if f_ini:AtEOF() or string.find(l_line,"%[layer.*%]") then
									layer_end=true;
								elseif string.find(l_line,"^file=") then
									layer_file=split("=",line)[2];
								elseif string.find(l_line,"^text=") then
									layer_text=split("=",line)[2];
									layer_text=string.gsub(layer_text,"::","\\n");
								elseif string.find(l_line,"^type=") then
									local _tmp=split("=",l_line)[2];
									local _tmp=split(" ",_tmp)[1];
									local _tmp=split("\t",_tmp)[1];
									layer_type=tonumber(_tmp);
								elseif string.find(l_line,"^tilevelocityx=") then
									local _tmp=split("=",l_line)[2];
									local _tmp=split(" ",_tmp)[1];
									local _tmp=split("\t",_tmp)[1];
									layer_tile_vx=tonumber(_tmp);
								elseif string.find(l_line,"^tilevelocityy=") then
									local _tmp=split("=",l_line)[2];
									local _tmp=split(" ",_tmp)[1];
									local _tmp=split("\t",_tmp)[1];
									layer_tile_vy=tonumber(_tmp);
								elseif string.find(l_line,"^fov=") then
									local _tmp=split("=",l_line)[2];
									local _tmp=split(" ",_tmp)[1];
									local _tmp=split("\t",_tmp)[1];
									frame_fov=tonumber(_tmp);
								elseif string.find(l_line,"^.*command=") then
									layer_command=split("=",l_line)[2];
								elseif string.find(l_line,"^condition=") then
									layer_condition=split("=",l_line)[2];
								end;

								if layer_end then
									-- [ja] ここで解読処理 
									local output_command="";
									if layer_file~="" then
										if layer_text~="" then
											f_lua_data=f_lua_data.."\tLoadFont(\'"..layer_file.."\')..{\n";
											f_lua_data=f_lua_data.."\t\tText=\'"..layer_text.."\';\n";
											output_command=output_command.."\t\t\tself:diffuse(Color(\'White\'));\n";
											output_command=output_command.."\t\t\tself:strokecolor(Color(\'Outline\'));\n";
										elseif string.lower(layer_file)=="songbackground" then
											f_lua_data=f_lua_data.."\tDef.Banner{\n";
											output_command=output_command.."\t\t\tself:Load(GAMESTATE:GetCurrentSong():GetBackgroundPath());\n";
										elseif string.lower(layer_file)=="songbanner" then
											f_lua_data=f_lua_data.."\tDef.Banner{\n";
											output_command=output_command.."\t\t\tself:Load(GAMESTATE:GetCurrentSong():GetBannerPath());\n";
										elseif string.find(string.lower(layer_file),".*%.sprite$") then
											-- [ja] spriteファイル
											f_lua_data=f_lua_data.."\tDef.Sprite{\n"; 
											local f_lua_chk=RageFileUtil.CreateRageFile();
											f_lua_chk:Open(songdir..bga[i].."/"..layer_file,1);
											while true do
												local line=f_lua_chk:GetLine();
												if not string.find(line,".*%[.*%]$") then
													local l_line=string.lower(line);
													if string.find(l_line,"texture=") then
														-- [ja] layer_file の階層である必要がある 
														if string.find(layer_file,"/",0,true) then
															f_lua_data=f_lua_data.."\t\tTexture=\'";
															local tmp=split("/",layer_file);
															for j=1,#tmp-1 do
																f_lua_data=f_lua_data..tmp[j].."/";
															end;
															f_lua_data=f_lua_data..split("=",line)[2].."\';\n"; 
														else
															f_lua_data=f_lua_data.."\t\tTexture=\'"..split("=",line)[2].."\';\n"; 
														end;
													elseif line~="" then
														f_lua_data=f_lua_data.."\t\t"..line..";\n"; 
													end;
												end;
												if f_lua_chk:AtEOF() then
													break;
												end;
											end;
											f_lua_chk:Close();
											f_lua_chk:destroy();
										elseif string.find(string.lower(layer_file),".*%s%d+x%d+.*%..*$") then
											--[=[
											-- [ja] ファイル名が Name XxX.yyy 形式の場合、spriteファイルとして処理する 
											f_lua_data=f_lua_data.."\tDef.Sprite{\n"; 
											f_lua_data=f_lua_data.."\t\tTexture=\'"..layer_file.."\';\n";
											local tmp1=split(" ",string.lower(layer_file));
											local tmp2=split("%.",tmp1[#tmp1]);	-- [ja] XxX
											local tmp3=split("x",tmp2[1]);
											for j=1,tonumber(tmp3[1])*tonumber(tmp3[2]) do
												f_lua_data=f_lua_data.."\t\tFrame"..string.format("%04d",j-1).."="..(j-1)..";\n";
												f_lua_data=f_lua_data.."\t\tDelay"..string.format("%04d",j-1).."=0.1;\n";
											end;
											--]=]
											-- [ja] このタイプのファイル名はアニメーション+タイルが動作しないので画面いっぱい表示にする 
											-- [ja] ※妥協 
											if layer_type==3 then
												layer_type=0;
												output_command=output_command.."\t\t\tself:scaletocover(-SCREEN_CENTER_X,-SCREEN_CENTER_Y,SCREEN_CENTER_X,SCREEN_CENTER_Y);\n";
											end;
											f_lua_data=f_lua_data.."\tLoadActor(\'"..layer_file.."\')..{\n";
										else
											f_lua_data=f_lua_data.."\tLoadActor(\'"..layer_file.."\')..{\n";
										end;

										if layer_type==1 then
											output_command=output_command.."\t\t\tself:zoomto(640,480);\n";
										elseif layer_type==3 then
											output_command=output_command.."\t\t\tself:zoomto(640,480);\n";
											output_command=output_command.."\t\t\tself:customtexturerect(0,0,640/self:GetWidth(),480/self:GetHeight());\n";
											if layer_tile_vx~=0 or layer_tile_vy~=0 then
												output_command=output_command.."\t\t\tself:texcoordvelocity("..layer_tile_vx.."/self:GetWidth(),"..layer_tile_vy.."/self:GetHeight());\n";
											end;
										end;
										
										if layer_command~="" then
											-- [ja] コマンド分解・解析 
											local lua_cmd_full=split(";",layer_command);
											local lua_cmd_max=0;
											if lua_cmd_full[#lua_cmd_full]=="" then
												lua_cmd_max=#lua_cmd_full-1;
											else
												lua_cmd_max=#lua_cmd_full;
											end;
											for j=1,lua_cmd_max do
												if lua_cmd_full[j]~="" then
													local lua_cmd=split(",",lua_cmd_full[j]);
													if (j==lua_cmd_max and lua_cmd[1]=="sleep") or lua_cmd[1]=="" then
														-- [ja] sleepで終わる場合は動作がおかしくなる為省く 
													else
														-- [ja] 仕様変更などで使えなくなったコマンド 
														if lua_cmd[1]=="additiveblend" then
															output_command=output_command.."\t\t\tself:blend(\'BlendMode_Add\');\n";
															output_command=output_command.."\t\t\tself:diffusealpha("..lua_cmd[2]..");\n";
														else
														-- [ja] 今も使えるコマンド 
															output_command=output_command.."\t\t\tself:"..lua_cmd[1].."(";
															if #lua_cmd>1 then
																for k=2,#lua_cmd do
																	if k>2 then
																		output_command=output_command..","
																	end;
																	if lua_cmd[1]=="x" then
																		output_command=output_command.."-320";
																		if lua_cmd[k]~=0 then
																			output_command=output_command.."+"..lua_cmd[k];
																		end;
																	elseif lua_cmd[1]=="y" then
																		output_command=output_command.."-240";
																		if lua_cmd[k]~=0 then
																			output_command=output_command.."+"..lua_cmd[k];
																		end;
																	else
																		output_command=output_command..lua_cmd[k];
																	end;
																end;
															end;
															output_command=output_command..");\n";
														end;
													end;
												end;
											end;
										end;

										if output_command~="" then
											--f_lua_data=f_lua_data.."\t\tOnCommand=function(self)\n\t\t\tself:finishtweening();\n"..output_command.."\t\tend;\n";
											f_lua_data=f_lua_data.."\t\tOnCommand=function(self)\n"..output_command.."\t\tend;\n";
										end;
										f_lua_data=f_lua_data.."\t};\n\n";
									end;
									if f_ini:AtEOF() then
										break
									end;
									layer_end=false;
									layer_file="";
									layer_text="";
									layer_type=0;
									layer_tile_vx=0;
									layer_tile_vy=0;
									layer_command="";
									layer_condition="";
								end;

							end;

						end;

						if bgachk[b]=="bgchanges" then
							-- [ja] 左右帯 
							f_lua_data=f_lua_data.."\tDef.Quad{\n\t\tOnCommand=function(self)\n";
							f_lua_data=f_lua_data.."\t\t\tself:zoomto((SCREEN_WIDTH-640)/2,SCREEN_HEIGHT);\n";
							f_lua_data=f_lua_data.."\t\t\tself:horizalign(left);\n";
							f_lua_data=f_lua_data.."\t\t\tself:x(-SCREEN_CENTER_X+SCREEN_LEFT);\n";
							f_lua_data=f_lua_data.."\t\t\tself:diffuse(Color(\'Black\'));\n\t\tend;\n\t};\n";
							f_lua_data=f_lua_data.."\tDef.Quad{\n\t\tOnCommand=function(self)\n";
							f_lua_data=f_lua_data.."\t\t\tself:zoomto((SCREEN_WIDTH-640)/2,SCREEN_HEIGHT);\n";
							f_lua_data=f_lua_data.."\t\t\tself:horizalign(right);\n";
							f_lua_data=f_lua_data.."\t\t\tself:x(-SCREEN_CENTER_X+SCREEN_RIGHT);\n";
							f_lua_data=f_lua_data.."\t\t\tself:diffuse(Color(\'Black\'));\n\t\tend;\n\t};\n\n";
						end;

						if frame_fov~=0 then
							f_lua_data=f_lua_data.."\tFOV="..frame_fov..";\n\n"
						end;

						f_ini:Close();
						f_ini:destroy();
					else
						-- [ja] BGAnimation.iniがない時の処理 
						local filelist=FILEMAN:GetDirListing(songdir..bga[i].."/",false,false);
						-- [ja] この方法だと10枚以上あったとき重ね順うまくいかないような気がするけどどうしよう 
						table.sort(filelist,
							function(a,b)
								return (a < b)
							end);
						if #filelist==0 then
							lua_save=false;
						end;
						local layer=0;
						for j=1,#filelist do
							if FILEMAN:DoesFileExist(songdir..bga[i].."/"..filelist[j]) 
								and filelist[j]~="default.lua" then
								-- [ja] フォルダ・Luaではない
								layer=layer+1;
								local l_filelist=string.lower(filelist[j]);
								
								f_lua_data=f_lua_data.."\tLoadActor(\'"..filelist[j].."\')..{\n";

								local lua_command="";
								local lua_scroll_x=0;
								local lua_scroll_y=0;
								if string.find(l_filelist,"scrollleft",0,true) then
									lua_scroll_x=200;
								elseif string.find(l_filelist,"scrollright",0,true) then
									lua_scroll_x=-200;
								elseif string.find(l_filelist,"scrollup",0,true) then
									lua_scroll_y=200;
								elseif string.find(l_filelist,"scrolldown",0,true) then
									lua_scroll_y=-200;
								end;

								if (#filelist<=1 and (lua_scroll_x~=0 or lua_scroll_y~=0)) or #filelist==0 then
									lua_save=false;
								else
									if string.find(l_filelist,"stretchspin",0,true) then
										lua_command=lua_command.."\t\t\tself:zoomto(1280,960);\n";
										lua_command=lua_command.."\t\t\tself:spin();\n";
										lua_command=lua_command.."\t\t\tself:effectmagnitude(0,0,60);\n";
									elseif string.find(l_filelist,"stretch",0,true) then
										-- [ja] 3.9用を想定しているのでFullScreenではなく640x480 
										lua_command=lua_command.."\t\t\tself:zoomto(640,480);\n";
									elseif string.find(l_filelist,"tile",0,true) then
										-- [ja] 3.9用を想定しているのでFullScreenではなく640x480 
										lua_command=lua_command.."\t\t\tself:zoomto(640,480);\n";
										lua_command=lua_command.."\t\t\tself:customtexturerect(0,0,640/self:GetWidth(),480/self:GetHeight());\n";
									end;
									if lua_scroll_x~=0 or lua_scroll_y~=0 then
										lua_command=lua_command.."\t\t\tself:texcoordvelocity("..lua_scroll_x.."/self:GetWidth(),"..lua_scroll_y.."/self:GetHeight());\n";
									end;

									if lua_command~="" then
										f_lua_data=f_lua_data.."\t\tOnCommand=function(self)\n"..lua_command.."\t\tend;\n";
									end;
									f_lua_data=f_lua_data.."\t};\n\n";
								end;
							end
						end;
					end;

					if lua_save then
						local f_lua=RageFileUtil.CreateRageFile();
						f_lua:Open(songdir..bga[i].."/default.lua",2);
						f_lua_data=f_lua_data.."};\n\nreturn t;"
						f_lua:Write(f_lua_data);
						f_lua:Close();
						f_lua:destroy();
					end;
				end;

			end;
		end;
	end;
end;

local function BGAtoLUA_110(song)
	bga2lua_ver="1.10";
	if (GetUserPref_Theme("UserBGAtoLua")=='Never') then return; end;
	local ret="";
	local bgadata=GetSMParameter(song,"bgchanges");
	if bgadata=="" then
		return
	end;
	local songdir=song:GetSongDir();
	local bgaprm={};
	bgaprm=split(",",bgadata);
	for i=1,#bgaprm do
		-- split("=",bgaprm[i])[2] ファイル名
		local tmp=split("=",bgaprm[i])[2];
		if FILEMAN:DoesFileExist(songdir.."/"..tmp.."/bganimation.ini") then
			if (GetUserPref_Theme("UserBGAtoLua")=='Always') or (not FILEMAN:DoesFileExist(songdir.."/"..tmp.."/default.lua")) then
				-- [ja] BGAnimation.iniがあってdefault.luaが無いBGA（3.9用BGA） 
				ret=ret..tmp.."\n"
				-- [ja] ここから変換処理 --
				local f_ini=RageFileUtil.CreateRageFile();
				local f_lua=RageFileUtil.CreateRageFile();
				f_ini:Open(songdir.."/"..tmp.."/bganimation.ini",1);
				f_lua:Open(songdir.."/"..tmp.."/default.lua",2);
				
				local file_lua="-- bga2lua "..bga2lua_ver.."\n\nlocal t=Def.ActorFrame{\n\n";
				local ini_file="<nil>";
				local ini_text="<nil>";
				local ini_type="0";		-- [ja] ストレッチ以外未実装 
				local ini_command="";
				while true do
					local l=f_ini:GetLine();
					local ll=string.lower(l);
					if f_ini:AtEOF() then
						if ini_file~="<nil>" then
							if ini_text=="<nil>" then
								-- [ja] 画像ファイル定義（バナー・背景の場合は読み取り） 
								if string.upper(ini_file)=="SONGBACKGROUND" then
									file_lua=file_lua.."  Def.Sprite{\n    InitCommand=cmd(LoadBackground,GetSongBackground());\n";
								elseif string.upper(ini_file)=="SONGBANNER" then
									file_lua=file_lua.."  Def.Sprite{\n    InitCommand=cmd(LoadBackground,GAMESTATE:GetCurrentSong():GetBannerPath());\n";
								else
									file_lua=file_lua.."  LoadActor(\""..ini_file.."\")..{\n";
								end;
							else
								-- [ja] テキスト定義 
								file_lua=file_lua.."  LoadFont(\""..ini_file.."\")..{\n";
								file_lua=file_lua.."    TEXT=\""..ini_text.."\";\n";
							end;
							-- [ja] コマンド定義 
							if ini_command~="" then
								file_lua=file_lua..""..ini_command;
							end;
							-- [ja] 閉じる（レイヤー単位）
							file_lua=file_lua.."  };\n"
						end;
						break;
						
					-- [ja] 変数 l がオリジナル 
					-- [ja] 変数 ll が小文字変換 

					-- [ja] 各項目取得
					elseif string.find(ll,"file=.*") and ini_file=="<nil>" then
						ini_file=split("=",l)[2];
						ini_file=split(";",ini_file)[1];
					elseif string.find(ll,"text=.*") and ini_text=="<nil>" then
						ini_text=split("=",l)[2];
						ini_text=split(";",ini_text)[1];
						ini_text=string.gsub(ini_text,"::","\\n");
					elseif string.find(ll,"type=.*") then
						ini_type=split("=",l)[2];
						ini_type=split(";",ini_type)[1];
					-- [ja] Command=XXXXXX の場合 
					elseif string.find(ll,"command=.*") then
						-- [ja] オリジナルのコマンドデータを取得 
						local tmp="="..split("=",l)[2];
						ini_command=ini_command.."    OnCommand=cmd(";
						-- [ja] 座標定義がない場合Center定義をする必要がある
						if (not string.find(tmp,";x,")) and (not string.find(tmp,"=x,")) and (not string.find(tmp," x,")) then
							ini_command=ini_command.."x,SCREEN_CENTER_X;";
						else
						-- [ja] BGAは4:3ベースで作られているため現在の画面サイズから値を計算してずらす
							l=string.gsub(l,";x,",";x,(SCREEN_WIDTH-640)/2+");
							l=string.gsub(l,"=x,","=x,(SCREEN_WIDTH-640)/2+");
							l=string.gsub(l," x,"," x,(SCREEN_WIDTH-640)/2+");
							-- [ja] .../2+-320... という記述になる可能性があるので +- を - に変換
							l=string.gsub(l,"%+%-","%-");
						end;
						if (not string.find(tmp,";y,")) and (not string.find(tmp,"=y,"))and (not string.find(tmp," y,")) then
							ini_command=ini_command.."y,SCREEN_CENTER_Y;";
						else
							l=string.gsub(l,";y,",";y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l,"=y,","=y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l," y,"," y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l,"%+%-","%-");
						end;
						-- [ja] TYPE=1（ストレッチ）の場合、画面全体に拡大
						if ini_type=="1" then
							ini_command=ini_command.."zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;";
						end;
						-- [ja] コマンドの最後がSleepで大きめの値をとられている場合、正しく動作しないことを確認しているので取り外す 
						local tmp=split(";",l);
						if #tmp>1 then
							if tmp[#tmp]=="" then
								local ltmp=string.lower(tmp[#tmp-1])
								if string.find(ltmp,"sleep,.*") then
									l=string.gsub(l,";"..tmp[#tmp-1],"");
								end;
							else
								local ltmp=string.lower(tmp[#tmp])
								if string.find(ltmp,"sleep,.*") then
									l=string.gsub(l,";"..tmp[#tmp],"");
								end;
							end;
						end;
						ini_command=ini_command..split("=",l)[2]..");\n";
					-- [ja] xxCommand=XXXXXX の場合（例：OnCommand等） 
					elseif string.find(ll,"^.*command=.*") then
						ini_command=ini_command.."    "..split("=",l)[1].."=cmd(";
						if (not string.find(tmp,";x,")) and (not string.find(tmp,"=x,")) and (not string.find(tmp," x,")) then
							ini_command=ini_command.."x,SCREEN_CENTER_X;";
						else
							l=string.gsub(l,";x,",";x,(SCREEN_WIDTH-640)/2+");
							l=string.gsub(l,"=x,","=x,(SCREEN_WIDTH-640)/2+");
							l=string.gsub(l," x,"," x,(SCREEN_WIDTH-640)/2+");
							l=string.gsub(l,"%+%-","%-");
						end;
						if (not string.find(tmp,";y,")) and (not string.find(tmp,"=y,"))and (not string.find(tmp," y,")) then
							ini_command=ini_command.."y,SCREEN_CENTER_Y;";
						else
							l=string.gsub(l,";y,",";y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l,"=y,","=y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l," y,"," y,(SCREEN_HEIGHT-480)/2+");
							l=string.gsub(l,"%+%-","%-");
						end;
						if ini_type=="1" then
							ini_command=ini_command.."zoomto,640,480;";
						end;
						-- [ja] コマンドの最後がSleepで大きめの値をとられている場合、正しく動作しないことを確認しているので取り外す 
						local tmp=split(";",l);
						if #tmp>1 then
							if tmp[#tmp]=="" then
								local ltmp=string.lower(tmp[#tmp-1])
								if string.find(ltmp,"sleep,.*") then
									l=string.gsub(l,";"..tmp[#tmp-1],"");
								end;
							else
								local ltmp=string.lower(tmp[#tmp])
								if string.find(ltmp,"sleep,.*") then
									l=string.gsub(l,";"..tmp[#tmp],"");
								end;
							end;
						end;
						ini_command=ini_command..split("=",l)[2]..");\n";
					-- [ja] テキスト先頭の可能性があるので、BOM考慮して .* を頭につける 
					elseif string.find(ll,".*%[layer.*%]") then
						if ini_file~="<nil>" then
							if ini_text=="<nil>" then
								file_lua=file_lua.."  LoadActor(\""..ini_file.."\")..{\n";
							else
								file_lua=file_lua.."  LoadFont(\""..ini_file.."\")..{\n";
								file_lua=file_lua.."    TEXT=\""..ini_text.."\";\n";
							end;
							file_lua=file_lua..""..ini_command;
							file_lua=file_lua.."  };\n\n"
						end;
						ini_file="<nil>";	-- [ja] ファイル指定なし 
						ini_text="<nil>";	-- [ja] テキスト指定なし 
						ini_command="";		-- [ja] コマンド初期化 
						ini_type="0";		-- [ja] コマンド初期化 
					end;
				end;
				
				-- [ja] 両サイドに帯をつける 
				file_lua=file_lua.."\n  Def.Quad{\n    OnCommand=cmd(diffuse,0,0,0,1;x,SCREEN_LEFT;y,SCREEN_CENTER_Y;zoomto,(SCREEN_WIDTH-640)/2,SCREEN_HEIGHT;horizalign,left;)\n  };\n";
				file_lua=file_lua.."  Def.Quad{\n    OnCommand=cmd(diffuse,0,0,0,1;x,SCREEN_RIGHT;y,SCREEN_CENTER_Y;zoomto,(SCREEN_WIDTH-640)/2,SCREEN_HEIGHT;horizalign,right;)\n  };\n\n";
				-- [ja] 閉じる 
				file_lua=file_lua.."\n};\n\nreturn t;\n";
				
				f_lua:Write(file_lua);
				f_ini:Close();
				f_lua:Close();
				f_ini:destroy();
				f_lua:destroy();
				-- [ja] ここまで変換処理 --
			end;
		end;
	end;
	return;
end;

function BGAtoLUA(song)
	BGAtoLUA_120(song);
end;
