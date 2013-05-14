#import "ResourceManager.h"
#import "Asserts.h"
#import "JSONKit.h"
#import "NSObject+Serialization.h"
#import "Utilities.h"

@interface ResourceManager ()
{
	
}

@end


@implementation ResourceManager

+ (NSData*)dataForResource:(NSString*)resourceName
{
	return [NSData dataWithContentsOfFile:[self formatPathForResourceWithName:resourceName]];
}

+ (NSString*)formatPathForResourceWithName:(NSString*)resourceName
{
    NSString* path = nil;

    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:Format(@"bundle/%@", resourceName)
                                                           ofType:nil];
    
    if (bundlePath != nil && [[NSFileManager defaultManager] fileExistsAtPath:bundlePath])
        path = bundlePath;
    
    if (path != nil)
        return path;
    
    NSString* offlineMainBundlePath = [[NSBundle mainBundle] pathForResource:resourceName
                                                                      ofType:nil];
    
    if ([NSFileManager.defaultManager fileExistsAtPath:offlineMainBundlePath])
        path = offlineMainBundlePath;
    
    if (path != nil)
        return path;
    
    return nil;
}

+ (id)configurationObjectForResource:(NSString*)resourceName
                          usingClass:(Class)configurationClass
{
    NSDictionary* dictionary = [self configurationForResource:resourceName];
    
    CheckNotNull(dictionary);
    
    if (dictionary == nil)
        return nil;
    
	return [configurationClass objectFromSerializedRepresentation:dictionary];
}

+ (id)configurationForResource:(NSString*)resourceName
{
	CheckNotNull(resourceName);
	
	// Load Configuration File
	NSData* configurationJSONData = [self dataForResource:resourceName];
	CheckNotNull(configurationJSONData);
	
	NSMutableDictionary* configurationDictionary = [configurationJSONData mutableObjectFromJSONData];
	CheckNotNull(configurationDictionary);
	
	return configurationDictionary;
}



@end
