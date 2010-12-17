#define _COMPILE_OPERATORS
#import "Operators.h"

@implementation Operators

typedef struct OperatorInfo  {
	CPOperatorAssoc associativity;
	NSString *token;
	int priority;
	unsigned args;
} OperatorInfo;


#define DEF_STRUCT( _name, _token, _assoc, _priority, _args )	\
	[OPERATOR(_name)] = {										\
		.token = _token,										\
		.associativity = ASSOC( _assoc ),						\
		.priority = _priority,									\
		.args = _args											\
	},


static const OperatorInfo allOperators[CPOperatorCount] = {
	ALL_OPERATORS( DEF_STRUCT )
};

#undef DEF_STRUCT

+ (CPOperatorAssoc) associativity: (CPOperator) op;
{
	NSParameterAssert( CPOperatorNull < op && op < CPOperatorCount );
	return allOperators[op].associativity;
}

+ (int)	priority: (CPOperator) op;
{
	NSParameterAssert( CPOperatorNull < op && op < CPOperatorCount );
	return allOperators[op].priority;
}

+ (unsigned) argumentCount: (CPOperator) op;
{
	NSParameterAssert( CPOperatorNull < op && op < CPOperatorCount );
	return allOperators[op].args;
}

+ (CPOperator) scan: (NSScanner *) scanner;
{
	for (unsigned i = 1; i < CPOperatorCount; i++) {
		NSString *token = allOperators[i].token;
		if (nil != token && [scanner scanString: token intoString: NULL]) {
			return i;
		}
	}
	return CPOperatorNull;
}

+ (NSString *) stringForOperator: (CPOperator) op;
{
	NSParameterAssert( CPOperatorNull < op && op < CPOperatorCount );
	return allOperators[op].token;
}

@end
