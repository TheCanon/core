
@interface Identifier : NSObject<NSCopying>

- (BOOL)isEqual:(Identifier*)identifier;

- (NSUInteger)hash;

- (NSString*)stringValue;

- (void)setStringIdentifier:(NSString*)stringIdentifier;

- (void)setIntIdentifier:(int64_t)intIdentifier;

@end