@echo off

openscad.exe -o condition-single.png -D "part=""conditionsingle""" --render DescentOrganiser.scad
openscad.exe -o condition-left.png -D "part=""conditionleft""" --render DescentOrganiser.scad
openscad.exe -o condition-mid.png -D "part=""conditionmid""" --render DescentOrganiser.scad
openscad.exe -o condition-right.png -D "part=""conditionright""" --render DescentOrganiser.scad

openscad.exe -o condition-single.stl -D "part=""conditionsingle""" -D "render_for_print=true" --render DescentOrganiser.scad
openscad.exe -o condition-left.stl -D "part=""conditionleft""" -D "render_for_print=true" --render DescentOrganiser.scad
openscad.exe -o condition-mid.stl -D "part=""conditionmid""" -D "render_for_print=true" --render DescentOrganiser.scad
openscad.exe -o condition-right.stl -D "part=""conditionright""" -D "render_for_print=true" --render DescentOrganiser.scad
