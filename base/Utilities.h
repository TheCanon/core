
#define SystemVersionGreaterThanOrEqualTo(version)                                                          \
    ([[[UIDevice currentDevice] systemVersion] compare:version                                              \
                                               options:NSNumericSearch] != NSOrderedAscending)

#define Format(format...) [NSString stringWithFormat:format]
#define Float(x) [NSNumber numberWithFloat:x]
#define Bool(x) [NSNumber numberWithBool:x]
#define Integer(x) [NSNumber numberWithInt:x]

typedef void (^VoidBlock)();

@interface Util : NSObject

+ (NSArray*)allClassesWithSuperClass:(Class)superClass;

+ (NSString*)formatDate:(NSDate*)date;

@end