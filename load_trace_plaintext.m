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
trace = zeros(traceNum, pointNum);
plaintext = zeros(traceNum, 16);

fd = fopen(logFile);
fgets(fd);fgets(fd);fgets(fd);

for i=1:traceNum
    filename = strcat(logDirectory, '/',  logName, '/', logName, '_', num2str(i, '%03i'));
    load(filename);

    idx = find(A>0.5, 1);

    trace(i,:) = downsample(B(idx:idx + 10 * pointNum - 1), 10)';

    in = fgets(fd);

    k = strfind(in, ':');
    k = k(1);
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
