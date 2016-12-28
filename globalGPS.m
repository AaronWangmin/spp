%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  定义常数                  %%%%%%%%%%%%%%%%%%%%%%
C = 299792458; 						%% 光速
PI = 3.141592653589793; 			%% 圆周率
GM = 3.986004415 * (10^14);			%% 地球引力常数
OMEGA_E = 7.2921151467* (10^-5);	%% 地球自转角速度


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  定义数据结构              %%%%%%%%%%%%%%%%%%%%%%


%%	广播星历记录数据-数据结构
navData = struct('PRN',NaN,'year',NaN,'month',NaN,'data',NaN,'hour',NaN,'minute',NaN,'second',NaN,'af0',NaN,'af1',NaN,'af2',NaN,...	%% 星历记录数据，第一行
					'IODE',NaN,'Crs',NaN,'delta_n',NaN,'M0',NaN,...
					'Cuc',NaN,'e',NaN,'Cus',NaN,'sqrt',NaN,...
					'TOE',NaN,'Cic',NaN,'OMEGA',NaN,'Cis',NaN,...
					'i0',NaN,'Crc',NaN,'omega',NaN,'OMEGA_DOT',NaN,...
					'iDOT',NaN,'L2C',NaN,'PS',NaN,'L2P',NaN,...
					'preciseSat',NaN,'healthSat',NaN,'TGD',NaN,'IODC',NaN,...
					'timeSend',NaN,'h',NaN,'backup1',NaN,'backup2',NaN);

%%	（数据记录 obs文件:头文件）观测类型-元胞数组，超过9种观测类型值时，读取时要续行
obsType = cell(20);	 


%%	（数据记录 obs文件:记录文件）

	% 定义卫星列表-元胞数组，超过 12 颗卫星时，读取时要续行，目前最多读取两2行，即24颗
%	ListPRN = cell(24);

	% 定义观测记录-数据结构，每颗卫星的观测数据超过5个时，读取时要续行，目前最多读取两2行，即10个观测数据
%	obsRecord = cell(10);  
			

	% 定义观测数据-数据结构
%	obsData = struct('year',NaN,'month',NaN,'data',NaN,'hour',NaN,'minute',NaN,'second',NaN,'EpochFlag',NaN,'numSat',NaN,'ListPRN',NaN,'obsRecord',NaN);
					
			
				 	