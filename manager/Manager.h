#include "NSObject+Object.h"

@class AppDirector;

@interface Manager : ManagedPropertiesObject

@property (nonatomic, assign) AppDirector* director;

- (void)load;

- (void)unload;

- (void)update;

- (void)injectConfig:(NSString*)configJsonName;

@end
