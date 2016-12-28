%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  卫星定轨-广播星历     %%%%%%%%%%%%%%%%%%%%%%
 %%	ts 		:	卫星发射信号时刻
 %%	navData	:	广播星历数据
 %%
 

function [Xk,Yk,Zk,delta_ts] = posSatNav(ts,navData,GM,OMEGA_E)				
	
	%% 计算卫星钟差
	delta_ts = navData.af0 + navData.af1 * (ts - navData.TOE) + navData.af2 * (ts - navData.TOE)^2;		%%	卫星钟差的改正
	
	%% 计算卫星发射时刻与参考时刻的差
	tk = ts - delta_ts - navData.TOE;		
	if(tk > 302400)
		tk = 302400 - 604800;
	elseif(tk < -302400)
		tk = 302400 + 604800;
	else
		tk = tk;
	end
	
	%% 计算卫星平近点角 Mk	
	A = (navData.sqrt)^2;				%%	卫星轨道长半轴
	n0 = (GM /(A^3) )^0.5;				%%	计算平角速度
	n = n0 + navData.delta_n;			%%  改正平角速度
	Mk = navData.M0 + n * tk;			%%  平近点角
	
	%% 迭代法计算偏近点角 Ek，最后需要最后的一个值即，Ek(end)
	i = 1;
	Ek(i) = Mk;
	while 1		
		Ek(i+1) = Mk + navData.e * sin(Ek(i));		
		if( abs(Ek(i+1) - Ek(i)) < 10^(-12) )
			break
		end
		i = i + 1;
	end
	
	%% 相对论效应
%	dTr = -2 * GM^0.5 /(C^2) * navData.e * sin(Ek);
%	tk = tk - (delta_ts + dTr);
	
	%% 真近角点
	cos_vk = ( cos( Ek(end) ) - navData.e) /(1 - navData.e *cos( Ek(end) ));
	sin_vk = (1 - navData.e^2 )^0.5 * sin( Ek(end) ) /(1 - navData.e *cos( Ek(end) ));
	vk = atan2 (sin_vk,cos_vk);
%	vk = atan2( (1 - navData.e^2 )^0.5 * sin( Ek(end) ) /( cos( Ek(end) ) - navData.e) );
	
	%% 计算纬度参数（升交距角）
	fk = vk + navData.omega;
	
	%% 周期改正项
	delta_uk = navData.Cus * sin(2*fk) + navData.Cuc * cos(2*fk);
	delta_rk = navData.Crs * sin(2*fk) + navData.Crc * cos(2*fk);
	delta_ik = navData.Cis * sin(2*fk) + navData.Cic * cos(2*fk);
	
	%%
	uk = fk + delta_uk;
	rk = A *( 1 - navData.e*cos(Ek(end)) ) + delta_rk;
	ik = navData.i0 + delta_ik;
	
	%% 计算卫星在其轨道面内的坐标
	xk = rk * cos(uk);
	yk = rk * sin(uk);
	zk = 0;
	
	%%
	OMEGA_K = navData.OMEGA + ( navData.OMEGA_DOT-OMEGA_E ) * tk - OMEGA_E * navData.TOE;	
	
	%% 计算卫星在ECEF(WGS84)下的坐标
	Xk = xk * cos(OMEGA_K) - yk * cos(ik) *sin(OMEGA_K);
	Yk = xk * sin(OMEGA_K) + yk * cos(ik) *cos(OMEGA_K);
	Zk = yk * sin(ik);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


















