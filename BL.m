%-----------------      a normal equation of a epoch satlate      -------------
% compute the coefficient and constant of a normal equation
% args   : 
%          obsData		    I	
%		   navData    		I   
% return : Xr,Yr,Zr 		O   the receive position 
% notes  : only GPS
%------------------------------------------------------------------------------



function [Xr,Yr,Zr] = BL(obsData,navData,GM,OMEGA_E,C)
	
	% 接收机的初始位置、及钟差改正(以距离表示: c * t)
	Xr = 0;
	Yr = 0;
	Zr = 0;
	ctr = 0;			
	
	% GPS卫星的颗数
	numGPS = 0;
	for numSat = 1 : obsData.numSat
		if obsData.ListPRN{numSat}(1) == 'G' 
			numGPS = numGPS + 1;
		end
	end
	
	B = ones(numGPS,4);					% 一个历元的法方程系数 B,L
	L = ones(numGPS,1);	
	
	[~,tr] = time2gpsecond(obsData.GPST);		% 将o文件中接收到历元的时间，转换为GPS秒
	
	while 1		
		
		for s = 1 : numGPS				% 每个卫星
			for n = 1 : length(navData)			% 查找可用的星历记录
				if str2double( obsData.ListPRN{s}(2:3) ) == str2double( navData(n).PRN )		% 在时间段内，查找卫星PRN
					[~,ephT]= time2gpsecond(navData(n).GPST)
					if abs(tr - ephT) <= 3600	% 在最近的星历中查找，最好用JMD秒来判断
						[b,l] = singleBL(Xr,Yr,Zr,ctr,tr + ctr/C,obsData.obsRecord{s}{1} ,navData(n),GM,OMEGA_E,C);
						B(s,:) = b;
						L(s,:) = l;	
					end												
				end										
			end
		end
		
		% 一个历元的法方程求解
		P = eye(numGPS);
		N = transpose(B) * P * B ;
		deltaPos = inv(N) *transpose(B) * P * L ;	
		Xr = Xr + deltaPos(1);
		Yr = Yr + deltaPos(2);
		Zr = Zr + deltaPos(3);
		ctr = ctr + deltaPos(4);		
			
		if max(abs(deltaPos(1:3,:))) < 0.001 && abs(deltaPos(4)) < C * 10^(-7)
			break;
		end
	end
	
	