%-----------------      a normal equation of a single satlate     -------------
% compute the coefficient and constant of a normal equation
% args   : Xr,Yr,Zr,ctr	    I   position and  clock bias of receive(start:0,0,0,0)
%         
%		   pd    		    I   the data of persu....
% return : b、l 			O   the coefficient and constant of normal equation
% notes  :  ctr					以距离表示: c * t
%------------------------------------------------------------------------------



function [b,l] = singleBL(Xr,Yr,Zr,ctr,tr,pd,navData,GM,OMEGA_E,C)
	
	b = zeros(1,4);
	sp = 0.075;
	while 1
		ts = tr - sp;
		[Xk,Yk,Zk,delta_ts] = posSatNav(ts,navData,GM,OMEGA_E);		    % 卫星坐标计算		
		d = ( (Xr - Xk)^2 + (Yr-Yk)^2 +(Zr- Zk)^2)^0.5;					% 卫星到接收机的距禿					
		sp2 = d/C;														% 距离/光鿉					
		if( abs(sp2 - sp) <= 10^(-11) )									% 误差方程系数 B、L 的计箿
			tao = sp2;
			
			b(1,1) = (Xr -Xk)/d;
			b(1,2) = (Yr -Yk)/d;
			b(1,3) = (Zr -Zk)/d;
			b(1,4) = 1;							
		%	l = pd - d - ctr ;							%% 目前仅使用了伪距数据
			l = pd - d + delta_ts * C ;
			
			break;
		end
		sp = sp2;		
	end