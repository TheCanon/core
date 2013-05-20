#import "NSObject+Object.h"
#import <objc/runtime.h>
#import "Asserts.h"


void ManagedPropertiesObject__releaseManagedPropertiesRecursive(id self, Class currentClass);

@implementation ManagedPropertiesObject

- (void)dealloc
{
	ManagedPropertiesObject__releaseManagedPropertiesRecursive(self, [self class]);
	
	[super dealloc];
}

@end

static void ManagedPropertiesObject__isPropertyForObjectValue_isRetained(objc_property_t property,
                                                                         BOOL* isObjectType,
                                                                         BOOL* isRetained)
{
	*isObjectType = NO;
	*isRetained = NO;
	
	const char * attrs = property_getAttributes(property);
	
	if (attrs == NULL)
		return;
	
	*isRetained = strstr(attrs, ",&,") != NULL ||
	strstr(attrs, ",C,") != NULL;
	
	const char * e = strchr(attrs, ',');
	
	if (e == NULL)
		return;
	
	if (attrs[0] == 'T' &&
		attrs[1] == '@')
	{
		*isObjectType = YES;
	}
}

static void ManagedPropertiesObject__releaseManagedProperties(id object, Class self)
{
	// If this assert hits, you are using the wrong class in your class to releaseRetainedPropertiesOfObject
    CheckTrue([object isKindOfClass:self]);
    
	unsigned int propertyListCount = 0;
	objc_property_t* propertyList = class_copyPropertyList(self, &propertyListCount);
	
	for (unsigned int propertyListIndex = 0; propertyListIndex < propertyListCount; propertyListIndex++)
	{
		objc_property_t property = propertyList[propertyListIndex];
		
		BOOL isRetained = NO;
		BOOL isOfObjectType = NO;
		
		ManagedPropertiesObject__isPropertyForObjectValue_isRetained(property,
																	 &isOfObjectType,
																	 &isRetained);
		
		if (isOfObjectType && isRetained)
		{
			NSString* propertyName = [NSString stringWithUTF8String:property_getName(property)];
            
            CheckTrue(![propertyName hasPrefix:@"get"]);
            
            //NSLog(@"Releasing property with name: %@ on object: %@", propertyName, object);
            
            [[object valueForKey:propertyName] release];
		}
	}
	
	free(propertyList);
}

void ManagedPropertiesObject__releaseManagedPropertiesRecursive(id self, Class currentClass)
{
    //NSLog(@"<<< ManagedPropertiesObject__releaseManagedPropertiesRecursive: %@>>>", self);
	ManagedPropertiesObject__releaseManagedProperties(self, currentClass);
    
	Class nextClass = [currentClass superclass];
	
	if (nextClass != nil &&
		nextClass != [NSObject class])
	{
		ManagedPropertiesObject__releaseManagedPropertiesRecursive(self, nextClass);
	}
}

@implementation NSObject (Object)

+ (id)object
{
    return [[[self alloc] init] autorelease];
}

+ (void)releaseRetainedPropertiesOfObject:(id)object
{
    //NSLog(@"<<< ReleaseRetainedPropertiesOfObject: %@>>>", object);

    // Why are you releasing stuff yourself in a subclass of ManagedPropertiesObject?
    CheckTrue(![self isSubclassOfClass:ManagedPropertiesObject.class]);

    ManagedPropertiesObject__releaseManagedProperties(object, self);
}

@end
