function patch_example( stl, feeders )
%% SETUP
lightgray = [ 0.9 0.9 0.9 ];
avoided_colors = [ 0 0 0; lightgray; 1 1 1 ];
colors = distinguishable_colors( feeders.count, avoided_colors );
fh = figure( 'color', 'w' );
axh = axes( fh );
%% DRAW
patch( stl, 'facecolor', lightgray, 'edgealpha', 0 );
hold( axh, 'on' );
for i = 1 : feeders.count    
    patch( feeders.fvs{ i }, 'facecolor', colors( i, : ), 'edgealpha', 0 );
end
%% ADJUST
axis( 'equal' );
axis( 'vis3d' );
axis( 'off' );
view( 45+90*2, 45 );
camzoom( axh, 0.8 );
camlight( axh, 'right' );