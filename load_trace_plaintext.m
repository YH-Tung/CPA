tic;

% Config Start

% Trace number and Point number
traceNum = 999;
pointNum = 9000;

% Directory that put every log directory
% The path should be: logDirectory/logName/logName_{001-N}.mat
logDirectory = '';
logName = '';

% path to log file stored by checker
logFile = '';

% path to save fetch trace and plaintext
fetchPath = '';

% Config End
trace = zeros(1000,pointNum);
plaintext = zeros(1000,16);

fd = fopen(logFile);
fgets(fd);fgets(fd);fgets(fd);

for i=1:traceNum
    filename = strcat(logDirectory, '/',  logName, '/', logName, '_', num2str(i, '%03i'));
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

save(strcat(fetchPath, '/trace', logName) ,'trace','plaintext');

toc;
