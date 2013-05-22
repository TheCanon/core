#import "NSObject+Object.h"
#import "Utilities.h"

@class AppDirector;

@interface Manager : ManagedPropertiesObject

@property (nonatomic, assign) AppDirector* director;

- (void)load;

- (void)reload;

- (void)injectConfig:(NSString*)configJsonName;

@end
