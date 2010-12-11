#include <math.h>

#define PI 3.141592653589793238462643383279
#define E  2.718281828459045235360287471352

int fakulty(int value);			//	!
double radToDeg(double rad);	//	radToDeg()
double dadToRad(double deg);	//	degToRad()

//implimentation

int fakulty(int value)
{
	if (value <= 0)
		return 1;
	return(fakulty(value - 1) * value);
}

double radToDeg(double rad)
{
	return (rad * (180.0/PI));
}

double degToRad(double deg)
{
	return (deg * (PI/180.0));
}