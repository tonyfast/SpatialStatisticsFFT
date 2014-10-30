function fA = FourierPadSSFFT( A, osz, nsz );

if all( osz == nsz )
    fA = double(A);
else
    switch numel(nsz)
        case 1
        case 2
            
            fA = [ A, zeros([osz(1),nsz(2)-osz(2)]); zeros( nsz(1)-osz(1),nsz(2))];
        case 3
            fA = cat( 3, [A, zeros( [osz(1) nsz(2)-osz(2) osz(3)]); zeros( [nsz(1)-osz(1) osz(2) osz(3)]), zeros( [nsz(1)-osz(1) nsz(2)-osz(2), osz(3)])],...  
                zeros( [ nsz(1) nsz(2), nsz(3) - osz(3)]));
    end
end

for ii = 1 :  numel(nsz)
    fA(:) = fft( fA, [], ii);
end