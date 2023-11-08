function X = FFT(x)
 
    N = length(x);
    N_half = N/2;
    XRe = zeros(1,N);
    XIm = zeros(1,N);
    X = zeros(1,N);

    for m = 0:N_half-1

        mN2 = m + N_half+1;

        for n = 0:N_half-1

            a1 = cos_compnt( x(2*n+1), n, m, (N/2), pi );
            a2 = cos_compnt( x(2*n + 2), (1+2*n), m, N, pi );
                
            b1 = sin_compnt( x(2*n+1), n, m, (N/2), pi );
            b2 = sin_compnt( x(2*n + 2), (1+2*n), m, N, pi );
            
            XRe(m+1) = XRe(m+1) + a1 + a2;
            XIm(m+1) = XIm(m+1) - b1 - b2;

            XRe(mN2) = XRe(mN2) + a1 - a2;
            XIm(mN2) = XIm(mN2) - b1 + b2;   

        end

        X(m+1) = sqrt((XRe(m+1))^2 + (XIm(m+1))^2);
        X(mN2) = sqrt((XRe(mN2))^2 + (XIm(mN2))^2);

    end   
 