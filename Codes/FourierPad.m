function fA = FourierPad( A, osz, nsz );

if all( osz == nsz )
    fA = double(A);
else
    switch numel(nsz)
        case 1
        case 2
            
            fA = [ A, zeros([osz(1),nsz(2)-osz(2)]); zeros( nsz(1)-osz(1),nsz(2))];
        case 3
            
            fA = cat( 3, [ A, zeros( size(A,1)-sz(1), sz(2) - size(A,2));
                zeros( sz(1)-size(A,1), size(A,2)-sz(2))], zeros( [ sz(1:2), sz(3)- size(A,3)]))
    end
end

for ii = 1 :  numel(nsz)
    fA(:) = fft( fA, [], ii);
end