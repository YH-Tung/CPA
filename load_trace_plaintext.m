GLOBALVAR;

global traceNum, pointNum;
global logDirectory;
global logName;
global logFile;
global tracePath;

tic;

trace = zeros(traceNum, pointNum);
plaintext = zeros(traceNum, 16);

fd = fopen(logFile);
fgets(fd);fgets(fd);fgets(fd);

h = waitbar(0, 'Read Trace...');

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

    waitbar(i/traceNum, h, sprintf('%04d/%04d', i, traceNum));
end

close(h);
fclose(fd);

save(strcat(fetchPath, '/trace', logName) ,'trace','plaintext');

toc;
