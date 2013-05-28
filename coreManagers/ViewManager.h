#import "Manager.h"

@class ViewLayer;
@class ManagedView;
@class GLKView;

@interface ViewManager : Manager

- (void)setDefaultViewLayer:(ViewLayer*)viewLayer;

- (void)setGLKView:(GLKView*)glkView;

- (GLKView*)getGLKView;

- (void)setViewLayer:(ViewLayer*)viewLayer
           layerName:(NSString*)layerName;

- (void)showManagedViewOfClassOnDefaultLayer:(Class)managedViewClass
                                  setupBlock:(void(^)(id))setupBlock;

- (void)showManagedViewOfClassOnLayer:(Class)managedViewClass
                            layerName:(NSString*)layerName
                           setupBlock:(void(^)(id))setupBlock;

- (id)createManagedViewOfClass:(Class)managedViewClass
                        parent:(id)parent;

- (void)dismissAllViewsOnDefaultLayer;

@end
