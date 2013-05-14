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

@end
