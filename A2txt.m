%% ������ A������ ������ı��ļ�
function A2txt(A,name)
fileID = fopen('result_cal_1.txt','a'); %% ׷�����ݵ��ļ�

fprintf(fileID,'%s = \n',name); %% �������Ƶ����

[n,m] = size(A);
for i = 1 : n
    for j = 1 : m
       fprintf(fileID,'%16.6f',A(i,j)); 
    end
     fprintf(fileID,'\n');
end
fprintf(fileID,'\n');

fclose(fileID);