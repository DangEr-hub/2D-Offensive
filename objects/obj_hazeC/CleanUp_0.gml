ds_list_destroy(hazePoints);
ds_list_destroy(hazeAreas);
if (surface_exists(hazeSurf)) surface_free(hazeSurf);
if (surface_exists(hazePointSurf)) surface_free(hazePointSurf);

