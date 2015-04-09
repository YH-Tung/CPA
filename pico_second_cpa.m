tic;

% Config start

pointNum = 9000;
traceNum = 999;

% path to sbox_hw.mat
sboxPath = '/home/yodalee/program/CPA/sbox_hw.mat';

% path to fetch trace file
tracePath = '/home/yodalee/program/CPA/trace20150409-0001.mat';

% trace need to skip
skipTrace = [19];

% Config end

load(sboxPath);
load(tracePath);

H = zeros(16,256);
H2 = zeros(16,256);

HT = zeros(16,256,pointNum);

T = zeros(pointNum,1);
T2 = zeros(pointNum,1);

print_info = zeros(5,16);

info = zeros(3,16);

for n=1:traceNum

    if any(n==skipTrace)
        continue;
    end

    for i=1:pointNum
        T(i,1) = T(i,1) + trace(n,i);
        T2(i,1) = T2(i,1) + trace(n,i)*trace(n,i);
    end

%    cpa_wave = zeros(256,pointNum);

    for byte=1:16

        cpa_wave = zeros(256,pointNum);
        locus_cpa = zeros(256,1);
        locus_sample = zeros(256,1);

        this_locus_cpa = -2;
        this_locus_sample = 1;

        for key=1:256

            % calculate power hypothesis
            tmp = bi2de(xor(de2bi(plaintext(n,byte),8),de2bi(key-1,8)));
            tmp = sbox(tmp+1);
            hypo = hw(tmp+1)-4;

            if hypo~=0
                H(byte,key) = H(byte,key) + hypo;
                H2(byte,key) = H2(byte,key) + hypo*hypo;
                for i=1:pointNum
                    HT(byte,key,i) = HT(byte,key,i) + trace(n,i)*hypo;
                end
            end

            H_var = (H2(byte,key) - H(byte,key)*H(byte,key) / n) / n;

            locus_cpa(key,1) = -2;

            for i=1:pointNum
                cpa_wave(key,i) = (HT(byte,key,i) - H(byte,key)*T(i,1)/n)/n;
                T_var = (T2(i,1) - T(i,1)*T(i,1) / n) / n;
                if T_var==0
                    cpa_wave(key,i) = 0;
                else
                    cpa_wave(key,i) = cpa_wave(key,i) / sqrt(T_var);
                end
                if H_var==0
                    cpa_wave(key,i) = 0;
                else
                    cpa_wave(key,i) = cpa_wave(key,i) / sqrt(H_var);
                end

                if cpa_wave(key,i) > locus_cpa(key,1)
                    locus_cpa(key,1) = cpa_wave(key,i);
                    locus_sample(key,1) = i;
                end
            end

            if locus_cpa(key,1) > this_locus_cpa
                this_locus_cpa = locus_cpa(key,1);
                this_locus_sample = locus_sample(key,1);
            end
        end


        [result,index] = sort(cpa_wave(:,this_locus_sample),'descend');

        info(1,byte) = index(1)-1;
        info(2,byte) = result(1)-result(2);
        info(3,byte) = this_locus_sample;

    end

    % print whole key

    fprintf(1,'Trace %d done,rank: (%f seconds passing...)\n',n,toc);


    for byte=1:16
        fprintf(1,'    %s ', dec2hex(info(1,byte),2));
    end
    fprintf(1,'\n');
    for byte=1:16
        fprintf(1,' %.4f', info(2,byte));
    end
    fprintf(1,'\n');

    %{
    for byte=1:16
        fprintf(1,'   %04d', info(3,byte));
    end
    %}

    %{
    for ii=1:5
        fprintf(1,'\t%d ',ii);
        for byte=1:16
            fprintf(1,' %s', dec2hex(print_info(ii,byte),2));
        end
        fprintf(1,'\n');
    end
    %}

    %fprintf(1,'\n\n');

end

%fprintf(1,'Key recover success with %d traces:\n',global_success_trace_num);

toc;
