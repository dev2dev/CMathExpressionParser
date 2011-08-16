//
//  CParserMacro.h
//  CMathParser
//
//  Created by Johannes Wolf on 20.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CParserFunction.h"

#define CParserMacroMaxArguments 32

@class CPEvaluator;
@interface CParserMacroFunction : CParserFunction {
	
	NSString * macroExpression;
	NSArray * macroPostfixExpression;
	CPEvaluator *macroEvaluator;
	
}

+ (CParserMacroFunction *) macro;
+ (CParserMacroFunction *) macroWithExpression:(NSString *)expression;

- (id) initWithExpression:(NSString *)expression;

@property (readwrite, copy, nonatomic) NSString *expression;
@property (readwrite, copy, nonatomic) NSArray *postfixExpression;
@property (assign) CPEvaluator *macroEvaluator;

@end
