//
//  CParserMacro.h
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

#import "CParserFunction.h"

#define CParserMacroMaxArguments 32

@interface CParserMacroFunction : CParserFunction {
	
	NSString * macroExpression;
	NSArray * macroPostfixExpression;
	
}

+ (CParserMacroFunction *) macro;
+ (CParserMacroFunction *) macroWithExpression:(NSString *)expression;

- (id) initWithExpression:(NSString *)expression;

@property (readwrite, copy, nonatomic) NSString *expression;
@property (readwrite, copy, nonatomic) NSArray *postfixExpression;

@end
