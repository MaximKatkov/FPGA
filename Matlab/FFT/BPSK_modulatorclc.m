function bpsk2_s1 = BPSK_modulatorclc(fd1)
    N = 100;      

    fz = 100e3;                 % частота символов ПСП
    tz = 1/fz;

    %fd1 = 20e6;                % частота дискретизации 
    td1 = 1/fd1;                % период дискретизации 

    fd2 = 0.5e6;
    td2 = 1/fd2;
    
    M1 = fd1/fz;                % количество отсчетов на бит
    
    z1 = randi([0 1],N,1);     
    z2 = z1;
    z2(z1 == 0) = -1;
    
    Z2 = zeros(M1, N);
    for i = 1:fd1/fd2
        Z2(i,:) = z2';
    end
    Z2 = Z2(:)';
    
    t1 = 0:td1:N/fz-td1;   

    
    %% Filter RRC/SRRC
    roll_off = 0.9;
    L = 2;

    t3 = -L*tz:td2:L*tz;
    w_coef = cos(pi*roll_off*t3/tz)./(1 - 4*roll_off^2*t3.^2/tz^2);
    imp_res2 = w_coef.*sin(pi*t3/tz)./(pi * t3/tz);
    imp_res2(1:M1/(fd1/fd2):2*L*M1/(fd1/fd2) + 1) = 0;
    imp_res2(L*M1/(fd1/fd2)+1) = 1;
    imp_res2 = repmat(imp_res2,fd1/fd2,1);
    imp_res2 = imp_res2(:)';

    filt2 = conv(imp_res2, Z2)/4;
    
    
 %% BPSK modulatorclc


fc1 = 60e6;                    % частота несущего колебания 60MHz
%fc2 = 60.2e6;                 % частота несущего колебания 80MHz  
    
S1_ml = cos(2*pi*fc1*t1);
%S2_ml = cos(2*pi*fc2*t1);

bpsk2_s1 = filt2(1:N*M1).* S1_ml;
%bpsk2_s2 = filt2(1:N*M1).* S2_ml;

