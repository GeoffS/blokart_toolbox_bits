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
	recessXY = 5.5/2;
	cx = 14 + recessXY;
	cy = baseY - 14 - recessXY;

	difference()
	{
		translate([cx, cy, baseSolidZ + recessXY])
		{
			torus2a(radius=recessXY, translation=bendRadius);
			difference()
			{
				tcy([0,0,0], d=(bendRadius+recessXY)*2, h=100);
				tcy([0,0,-20], d=(bendRadius-recessXY)*2, h=120);
			}
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
