// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function d3d_transform_add_translation(argument0, argument1, argument2) {

	// build the rotation matrix
	var mT = matrix_build_identity();
	mT[12] = argument0;
	mT[13] = argument1;
	mT[14] = argument2;

	var m = matrix_get( matrix_world );
	var mR = matrix_multiply( m, mT );
	matrix_set( matrix_world, mR );
}

function d3d_transform_set_identity() {
	var i = matrix_build_identity();
	matrix_set( matrix_world, i);
}

function d3d_transform_set_rotation_z(argument0) {
	// get the sin and cos of the angle passed in
	var c = dcos(argument0);
	var s = dsin(argument0);

	// build the rotation matrix
	var m = matrix_build_identity();
	m[0] = c;
	m[1] = -s;
	m[4] = s;
	m[5] = c;
	matrix_set( matrix_world, m);
}
