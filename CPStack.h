//
//  CPStack.h
//  CMathExpressionParser
//
//  Created by Johannes Wolf on 13.12.2010.
//  Copyright 2010 beanage. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class CPToken;

@interface CPStack : NSObject {

	NSMutableArray *stack;
	NSInteger position;
	
}

+ (CPStack *) stack;

- (void) push:(CPToken *)token;
- (CPToken *) pop;

- (CPToken *) lastToken;
- (CPToken *) tokenAtIndex:(NSInteger)index;

- (NSInteger) count;
- (NSInteger) position;

@end
