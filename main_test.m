clear;
clc;

globalGPS;											%% 读取全局变量
navData = nav_read('\brdc3540.14n');				%% 读取星历文体
[obsType,obsData] = obs_read('\bjfs3540.14o');		%% 读取观测文体

% 一个rinex 文件的GPS位置计算
 count = length(obsData);
 posRec = zeros(count,3);
 for numEpoch = 1:count
	 [Xr,Yr,Zr] = BL(obsData(numEpoch),navData,GM,OMEGA_E,C);
	 posRec(numEpoch,:) = [Xr,Yr,Zr];	
 end


 
% 单个历元接收机位置的计算
[Xr,Yr,Zr] = BL(obsData(1),navData,GM,OMEGA_E,C);


% 单个历元接收机位置的计算
[~,tr] = time2gpsecond(obsData(1).GPST);
Xr = 0;
Yr = 0;
Zr = 0;
ct = 0; 

while 1
	[b1,l1] = singleBL(Xr,Yr,Zr,tr + ct/C,obsData(1).obsRecord{1}{1} ,navData(2),GM,OMEGA_E,C);
	B = b1;
	L = l1;
	
	[b2,l2] = singleBL(Xr,Yr,Zr,tr + ct/C,obsData(1).obsRecord{2}{1} ,navData(3),GM,OMEGA_E,C);
	B = [B;b2];
	L = [L;l2];
	
	[b3,l3] = singleBL(Xr,Yr,Zr,tr + ct/C,obsData(1).obsRecord{3}{1} ,navData(6),GM,OMEGA_E,C);
	B = [B;b3];
	L = [L;l3];
	
	[b4,l4] = singleBL(Xr,Yr,Zr,tr + ct/C,obsData(1).obsRecord{4}{1} ,navData(9),GM,OMEGA_E,C);
	B = [B;b4];
	L = [L;l4];
	
	[b5,l5] = singleBL(Xr,Yr,Zr,tr + ct/C,obsData(1).obsRecord{5}{1} ,navData(10),GM,OMEGA_E,C);	
	B = [B;b5];	
	L = [L;l5];

	P = eye(5);
	N = transpose(B) * P * B ;
	deltaPos = inv(N) *transpose(B) * P * L ;

	Xr = Xr + deltaPos(1);
	Yr = Yr + deltaPos(2);
	Zr = Zr + deltaPos(3);
	ct = ct + deltaPos(4);
	
	if max(abs(deltaPos(1:3,:))) < 1
		break;
	end
	
end



%% GPS秒测
 [gpsWeek,gpsecond] = time2gpsecond(navData(1).GPST); 

%% 卫星位置计算测试
 [Xs,Ys,Zs] = posSatNav(518400,navData(1),GM,OMEGA_E);

	
%% 根据 *.o文件给定的历元时间，计算信号从卫星到接收机的时间；并计算本历元的误差方程系数
  [B,L] = spanTime(obsData(1),navData,GM,OMEGA_E,C);

