%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  将时间转换为 GPS秒        %%%%%%%%%%%%%%%%%%%%%%

function [gpsWeek,gpsecond] = time2gpsecond(GPST)
	UT = GPST.hour + (GPST.minute/60) + (GPST.second/3600);
	if (GPST.month <= 2)
		y = GPST.year - 1;
		m = GPST.month + 12;
	else
		y = GPST.year;
		m =  GPST.month;		
	end
	JD = fix(365.25 * (y+2000)) + fix(30.6001 * (m + 1)) + GPST.date + (UT/24) + 1720981.5;
	gpsWeek = fix((JD - 2444244.5)/7);
	gpsecond = (JD - 2444244.5 - gpsWeek * 7) * 24 *3600;