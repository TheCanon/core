#import "Utilities.h"
#import <objc/runtime.h>
#import "EntitySpec.h"
#import "EntityComponent.h"
#import "Manager.h"

#ifndef EDITOR
#import "ManagedView.h"
#endif

NSDateFormatter* dateFormatter = nil;

Class kArrayClass = nil;
Class kMutableArrayClass = nil;
Class kDictionaryClass = nil;
Class kMutableDictionaryClass = nil;
Class kStringClass = nil;
Class kMutableStringClass = nil;
Class kNumberClass = nil;
Class kObjectClass = nil;
Class kEntitySpecClass = nil;
Class kManagerClass = nil;
Class kManagedPropertiesObjectClass = nil;
Class kEntityComponentClass = nil;
Class kBasicSerializedClassesPlaceholderClass = nil;
Class kManagedViewClass = nil;

@implementation Util

+ (void)initializeCachedClasses
{
    kArrayClass = NSArray.class;
    kMutableArrayClass = NSMutableArray.class;
    kDictionaryClass = NSDictionary.class;
    kMutableDictionaryClass = NSMutableDictionary.class;
    kStringClass = NSString.class;
    kMutableStringClass = NSMutableString.class;
    kNumberClass = NSNumber.class;
    kObjectClass = NSObject.class;
    kEntitySpecClass = EntitySpec.class;
    kManagerClass = Manager.class;
    kManagedPropertiesObjectClass = ManagedPropertiesObject.class;
    kEntityComponentClass = EntityComponent.class;
    kBasicSerializedClassesPlaceholderClass = BasicSerializedClassesPlaceholder.class;
#ifndef EDITOR
    kManagedViewClass = ManagedView.class;
#endif
}

+ (NSArray*)allClassesWithSuperClass:(Class)superClass
{
    NSMutableArray* matchingClasses = [[[NSMutableArray alloc] init] autorelease];
    
    unsigned int numClasses = objc_getClassList(NULL, 0);

    Class* classes = malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

    for (int i = 0; i < numClasses; ++i)
    {
        Class currentClass = classes[i];
        
        do
        {
            currentClass = class_getSuperclass(currentClass);
            
            if (currentClass == superClass)
            {
                [matchingClasses addObject:classes[i]];
                break;
            }
        }
        while (currentClass != nil);
    }
    free(classes);
    
    return matchingClasses;
}

+ (NSString*)formatDate:(NSDate *)date
{
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"EEEE hh:mm a 'on' MM/dd/yyyy"]; // Tuesday 11:41 PM on 05/07/2013
        [dateFormatter setDateFormat:@"MMM d, y - h:mma"]; // July, 15 2011 - 2:00pm
        
        [dateFormatter setAMSymbol:@"am"];
        [dateFormatter setPMSymbol:@"pm"];
    }

    return [dateFormatter stringFromDate:date];
}

+ (void)addNewEntryToArray:(NSMutableArray*)target
                     value:(id)value
{
    if ([value isKindOfClass:kDictionaryClass])
    {
        NSMutableDictionary* targetEntry = [NSMutableDictionary object];
        [Util addNewEntriesOfSourceDictionary:value
                           toTargetDictionary:targetEntry];
        [target addObject:targetEntry];
    }
    else if ([value isKindOfClass:kArrayClass])
    {
        NSMutableArray* targetEntry = [NSMutableArray object];
        for (id entry in value)
        {
            [Util addNewEntryToArray:targetEntry
                               value:entry];
        }
        [target addObject:targetEntry];
    }
    else
    {
        [target addObject:[[value copy] autorelease]];
    }
}

+ (void)addNewEntryToDictionary:(NSMutableDictionary*)target
                            key:(NSString*)key
                          value:(id)value
{
    if ([value isKindOfClass:kDictionaryClass])
    {
        NSMutableDictionary* targetEntry = [NSMutableDictionary object];
        [Util addNewEntriesOfSourceDictionary:value
                           toTargetDictionary:targetEntry];
        [target setObject:targetEntry
                   forKey:key];
    }
    else if ([value isKindOfClass:kArrayClass])
    {
        NSMutableArray* targetEntry = [NSMutableArray object];
        for (id entry in value)
        {
            [Util addNewEntryToArray:targetEntry
                               value:value];
        }
        [target setObject:targetEntry
                   forKey:key];
    }
    else
    {
        [target setObject:[[value copy] autorelease]
                   forKey:key];
    }
}


+ (void)addNewEntriesOfSourceDictionary:(NSDictionary*)source
                     toTargetDictionary:(NSMutableDictionary*)target;
{
    for (NSString* sourceKey in source.allKeys)
    {
        id sourceValue = [source objectForKey:sourceKey];
        id targetValue = [target objectForKey:sourceKey];
        
        if (targetValue == nil)
        {
            [Util addNewEntryToDictionary:target
                                      key:sourceKey
                                    value:sourceValue];
            continue;
        }
        else if (targetValue != nil)
        {
            if ([sourceValue isKindOfClass:kDictionaryClass] &&
                ([targetValue isKindOfClass:kMutableDictionaryClass] ||
                 [targetValue isKindOfClass:kDictionaryClass]))
            {
                [Util addNewEntriesOfSourceDictionary:sourceValue
                                   toTargetDictionary:targetValue];
            }
        }
    }
}

void removeDefaultValuesFromDictionaryRecursive(NSMutableDictionary* dictionary)
{
    for (id key in dictionary.allKeys)
    {
        id value = [dictionary objectForKey:key];
        
        if ([value isKindOfClass:kMutableDictionaryClass])
        {
            NSMutableDictionary* mutableDictionaryValue = (NSMutableDictionary*)value;
            
            removeDefaultValuesFromDictionaryRecursive(mutableDictionaryValue);
            
            if (mutableDictionaryValue.count == 0)
                [dictionary removeObjectForKey:key];
            
            continue;
        }
        
        CheckTrue(![value isKindOfClass:kDictionaryClass]);
        
        if ([value isKindOfClass:kArrayClass] ||
            [value isKindOfClass:kMutableArrayClass])
        {
            NSArray* arrayValue = (NSArray*)value;
            
            for (id entry in arrayValue)
            {
                if ([entry isKindOfClass:kMutableDictionaryClass])
                {
                    removeDefaultValuesFromDictionaryRecursive(entry);
                    continue;
                }
                
                CheckTrue(![entry isKindOfClass:kDictionaryClass]);
            }
        }
        
        if (value == [NSNull null])
            [dictionary removeObjectForKey:key];
        else if ([value respondsToSelector:@selector(floatValue)] &&
                 [value floatValue] == 0)
            [dictionary removeObjectForKey:key];
        
    }
}

+ (void)removeDefaultValuesFromDictionary:(NSMutableDictionary*)dictionary
{
    removeDefaultValuesFromDictionaryRecursive(dictionary);
}

+ (float)randomFloatBetween0And1
{
	return rand() / (float)RAND_MAX;
}

+ (float)randomFloatBetweenMin:(float)min
                           max:(float)max
{
	return (max - min) * [Util randomFloatBetween0And1] + min;
}

+ (int)randomIntBetweenMin:(int)min
                       max:(int)max
{
	return [Util randomFloatBetweenMin:min
                                   max:max + 1];
}

@end
