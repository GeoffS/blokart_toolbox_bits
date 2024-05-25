include <../OpenSCADdesigns/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>
use <../OpenSCADdesigns/torus.scad>

tapeWidth = 12.5;

baseSolidZ = 4;
baseMagnetPocketZ = 1.7;
magnetPocketDia = 10.2;
baseWrenchZ = 3.6;

baseX = 88.5;
baseY = 3*tapeWidth;
baseZ = baseSolidZ + baseMagnetPocketZ + baseWrenchZ;
baseCornerDia = 15;

echo(str("baseY = ", baseY));

bendRadius = 6.5;
recessXY = 4.8;

recessInsetXY = 16;

recessRadius = recessXY / 2;
cx = recessInsetXY + recessRadius;
cy = baseY - recessInsetXY - recessRadius;

echo(str("cx = ", cx));

recessOffsetZ = recessXY/2 + baseMagnetPocketZ + baseSolidZ;
echo(str("recessOffsetZ = ", recessOffsetZ));

module itemModule()
{
	difference()
	{
		roundedCornerCubeChamfered(dim = [baseX, baseY, baseZ], dia = baseCornerDia, cz = 2);

		allenKeyRecess();
		magnetsRecesses();
		fingerRecess();
	}
}

module fingerRecess()
{
	d = 35;
	x = (magnetRecess1X + magnetRecess2X)/2;
	cz = 2;
	translate([x, 0, baseSolidZ-1 + d/2]) rotate([-90,0,0]) 
	{
		tcy([0,0,-10], d=d, h=100);
		translate([0,0,baseY-d/2-cz]) cylinder(d1=0, d2=50, h=25);
		translate([0,0,-25+d/2+cz]) cylinder(d2=0, d1=50, h=25);
	}
}

magnetRecess1X = cx+bendRadius;
magnetRecess2X = baseX - 9.8;

module magnetsRecesses()
{
	magnetRecess(magnetRecess1X, cy+bendRadius);
	magnetRecess(magnetRecess2X, cy+bendRadius);
	magnetRecess(cx-bendRadius, 10);
}

module magnetRecess(x, y)
{
	translate([x, y, 0])
	{
		tcy([0, 0, baseSolidZ], d=magnetPocketDia, h=100);
		difference()
		{
			translate([0, 0, baseZ-magnetPocketDia/2-1]) cylinder(d1=0, d2=20, h=10);
			cylinder(d=20, h=baseSolidZ+1);
		}
	}
	
}

module allenKeyRecess()
{
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
	echo(str("cx-bendRadius = ", cx-bendRadius));
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
	tcu([-20, -400+baseY-recessInsetXY+recessXY, -20], 400);
}

if(developmentRender)
{
	// display() translate([-22.5,nothing,0]) itemModule();
	display() itemModule();
}
else
{
	itemModule();
}
