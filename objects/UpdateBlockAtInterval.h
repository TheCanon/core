#import "NSObject+Object.h"
#import "Utilities.h"

@interface UpdateBlockAtInterval : ManagedPropertiesObject

+ (UpdateBlockAtInterval*)objectWithUpdateBlock:(VoidBlock)updateBlock
                               updatesPerSecond:(int)updatesPerSecond
                               currentTimeInSec:(NSTimeInterval)currentTimeInMSec;

- (void)updateAtCurrentTimeInSec:(NSTimeInterval)currentTimeInSec;

@end
