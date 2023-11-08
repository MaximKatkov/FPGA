function X = FFT2(x)
%% Matrix
%     N = length(x);
%     N_half = N/2;
%     m = (0:1:N_half-1)';
%     n = (0:1:N_half-1);
%     Pi = 3.141592653589793;
%     
%     cos1 = cos( (2*Pi*m*n) / (N/2) );
%     cos2 = cos( (2*Pi*m*(1+2*n)) / (N));
%     sin1 = sin( (2*Pi*m*n) / (N/2) );
%     sin2 = sin( (2*Pi*m*(1+2*n)) / (N));
%     
%     e = ones(1,N_half)';
%     
%     x1 = e * x(1:2:N);
%     x2 = e * x(2:2:N);
%     
%     a1 = sum(x1.* cos1,2);
%     a2 = sum(x2.* cos2,2);
% 
%     b1 = sum(x1.* sin1,2);
%     b2 = sum(x2.* sin2,2);
%     
%     X =  ((a1 + a2).^2 + (- b1 - b2).^2).^(0.5);
%% Vectors
    N = length(x);
    N_half = N/2;
    m = (0:1:N_half-1)';
    Pi = 3.141592653589793;
    
    a1=0;a2=0;b1=0;b2=0;

    for n = 0:N_half-1

            a1 = a1 + ( x(2*n+1) *   cos( (2*Pi*m*n) / (N/2) ));
            a2 = a2 + ( x(2*n + 2) * cos( (2*Pi*m*(1+2*n)) / (N)));

            b1 = b1 + ( x(2*n+1) *   sin( (2*Pi*m*n) / (N/2) ));
            b2 = b2 + ( x(2*n + 2) * sin( (2*Pi*m*(1+2*n)) / (N)));

    end

    X = ((( + a1 + a2)).^2 + (( - b1 - b2)).^2).^(0.5);
    

%% cycles
%     N = length(x);
%     N_half = N/2;
%     Pi = 3.141592653589793;
%     XRe = zeros(1,N_half);
%     XIm = zeros(1,N_half);
%     X = zeros(1,N_half);
%     for m = 0:N_half-1
%         for n = 0:N_half-1
%             a1 = ( x(2*n+1) *   cos( (2*Pi*m*n) / (N/2) ));
%             a2 = ( x(2*n + 2) * cos( (2*Pi*m*(1+2*n)) / (N)));
%                 
%             b1 = ( x(2*n+1) *   sin( (2*Pi*m*n) / (N/2) ));
%             b2 = ( x(2*n + 2) * sin( (2*Pi*m*(1+2*n)) / (N)));
%             
%             XRe(m+1) = XRe(m+1) + a1 + a2;
%             XIm(m+1) = XIm(m+1) - b1 - b2;  
%         end
%         X(m+1) = sqrt((XRe(m+1))^2 + (XIm(m+1))^2);
%     end   
   
end

