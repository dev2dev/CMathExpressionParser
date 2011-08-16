#ifndef _CPARSERMATH_H_INCLUDED_
#define _CPARSERMATH_H_INCLUDED_

#include <math.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif
	
	int factorial(int value);		//	!
	double radToDeg(double rad);	//	radToDeg()
	double degToRad(double deg);	//	degToRad()
	
	double IF(double exp);
	double IFNOT(double exp);
	
	double debugLog(double exp);	//log the input number to output and return it

#ifdef __cplusplus
}
#endif
		
	
#endif
