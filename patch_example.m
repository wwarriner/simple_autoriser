function patch_example( stl, feeders )
%% SETUP
lightgray = [ 0.9 0.9 0.9 ];
avoided_colors = [ 0 0 0; lightgray; 1 1 1 ];
ph = patch( stl, 'facecolor', lightgray, 'edgealpha', 0.2 );
ph.FaceColor = lightgray; ph.EdgeAlpha = 0.2;
colors = distinguishable_colors( feeders.count, avoided_colors );
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