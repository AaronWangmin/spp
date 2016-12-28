%% 将矩阵 A及名称 输出到文本文件
function A2txt(A,name)
fileID = fopen('result_cal_1.txt','a'); %% 追加数据到文件

fprintf(fileID,'%s = \n',name); %% 矩阵名称的输出

[n,m] = size(A);
for i = 1 : n
    for j = 1 : m
       fprintf(fileID,'%16.6f',A(i,j)); 
    end
     fprintf(fileID,'\n');
end
fprintf(fileID,'\n');

fclose(fileID);