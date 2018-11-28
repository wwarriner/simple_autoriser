input_file = 'bearing_block.stl';
element_count = 1e6;
[ feeders, stl, mesh, fh ] = determine_feeders( input_file, element_count );