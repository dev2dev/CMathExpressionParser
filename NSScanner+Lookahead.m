//
//  NSScanner+Lookahead.m
//  CMathExpressionParser
//
//  Created by Sven Weidauer on 23.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSScanner+Lookahead.h"


@implementation NSScanner (Lookahead)

- (BOOL) lookaheadString: (NSString *) string intoString: (out NSString **) outString;
{
	NSUInteger location = [self scanLocation];
	@try {
		return [self scanString: string intoString: outString];
	} 
	@finally {
		[self setScanLocation: location];
	}
}

@end
