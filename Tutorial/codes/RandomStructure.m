function filtered = RandomStructure( sz )

A = rand(sz);

cut = 6;

d = 10;
[X Y] = meshgrid( -d:d );

D = bsxfun( @hypot, X, Y );

F = double(D<=cut);
F = F./sum(F(:));
filtered = cast( ...
                imfilter( A, F ) > .52, ...
                'double');