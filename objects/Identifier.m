#import "Base.h"
#import "Identifier.h"

@interface Identifier ()
{
	
}

@property (nonatomic, retain) NSString* identifier;

@end


@implementation Identifier

- (BOOL)isEqual:(Identifier*)identifier
{
    return [_identifier isEqual:identifier.identifier];
}

- (NSUInteger)hash
{
    return [_identifier hash];
}

- (NSString*)stringValue
{
    return _identifier;
}

- (id)copyWithZone:(NSZone*)zone
{
    Identifier* identifer = [[Identifier object] retain];
    identifer.identifier = _identifier;
    return identifer;
}

- (void)setStringIdentifier:(NSString*)stringIdentifier
{
    CheckTrue(_identifier == nil);
    self.identifier = stringIdentifier;
}

- (void)setIntIdentifier:(int64_t)intIdentifier
{
    CheckTrue(_identifier == nil);
    self.identifier = Format(@"%lld", intIdentifier);
}

@end
