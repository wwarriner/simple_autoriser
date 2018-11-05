% determine_feeders_example.m by William Warriner, 2018 %
input_file = 'arc_block.stl';
element_count = 1e7;
[ feeders, stl, mesh, fh ] = determine_feeders( input_file, element_count );

patch_example( stl, feeders );
stlwrite_example( feeders, input_file );
vtkwrite_example( mesh, feeders, input_file );