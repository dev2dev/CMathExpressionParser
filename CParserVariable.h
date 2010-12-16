//
//  CParserVariable.h
//  CMathParser
//
//  Created by Johannes Wolf on 20.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CParserVariable : NSObject {
	
	double value;

}

+ (CParserVariable *) variable;
+ (CParserVariable *) variableWithValue:(double)val;

- (id) initWithValue:(double)val;

- (void) setValue:(double)val;
- (double) value;

@end
