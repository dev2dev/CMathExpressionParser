#include "CParserMath.h"

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

//standard functions

double IF(double exp)
{
	return exp ? 1.0f : 0.0f;
}

double IFNOT(double exp)
{
	return exp ? 0.0f : 1.0f;
}

//debug

double debugLog(double exp)
{
	printf("> %f\n", exp);
	return exp;
}