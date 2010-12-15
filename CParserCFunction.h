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

#import "CParserFunction.h"

@interface CParserCFunction : CParserFunction {

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
	
	
}

+ (CParserCFunction *) function;
+ (CParserCFunction *) functionWithMinArguments:(int)args;

- (id) initWithMinArguments:(int)args;

@property (readwrite, assign, nonatomic) function_0 function0;
@property (readwrite, assign, nonatomic) function_1 function1;
@property (readwrite, assign, nonatomic) function_2 function2;
@property (readwrite, assign, nonatomic) function_3 function3;
@property (readwrite, assign, nonatomic) function_4 function4;
@property (readwrite, assign, nonatomic) function_5 function5;
@property (readwrite, assign, nonatomic) function_6 function6;
@property (readwrite, assign, nonatomic) function_7 function7;
@property (readwrite, assign, nonatomic) function_8 function8;
@property (readwrite, assign, nonatomic) function_9 function9;



@end
