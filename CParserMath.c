#include <math.h>

int factorial(int value);			//	!
double radToDeg(double rad);	//	radToDeg()
double dadToRad(double deg);	//	degToRad()

//implimentation

int factorial(int value)
{
	if (value <= 0)
		return 1;
	return(factorial(value - 1) * value);
}

double radToDeg(double rad)
{
	return (rad * (180.0/M_PI));
}

double degToRad(double deg)
{
	return (deg * (M_PI/180.0));
}