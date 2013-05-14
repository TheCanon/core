#import "Manager.h"
#import "AppDirector.h"
#import "ResourceManager.h"

@implementation Manager

- (void)load {}

- (void)unload {}

- (void)update {}

- (void)injectConfig:(NSString*)configJsonName
{
    @autoreleasepool
    {
        [self setValuesWithSerializedRepresentation:[ResourceManager configurationForResource:configJsonName]];
    }
}

@end
