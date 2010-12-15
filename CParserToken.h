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

typedef enum {
	CParserTokenNull = 0,
	CParserTokenNumber,
	CParserTokenOperator,
	CParserTokenFunction,
	CParserTokenVariable,
	CParserTokenMacro,
	CParserTokenMatrix,
} CParserTokenType;

@interface CParserToken : NSObject {
	
	CParserTokenType tokenType;
	
	double numberValue;
	NSString * name;
	
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

@property (readwrite, assign, nonatomic) double numberValue;
@property (readwrite, copy,   nonatomic) NSString *operatorValue;
@property (readwrite, copy,   nonatomic) NSString *functionValue;
@property (readwrite, copy,   nonatomic) NSString *variableValue;
@property (readwrite, copy,   nonatomic) NSString *macroValue;

@property (readwrite, assign, nonatomic) CParserTokenType type;

@end
