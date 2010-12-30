#include "CParserMath.h"

#include <math.h>

int factorial(int value)
{
	int result = 1;
	for (int i = 1; i <= value; i++) {
		result *= i;
	}
	return result;
}

double radToDeg(double rad)
{
	return (rad * (180.0/M_PI));
}

double degToRad(double deg)
{
	return (deg * (M_PI/180.0));
}