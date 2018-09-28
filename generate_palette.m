function palette = generate_palette( n, rgb_cmap )

hsv_cmap = rgb2hsv( rgb_cmap );

p = linspace( 0, 1, size( hsv_cmap, 1 ) );
q = linspace( 0, 1, n );

h = hsv_cmap( :, 1 );
s = hsv_cmap( :, 2);
v = hsv_cmap( :, 3 );

h = interp1( p, h, q ).';
s = interp1( p, s, q ).';
v = interp1( p, v, q ).';

palette = hsv2rgb( [ h s v ] );

end

