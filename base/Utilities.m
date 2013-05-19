#import "Utilities.h"
#import <objc/runtime.h>
#import "ViewManager.h"

NSDateFormatter* dateFormatter = nil;

@implementation Util

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
    if ([value isKindOfClass:NSDictionary.class])
    {
        NSMutableDictionary* targetEntry = [NSMutableDictionary object];
        [Util addNewEntriesOfSourceDictionary:value
                           toTargetDictionary:targetEntry];
        [target addObject:targetEntry];
    }
    else if ([value isKindOfClass:NSArray.class])
    {
        NSMutableArray* targetEntry = [NSMutableArray object];
        for (id entry in value)
        {
            [Util addNewEntryToArray:targetEntry
                               value:value];
        }
        [target addObject:targetEntry];
    }
    else
    {
        [target addObject:[value copy]];
    }
}

+ (void)addNewEntryToDictionary:(NSMutableDictionary*)target
                            key:(NSString*)key
                          value:(id)value
{
    if ([value isKindOfClass:NSDictionary.class])
    {
        NSMutableDictionary* targetEntry = [NSMutableDictionary object];
        [Util addNewEntriesOfSourceDictionary:value
                           toTargetDictionary:targetEntry];
        [target setObject:targetEntry
                   forKey:key];
    }
    else if ([value isKindOfClass:NSArray.class])
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
        [target setObject:[value copy]
                   forKey:key];
    }
}


+ (void)addNewEntriesOfSourceDictionary:(NSDictionary*)source
                     toTargetDictionary:(NSMutableDictionary*)target;
{
    // TODO: replace (then test) with object_getClass([NSDictionary.class])
    // TODO: replace (then test) with object_getClass([NSMutableDictionary.class])
    Class dictionaryClass = source.class;
    Class mutableDictionaryClass = target.class;
    
    for (NSString* sourceKey in source.allKeys)
    {
        id sourceValue = [source objectForKey:sourceKey];
        id targetValue = [target objectForKey:sourceKey];
        
        Class sourceValueClass = [sourceValue class];
        Class targetValueClass = [targetValue class];
        
        if (targetValue == nil)
        {
            [Util addNewEntryToDictionary:target
                                      key:sourceKey
                                    value:sourceValue];
            continue;
        }
        else if (targetValue != nil)
        {
            if (sourceValueClass == dictionaryClass &&
                (targetValueClass == mutableDictionaryClass ||
                 targetValueClass == dictionaryClass))
            {
                [Util addNewEntriesOfSourceDictionary:sourceValue
                                   toTargetDictionary:targetValue];
            }
            continue;
        }
    }
}

@end
