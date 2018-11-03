function setup_axes( axh )

axis( axh, 'square', 'equal', 'vis3d', 'off' );
view( 3 );
camzoom( 0.8 ); 
hold( axh, 'on' );
camlight( axh, 'right' );

end