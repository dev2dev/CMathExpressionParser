//
//  CParserStack.h
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 Johannes Wolf. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE) || (TARGET_IPHONE)
#import <Foundation/Foundation.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import "CParserToken.h"

@interface CParserStack : NSObject {
	
	NSMutableArray * stackArray;
	int position;
	
}

+ (CParserStack *) stack;

- (void) push:(CParserToken *)token;
- (CParserToken *) pop;

- (CParserToken *) tokenAtIndex:(int)index;
- (CParserToken *) lastToken;

- (int) count;
- (int) position;

@end
