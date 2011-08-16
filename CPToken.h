//
//  CPToken.h
//  CMathExpressionParser
//
//  Created by Johannes Wolf on 13.12.2010.
//  Copyright 2010 beanage. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Operators.h"

typedef enum _CPTokenType {
	CPTokenNull,
	CPTokenNumber,
	CPTokenOperator,
	CPTokenFunction,
	CPTokenVariable,
	CPTokenArgStop,
	CPTokenBlockStop,
	CPTokenBlockStart
} CPTokenType;

typedef double CPNumber;

@interface CPToken : NSObject {

	CPTokenType type;
	
	CPNumber numberValue;
	CPOperator operatorValue;
	NSString *stringValue;
	BOOL useSuper;
}

+ (CPToken *) token;
+ (CPToken *) tokenWithNumber:(CPNumber)value;
+ (CPToken *) tokenWithOperator:(CPOperator)value;
+ (CPToken *) tokenWithVariable:(NSString *)value;
+ (CPToken *) tokenWithFunction:(NSString *)value;
+ (CPToken *) tokenWithType:(CPTokenType)value;

- (id) initWithNumber:(CPNumber)value;
- (id) initWithOperator:(CPOperator)value;
- (id) initWithString:(NSString *)value;

- (void) setNumberValue:(CPNumber)value;
- (CPNumber) numberValue;
- (void) setOperatorValue:(CPOperator)value;
- (CPOperator) operatorValue;
- (void) setStringValue:(NSString *)value;
- (NSString *) stringValue;

- (void) setType:(CPTokenType)value;
- (CPTokenType) type;

@end
