//
//  NSArray+reverse.h
//  CMathParser
//
//  Created by Johannes Wolf on 27.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSArray (reverse)

- (NSArray *) reversedArray;

@end


@interface NSMutableArray (reverse)

- (void) reverse;

@end
