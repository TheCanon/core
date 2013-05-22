#import "Manager.h"
#import "AppDirector.h"
#import "ResourceManager.h"

@implementation Manager

- (void)load {}

- (void)reload {}

- (void)injectConfig:(NSString*)configJsonName
{
    @autoreleasepool
    {
        [self setValuesWithSerializedRepresentation:[ResourceManager configurationForResource:configJsonName]];
    }
}

@end
