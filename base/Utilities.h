
#define SystemVersionGreaterThanOrEqualTo(version)                                                          \
    ([[[UIDevice currentDevice] systemVersion] compare:version                                              \
                                               options:NSNumericSearch] != NSOrderedAscending)

#define Format(format...) [NSString stringWithFormat:format]
#define Float(x) [NSNumber numberWithFloat:x]
#define Bool(x) [NSNumber numberWithBool:x]
#define Integer(x) [NSNumber numberWithInt:x]
#define Dictionary(args...) [NSMutableDictionary dictionaryWithObjectsAndKeys:args, nil]

typedef void (^VoidBlock)();

extern Class kArrayClass;
extern Class kMutableArrayClass;
extern Class kDictionaryClass;
extern Class kMutableDictionaryClass;
extern Class kStringClass;
extern Class kMutableStringClass;
extern Class kNumberClass;
extern Class kObjectClass;
extern Class kEntitySpecClass;
extern Class kManagerClass;
extern Class kManagedViewClass;
extern Class kManagedPropertiesObjectClass;
extern Class kComponentClass;
extern Class kBasicSerializedClassesPlaceholderClass;

@interface Util : NSObject

+ (void)initializeCachedClasses;

+ (NSArray*)allClassesWithSuperClass:(Class)superClass;

+ (NSString*)formatDate:(NSDate*)date;

+ (void)addNewEntriesOfSourceDictionary:(NSDictionary*)source
                     toTargetDictionary:(NSMutableDictionary*)target;

+ (void)removeDefaultValuesFromDictionary:(NSMutableDictionary*)dictionary;
@end
