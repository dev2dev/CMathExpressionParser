//
//  CParserGlobal.m
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 Johannes Wolf. All rights reserved.
//

#import <Cocoa/Cocoa.h>


int operatorPrecedence( unichar s )
{
	if (s=='(')
		return 0;
	if (s==')')
		return 0;
	if (s=='=')
		return 0;
	if (s=='+' || s=='-')
		return 1;
	if (s=='*' || s=='/' || s=='%')
		return 2;
	if (s=='^')
		return 3;
	if (s=='!') 
		return 4;
	return 0;
}

bool operatorAssociativity( unichar s )
{
	if (s=='*' || s=='/' || s=='%' || s=='+' || s=='-')//left to right ->
		return YES;
	if (s=='=' || s=='!')//right to left <-
		return NO;
	return NO;
}

int operatorArgumentCount( unichar s )
{	
	if (s=='*' || s=='/' || s=='%' || s=='+' || s=='-' || s=='=')
		return 2;
	if (s=='!')
		return 1;
	return s - 'A';
}
