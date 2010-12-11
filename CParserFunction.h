//
//  CParserFunction.h
//  CMathParser
//
//  Created by Johannes Wolf on 20.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE) || (TARGET_IPHONE)
#import <Foundation/Foundation.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#include "CParserGlobal.h"

@interface CParserFunction : NSObject {

	function_0 functionPtr0;
	function_1 functionPtr1;
	function_2 functionPtr2;
	function_3 functionPtr3;
	function_4 functionPtr4;
	function_5 functionPtr5;
	function_6 functionPtr6;
	function_7 functionPtr7;
	function_8 functionPtr8;
	function_9 functionPtr9;
	
	int minArguments;
	int maxArguments;
	
}

+ (CParserFunction *) function;
+ (CParserFunction *) functionWithMinArguments:(int)args;

- (id) initWithMinArguments:(int)args;

- (void) setMinArguments:(int)args;
- (int) minArguments;
- (int) maxArguments;

- (void) setFunction0:(function_0)func;
- (void) setFunction1:(function_1)func;
- (void) setFunction2:(function_2)func;
- (void) setFunction3:(function_3)func;
- (void) setFunction4:(function_4)func;
- (void) setFunction5:(function_5)func;
- (void) setFunction6:(function_6)func;
- (void) setFunction7:(function_7)func;
- (void) setFunction8:(function_8)func;
- (void) setFunction9:(function_9)func;

- (double) evaluateWithArguments:(NSArray *)arguments;

@end
