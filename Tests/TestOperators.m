//
//  TestOperators.m
//  CMathExpressionParser
//
//  Created by Sven Weidauer on 17.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <SenTestingKit/SenTestingKit.h>

#import "Operators.h"

@interface TestOperators : SenTestCase 
@end


@implementation TestOperators

- (void) string: (NSString *) string shouldReturn: (CPOperator) expectedOp;
{
	NSAutoreleasePool *arp = [[NSAutoreleasePool alloc] init];
	NSScanner *scanner = [NSScanner scannerWithString: string];
	CPOperator scannedOp = [Operators scan: scanner];
	STAssertTrue( scannedOp == expectedOp, @"Wrong result for '%@' (got %d, expected %d)", string, scannedOp, expectedOp );
	[arp release];
}

#define Check( a, b ) [self string: a shouldReturn: b]

- (void) testOperators;
{
	Check( @"+", CPOperatorPlus );
	Check( @"-", CPOperatorMinus );
	Check( @"*", CPOperatorTimes );
	Check( @"/", CPOperatorDiv );
	Check( @"%", CPOperatorModulo );
	Check( @"==", CPOperatorEqual );
	Check( @"=", CPOperatorAssign );
	Check( @"(", CPOperatorLBrace );
	Check( @")", CPOperatorRBrace );
	Check( @";", CPOperatorSemicolon );
	Check( @",", CPOperatorComma );
	Check( @"^", CPOperatorPower );
	Check( @"<=", CPOperatorLE );
	Check( @"<", CPOperatorLT );
	Check( @">=", CPOperatorGE );
	Check( @">", CPOperatorGT );
	Check( @"!=", CPOperatorNEqual );
	Check( @"!", CPOperatorFactorial );
	Check( @"&&", CPOperatorAnd );
	Check( @"||", CPOperatorOr );
}

@end
