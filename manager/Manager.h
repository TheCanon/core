#include "NSObject+Object.h"

@class AppDirector;

@interface Manager : ManagedPropertiesObject

@property (nonatomic, assign) AppDirector* director;

- (void)load;

- (void)reload;

- (void)update;

- (void)endOfFrame;

- (void)injectConfig:(NSString*)configJsonName;

@end
