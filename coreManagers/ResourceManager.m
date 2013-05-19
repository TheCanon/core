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
    NSString* path = [[NSBundle mainBundle] pathForResource:Format(@"bundle/%@", resourceName)
                                                     ofType:nil];

    CheckTrue([[NSFileManager defaultManager] fileExistsAtPath:path])
        
    return path;
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
	
    NSError* error = [NSError object];
	NSMutableDictionary* configurationDictionary = [configurationJSONData mutableObjectFromJSONDataWithParseOptions:JKParseOptionStrict
                                                                                                              error:&error];
	CheckNotNull(configurationDictionary);
	
	return configurationDictionary;
}



@end
