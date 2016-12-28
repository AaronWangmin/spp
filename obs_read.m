%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  观测文件读取              %%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%   读取观测文件的头文件          %%%%%%%%%%%%%%%%%%%%%%%%
function [obsType,obsData] = obs_read(obsFile)

	fid = fopen(obsFile);

	while 1
		line = fgetl(fid); 		%% line 为当前读取的行
		
		%% 读取观测类型行
		typeObsline = strfind(line,'# / TYPES OF OBSERV');
		if ~isempty(typeObsline);				
			numType = str2num(line(1:6));	%% 观测类型数,现只考虑一行
			for i = 1 : numType 
				obsType{i} = line(11+(i-1)*6:12+(i-1)*6);			
			end			
		end
		
		%% 读取头文件结束标志，并跳过头文件
		finishHead = strfind(line,'END OF HEADER');
		if ~isempty(finishHead)
			break;	
		end
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  读取观测数据  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	i = 1; 		% 第一条历元数据
	while 1		
		line = fgetl(fid);
		
		if(line == -1)
			break;
		end
		
		%%每个数据记录的第 1 行
		obsData(i).GPST.year = str2num(line(2:3));
		obsData(i).GPST.month = str2num(line(5:6));
		obsData(i).GPST.date = str2num(line(8:9));
		obsData(i).GPST.hour = str2num(line(11:12));
		obsData(i).GPST.minute = str2num(line(14:15));
		obsData(i).GPST.second = str2double(line(17:27));
		obsData(i).EpochFlag = line(29:29);
		obsData(i).numSat = str2num(line(30:32));
		
		if(obsData(i).EpochFlag == '0')		% 如果数据标志有效，则处理本历元数据
			
			%%读取本历元的卫星列表
			if(obsData(i).numSat <= 12)		% 如果本历元卫星数少于12颗，则只读取一行
				for n = 1 : obsData(i).numSat	
					obsData(i).ListPRN{n} = line(33+(n-1)*3 : 35+(n-1)*3 );
				end
			else							% 如果本历元卫星数多于12颗，则读取两行
				for n = 1 : 12	
					obsData(i).ListPRN{n} = line(33+(n-1)*3 : 35+(n-1)*3 );
				end
				line = fgetl(fid);	
				for n = 13 : obsData(i).numSat	
					obsData(i).ListPRN{n} = line(33+(n-13)*3 : 35+(n-13)*3 );
				end			
			end
			
			%% 本历元，每个卫星的观测数据
			for(j = 1:length(obsData(i).ListPRN))	
			
				% 每种观测类型的观测数据			
				line = fgetl(fid);	
				if(length(obsType) <= 5)		% 如果本历元卫星的观测类型少于5种，则只读取一行		
					for m = 1 : length(obsType)
						if( length(line) <= 1+(m-1)*16 )	% 如果已经到本行结尾
							break;
						end
						obsRecord{m} = str2double(line(1+(m-1)*16 : 14+(m-1)*16 ));
					end
				else							% 如果本历元卫星的观测类型多于5种,则读取两行
					for m = 1 : 5	
						if( length(line) <= 1+(m-1)*16 )	% 如果已经到本行结尾
							break;
						end
						obsRecord{m} = str2double(line(1+(m-1)*16 : 14+(m-1)*16 ));
					end
					line = fgetl(fid);	
					for m = 6 : length(obsType)	
						if( length(line) <= 1+(m-6)*16 )	% 如果已经到本行结尾
							break;
						end
						obsRecord{m} = str2double(line(1+(m-6)*3 : 14+(m-6)*3 ));
					end			
				end
				
				obsData(i).obsRecord{j} = obsRecord;	%% 一个卫星的观测数据		
			end
			j = j + 1;		
		end
		
		%% 读取下一条历元	
		i = i + 1 ; 	
		
	end
	fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%