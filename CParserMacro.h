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

#define CParserMacroMaxArguments 32

@interface CParserMacro : NSObject {
	
	NSString * macroExpression;
	NSArray * macroPostfixExpression;
	
	int maxArguments;
	int minArguments;

}

+ (CParserMacro *) macro;
+ (CParserMacro *) macroWithExpression:(NSString *)expression;

- (id) initWithExpression:(NSString *)expression;

- (void) setExpression:(NSString *)expression;
- (NSString *) expression;
- (void) setPostfixExpression:(NSArray *)expression;
- (NSArray *) postfixExpression;

- (void) setMinArguments:(int)args;
- (int) maxArguments;
- (int) minArguments;

- (void) updatePostfixExpression;
- (double) evaluateWithArguments:(NSArray *)arguments;

@end
