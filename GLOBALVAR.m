% Usage:
% Put config variable in this file
% these variables should be declared as global like
%   global var
%   var = value
% using GLOBALVAR in your function to use them

% Declaration Start

global traceNum, pointNum;
global logDirectory;
global logName;
global logFile;
global tracePath;
global sboxPath;
global skipTrace;

% Declaration End

% Definition Start

% Trace number and Point number
traceNum = ;
pointNum = ;

% Directory that put every log directory
% The path should be: logDirectory/logName/logName_{001-N}.mat
logDirectory = '';
logName = '';

% path to log file stored by checker
logFile = '';

% path to save the fetched trace and plaintext
tracePath = '';

% path to sbox_hw.mat
sboxPath = '';

% trace need to skip
skipTrace = [];

% Definition End
