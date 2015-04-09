tic;

traceNum = 300;
pointNum = 9000;

directory = 'D:\wsp\test\20150324-0001_roy\';
trace = zeros(1000,pointNum);
plaintext = zeros(1000,16);

fd = fopen('D:\wsp\test\log_roy.txt');
fgets(fd);fgets(fd);fgets(fd);

for i=1:traceNum
    filename = strcat('20150324-0001_',num2str(i + 6,'%03i'));
    filename = strcat(directory,filename);
    load(filename);
    for j=1:10000
        if B(j)>0.5
            break;
        end
    end
    for k=1:pointNum
        trace(i,k) = A(j);
        j=j+10;
    end
    
    in = fgets(fd);  
    k = 1;
    while in(k)~=':'
        k=k+1;
    end
    for j=1:16
        jj = 2*j+k;
        first = sscanf(in(jj),'%x');
        second = sscanf(in(jj+1),'%x');
        plaintext(i,j) = first*16 + second;
    end
    fgets(fd);
    
    fprintf(1,'trace %d done\n',i);
end

fclose(fd);

save('D:\wsp\test\20150324-0001_sample9000_trace_plaintext','trace','plaintext');

toc;
