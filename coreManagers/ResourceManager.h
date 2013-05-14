#import "Manager.h"

@interface ResourceManager : Manager

+ (NSString*)formatPathForResourceWithName:(NSString*)resourceName;

+ (id)configurationObjectForResource:(NSString*)resourceName
                          usingClass:(Class)configurationClass;

+ (id)configurationForResource:(NSString*)resourceName;



@end
