//
//  CPEvaluator.h
//  CMathExpressionParser
//
//  Created by Johannes Wolf on 14.12.2010.
//  Copyright 2010 beanage. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CParserFunction;

@interface CPEvaluator : NSObject {
	
	NSMutableDictionary *variables;
	NSMutableDictionary *tempVariables;
	NSMutableDictionary *functions;

}
@property (assign) NSUInteger recursionDepth;

+ (CPEvaluator *) evaluator;

- (void) setVariables:(NSMutableDictionary *)dict;
- (NSDictionary *) variables;
- (void) setTempVariables:(NSMutableDictionary *)dict;
- (NSDictionary *) tempVariables;
- (void) setFunctions:(NSMutableDictionary *)dict;
- (NSDictionary *) functions;

- (double) evaluatePostfixExpressionArray:(NSArray *)array;

//var + func

- (void) setValue:(double)value forVariable:(NSString *)key;
- (void) setTempValue:(double)value forVariable:(NSString *)key;
- (void)clearTempVariables;
- (double) valueForVariable:(NSString *)key;
- (void) setFunction:(CParserFunction *)func forKey:(NSString *)key;
- (CParserFunction *) functionForKey:(NSString *)key;

@end