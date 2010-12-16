//
//  NSArray+reverse.m
//  CMathParser
//
//  Created by Johannes Wolf on 27.09.10.
<<<<<<< HEAD
//  Copyright 2010 beanage. All rights reserved.
//

#import "NSArray+reverse.h"


=======
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSArray+reverse.h"
>>>>>>> refs/remotes/old/master
@implementation NSArray (reverse)

- (NSArray *) reversedArray;
{
	return [[self reverseObjectEnumerator] allObjects];
}

@end


@implementation NSMutableArray (reverse)

- (void) reverse {
	[self setArray: [self reversedArray]];
}

@end
