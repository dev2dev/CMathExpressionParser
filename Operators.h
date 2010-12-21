#define ALL_OPERATORS(def)	\
	/*		Name		Token	Associativity	Priority	Arguments	*/ \
	def(	Plus,		@"+",	Left,			6,			2			) \
	def(	Minus,		@"-",	Left,			6,			2			) \
	def(	Neg,		nil,	Left,			8,			1			) \
	def(	Times,		@"*",	Left,			7,			2			) \
	def(	Div,		@"/",	Left,			7,			2			) \
	def(	Modulo,		@"%",	Left,			7,			2			) \
	def(	Equal,		@"==",	Left,			4,			2			) \
	def(	Assign,		@"=",	Right,			2,			2			) \
	def(	LBrace,		@"(",	None,			0,			0			) \
	def(	RBrace,		@")",	None,			0,			0			) \
	def(	Semicolon,	@";",	None,			0,			0			) \
	def(	Comma,		@",",	Left,			1,			0			) \
	def(	Power,		@"^",	Right,			9,			2			) \
	def(	LE,			@"<=",	Left,			5,			2			) \
	def(	LT,			@"<",	Left,			5,			2			) \
	def(	GE,			@">=",	Left,			5,			2			) \
	def(	GT,			@">",	Left,			5,			2			) \
	def(	NEqual,		@"!=",	Left,			4,			2			) \
	def(	Factorial,	@"!",	Right,			8,			1			) \
	def(	And,		@"&&",	Left,			3,			2			) \
	def(	Or,			@"||",	Left,			3,			2			)


typedef enum CPOperator CPOperator;

typedef enum CPOperatorAssoc {
	CPOperatorAssocNone = 0,
	CPOperatorAssocLeft,
	CPOperatorAssocRight
} CPOperatorAssoc;


@interface Operators : NSObject

+ (CPOperatorAssoc) associativity: (CPOperator) op;
+ (int)	priority: (CPOperator) op;
+ (unsigned) argumentCount: (CPOperator) op;
+ (CPOperator) scan: (NSScanner *) scanner;
+ (NSString *) stringForOperator: (CPOperator) op;

@end


/*****
 * Ignore everything below this line
 ************************************/

#define	ASSOC( name )	CPOperatorAssoc ## name
#define OPERATOR( name ) CPOperator ## name 

#define DEF_ENUM( a, b, c, d, e )	OPERATOR(a),

enum CPOperator {
	OPERATOR( Null ) = 0,
	ALL_OPERATORS( DEF_ENUM )
	CPOperatorCount
};

#undef DEF_ENUM

#if !defined( _COMPILE_OPERATORS )
#	undef ALL_OPERATORS
#	undef OPERATOR
#	undef ASSOC
#endif
