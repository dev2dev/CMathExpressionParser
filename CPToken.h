//
//  CPToken.h
//  CMathExpressionParser
//
//  Created by Johannes Wolf on 13.12.2010.
//  Copyright 2010 beanage. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum _CPTokenType {
	CPTokenNull,
	CPTokenNumber,
	CPTokenOperator,
	CPTokenFunction,
	CPTokenVariable,
	CPTokenArgStop
} CPTokenType;

typedef enum _CPOperator {
	CPOperatorNull,		//
	CPOperatorPlus,		// +
	CPOperatorMinus,	// -
	CPOperatorNeg,		// (-)
	CPOperatorTimes,	// *
	CPOperatorDiv,		// /
	CPOperatorModulo,	// %
	CPOperatorAssign,	// =
	CPOperatorLBrace,	// (
	CPOperatorRBrace,	// )
	CPOperatorSemicolon,// ;
	CPOperatorComma,	// ,
	CPOperatorPower,	// ^
	CPOperatorLT,		// <
	CPOperatorLE,		// <=
	CPOperatorGT,		// >
	CPOperatorGE,		// =>
	CPOperatorNEqual,	// !=
	CPOperatorEqual,	// ==
	CPOperatorFactorial,// !
	CPOperatorAND,		// &&
	CPOperatorOR		// ||
} CPOperator;

typedef double CPNumber;

@interface CPToken : NSObject {

	CPTokenType type;
	
	CPNumber numberValue;
	CPOperator operatorValue;
	NSString *stringValue;
	
}

+ (CPToken *) token;
+ (CPToken *) tokenWithNumber:(CPNumber)value;
+ (CPToken *) tokenWithOperator:(CPOperator)value;
+ (CPToken *) tokenWithVariable:(NSString *)value;
+ (CPToken *) tokenWithFunction:(NSString *)value;
+ (CPToken *) tokenWithType:(CPTokenType)value;

- (id) initWithNumber:(CPNumber)value;
- (id) initWithOperator:(CPOperator)value;

- (void) setNumberValue:(CPNumber)value;
- (CPNumber) numberValue;
- (void) setOperatorValue:(CPOperator)value;
- (CPOperator) operatorValue;
- (void) setStringValue:(NSString *)value;
- (NSString *) stringValue;

- (void) setType:(CPTokenType)value;
- (CPTokenType) type;

@end
