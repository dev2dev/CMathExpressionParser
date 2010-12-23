//
//  NSScanner+Lookahead.h
//  CMathExpressionParser
//
//  Created by Sven Weidauer on 23.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSScanner (Lookahead)

- (BOOL) lookaheadString: (NSString *) string intoString: (out NSString **) outString;

@end
