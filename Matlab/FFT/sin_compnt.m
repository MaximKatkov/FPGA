function s = sin_compnt(x, n, m, N)

    Pi = 3.141592653589793;
    s = x * ( sin( (2*Pi*m*n) / N ) );