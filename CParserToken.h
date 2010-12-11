//
//  CParserToken.h
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE) || (TARGET_IPHONE)
#import <Foundation/Foundation.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#define CParserTokenNull		0
#define CParserTokenNumber		1
#define CParserTokenOperator	2
#define CParserTokenFunction	3
#define CParserTokenVariable	4
#define CParserTokenMacro		5
#define CParserTokenMatrix		6 //not implimented yet!

@interface CParserToken : NSObject {
	
	int tokenType;
	
	double numberValue;
	NSString * operatorValue;
	NSString * functionValue;
	NSString * variableValue;
	NSString * macroValue;
	
}

+ (CParserToken *) token;
+ (CParserToken *) tokenWithNumber:(double)value;
+ (CParserToken *) tokenWithOperator:(NSString *)value;
+ (CParserToken *) tokenWithFunction:(NSString *)value;
+ (CParserToken *) tokenWithVariable:(NSString *)value;
+ (CParserToken *) tokenWithMacro:(NSString *)value;

- (id) initWithNumber:(double)value;
- (id) initWithOperator:(NSString *)value;
- (id) initWithFunction:(NSString *)value;
- (id) initWithVariable:(NSString *)value;
- (id) initWithMacro:(NSString *)value;

- (double) numberValue;
- (NSString *) operatorValue;
- (NSString *) functionValue;
- (NSString *) variableValue;
- (NSString *) macroValue;

- (void) setNumberValue:(double)value;
- (void) setOperatorvalue:(NSString *)value;
- (void) setFunctionValue:(NSString *)value;
- (void) setVariableValue:(NSString *)value;
- (void) setMacroValue:(NSString *)value;

- (int) type;
- (void) setType:(int)value;

@end
