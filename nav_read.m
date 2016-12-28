%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  星历文件读取-广播星历     %%%%%%%%%%%%%%%%%%%%%%

 
%%%%%%%%%%%%%%%%%%%%%%%   读取星历文件的头文件，并跳过   %%%%%%%%%%%%%%%%%%%%%%%%
function navData = nav_read(navFile)

fid = fopen(navFile);

while 1
	line = fgetl(fid); 		%% line 为当前读取的
	finishHead = strfind(line,'END OF HEADER');
	if ~isempty(finishHead)
		break;	
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  读取星历数据  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 1;
while 1		
	line = fgetl(fid);
	
	if(line == -1)
		break;
	end
	
	%%每个星历记录的第 1 行，
	navData(i).PRN = line(1:2);
	navData(i).GPST.year = str2num(line(4:5));
	navData(i).GPST.month = str2num(line(7:8));
	navData(i).GPST.date = str2num(line(10:11));
	navData(i).GPST.hour = str2num(line(13:14));
	navData(i).GPST.minute = str2num(line(16:17));
	navData(i).GPST.second = str2num(line(18:22));
	navData(i).af0 = str2num(line(23:41));
	navData(i).af1 = str2num(line(42:60));
	navData(i).af2 = str2num(line(61:79));
	
	%%每个星历记录的第 2 行，
	line = fgetl(fid);	
	navData(i).IODE = str2num(line(4:22));
	navData(i).Crs = str2num(line(23:41));
	navData(i).delta_n = str2num(line(42:60));
	navData(i).M0 = str2num(line(61:79));

	%%每个星历记录的第 3 行，
	line = fgetl(fid);	
	navData(i).Cuc = str2num(line(4:22));
	navData(i).e = str2num(line(23:41));
	navData(i).Cus = str2num(line(42:60));
	navData(i).sqrt = str2num(line(61:79));

	%%每个星历记录的第 4 行，
	line = fgetl(fid);	
	navData(i).TOE = str2num(line(4:22));
	navData(i).Cic = str2num(line(23:41));
	navData(i).OMEGA = str2num(line(42:60));
	navData(i).Cis = str2num(line(61:79));
	
	%%每个星历记录的第 5 行，
	line = fgetl(fid);	
	navData(i).i0 = str2num(line(4:22));
	navData(i).Crc = str2num(line(23:41));
	navData(i).omega = str2num(line(42:60));
	navData(i).OMEGA_DOT = str2num(line(61:79));
	
	%%每个星历记录的第 6 行，
	line = fgetl(fid);	
	navData(i).iDOT = str2num(line(4:22));
	navData(i).L2C = str2num(line(23:41));
	navData(i).PS = str2num(line(42:60));
	navData(i).L2P = str2num(line(61:79));
	
	%%每个星历记录的第 7 行，
	line = fgetl(fid);	
	navData(i).preciseSat = str2num(line(4:22));
	navData(i).healthSat = str2num(line(23:41));
	navData(i).TGD = str2num(line(42:60));
	navData(i).IODC = str2num(line(61:79));
	
	%%每个星历记录的第 8 行，
	line = fgetl(fid);	
	navData(i).timeSend = str2num(line(4:22));
	navData(i).h = str2num(line(23:41));
	navData(i).backup1 = str2num(line(42:60));
	navData(i).backup2 = str2num(line(61:79));
	
	i = i + 1;	%%读取下一条记
	
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
