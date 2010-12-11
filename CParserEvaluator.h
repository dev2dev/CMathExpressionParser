//
//  CParserEvaluator.h
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

#import "CParserToken.h"
#import "CParserStack.h"
#import "CParserVariable.h"
#import "CParserFunction.h"
#import "CParserMacro.h"


@interface CParserEvaluator : NSObject {

	NSMutableDictionary * variableDictionary;
	NSMutableDictionary * functionDictionary;
	NSMutableDictionary * macroDictionary;
	
}

+ (CParserEvaluator *) evaluator;

- (double) evaluatePostfixArray:(NSArray *)array;

- (void) setVariableDictionary:(NSMutableDictionary *)dict;
- (NSMutableDictionary *) variableDictionary;
- (void) setFunctionDictionary:(NSMutableDictionary *)dict;
- (NSMutableDictionary *) functionDictionary;
- (void) setMacroDictionary:(NSMutableDictionary *)dict;
- (NSMutableDictionary *) macroDictionary;

- (void) setVariable:(CParserVariable *)variable forKey:(NSString *)key;
- (CParserVariable *) variableForKey:(NSString *)key;

- (void) setFunction:(CParserFunction *)func forKey:(NSString *)key;
- (CParserFunction *) functionForKey:(NSString *)key;

- (void) setMacro:(CParserMacro *)macro forKey:(NSString *)key;
- (CParserMacro *) macroForKey:(NSString *)key;

@end
