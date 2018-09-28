function patch_example( stl, feeders )
%% SETUP
lightgray = [ 0.9 0.9 0.9 ];
colors = generate_palette( feeders.count, jet );
fh = figure( 'color', 'w' );
axh = axes( fh );

%% DRAW
patch( stl, 'facecolor', lightgray, 'edgealpha', 0.1 );
hold( axh, 'on' );
for i = 1 : feeders.count    
    ph = patch( feeders.fvs{ i } );
    ph.FaceColor = colors( i, : );
    ph.EdgeAlpha = 0.1;
end

%% ADJUST
axis( 'equal' );
axis( 'vis3d' );
axis( 'off' );
view( 45+90*2, 45 );
camzoom( axh, 0.8 );

end