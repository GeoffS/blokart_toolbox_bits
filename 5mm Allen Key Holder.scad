include <../OpenSCADdesigns/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>
use <../OpenSCADdesigns/torus.scad>

tapeWidth = 12.5;

baseSolidZ = 2;
baseMagnetPocketZ = 1.7;
baseWrenchZ = 6;

baseX = 80;
baseY = 3*tapeWidth;
baseZ = baseSolidZ + baseMagnetPocketZ + baseWrenchZ;
baseCornerDia = 10;

echo(str("baseY = ", baseY));

module itemModule()
{
	difference()
	{
		roundedCornerCubeChamfered(dim = [baseX, baseY, baseZ], dia = baseCornerDia, cz = 2);

		allenKeyRecess();
	}
}

module allenKeyRecess()
{
	bendRadius = 8.4;
	recessXY = 5.5;

	recessRadius = recessXY / 2;
	cx = 14 + recessRadius;
	cy = baseY - 14 - recessRadius;

	recessOffsetZ = recessXY/2+baseMagnetPocketZ+baseSolidZ;

	// The corner:
	difference()
	{
		translate([cx, cy, recessOffsetZ])
		{
			torus2a(radius=recessRadius, translation=bendRadius);
			difference()
			{
				tcy([0,0,0], d=(bendRadius+recessRadius)*2, h=100);
				tcy([0,0,-20], d=(bendRadius-recessRadius)*2, h=120);
			}
		}
		tcu([        -200, cy-400-nothing, -200], 400);
		tcu([  cx+nothing,           -200, -200], 400);
	}

	// The long leg:
	translate([cx, cy+bendRadius, recessOffsetZ])
	{
		rotate([0,90,0]) hull()
		{
			tcy([0,0,0], d=recessXY, h=100);
			tcy([-100,0,0], d=recessXY, h=100);
		}
	}

	// The short leg:
	translate([cx-bendRadius, cy, recessOffsetZ])
	{
		rotate([90,0,0]) hull()
		{
			tcy([0,0,0], d=recessXY, h=100);
			tcy([0,100,0], d=recessXY, h=100);
		}
	}
}

module roundedCornerCubeChamfered(dim, dia, cz)
{
  r = dia/2;
  x = dim.x - r;
  y = dim.y - r;
  z = dim.z;
  hull()
  {
	tcyz([r, r, 0], d=dia, h=dim.z, cz=cz);
	tcyz([r, y, 0], d=dia, h=dim.z, cz=cz);
	tcyz([x, r, 0], d=dia, h=dim.z, cz=cz);
	tcyz([x, y, 0], d=dia, h=dim.z, cz=cz);
  }
}

module tcyz(t, d, h, cz)
{
	translate(t) simpleChamferedCylinder(d=d, h=h, cz=cz);
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
