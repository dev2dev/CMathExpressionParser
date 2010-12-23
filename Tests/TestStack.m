//
//  TestStack.m
//  CMathExpressionParser
//
//  Created by Sven Weidauer on 23.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "CPStack.h"
#import "CPToken.h"

@interface TestStack : SenTestCase
@end


@implementation TestStack

- (void) testEmpty;
{
	CPStack *stack = [CPStack stack];
	
	STAssertTrue( [stack isEmpty], @"Should be empty" );
	STAssertTrue( [stack count] == 0, @"Should be empty" );
	STAssertTrue( [stack position] == 0, @"Should be empty" );
	
	STAssertNil( [stack pop], @"Should be empty" );
	STAssertNil( [stack lastToken], @"Should be empty" );
}

- (void) testPushPop;
{
	CPStack *stack = [CPStack stack];
	CPToken *token = [CPToken tokenWithOperator: CPOperatorPlus];
	[stack push: token];
	
	STAssertTrue( [stack count] == 1, @"Should have one object" );
	STAssertFalse( [stack isEmpty], @"Should not be empty" );
	STAssertEqualObjects( [stack lastToken], token, @"Last token should be pushed token" );
	STAssertEqualObjects( [stack pop], token, @"Popped token should be pushed token" );
	STAssertTrue( [stack isEmpty], @"Stack should be empty after pop" );
}

- (void) testPopAll;
{
	CPStack *stack = [CPStack stack];
	CPToken *token1 = [CPToken tokenWithOperator: CPOperatorPlus];
	CPToken *token2 = [CPToken tokenWithVariable: @"X"];
	
	[stack push: token1];
	[stack push: token2];
	
	NSArray *reversedTokens = [NSArray arrayWithObjects: token2, token1, nil];
	
	STAssertEqualObjects( [stack popAll], reversedTokens, @"popAll should return both tokens in reversed order" );
	STAssertTrue( [stack isEmpty], @"Stack should be empty after popAll" );
}

- (void) testPopToToken;
{
	CPStack *stack = [CPStack stack];
	CPToken *token0 = [CPToken tokenWithNumber: 42.0]; 
	CPToken *token1 = [CPToken tokenWithOperator: CPOperatorPlus];
	CPToken *token2 = [CPToken tokenWithVariable: @"X"];
	
	[stack push: token0];
	[stack push: token1];
	[stack push: token2];
	[stack push: token0];
	
	NSArray *expectedTokens = [NSArray arrayWithObjects: token0, token2, nil];
	STAssertEqualObjects( [stack popUpToToken: token1], expectedTokens, @"popUpToToken: returned wrong tokens" );
	STAssertFalse( [stack isEmpty], @"Should not be empty" );
	STAssertTrue( [stack count] == 1, @"One token should remind" );
	STAssertEqualObjects( [stack pop], token0, @"Wrong token reminded" );
}

@end
