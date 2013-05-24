#import "Manager.h"

@class ViewLayer;
@class ManagedView;
@class EAGLView;

@interface ViewManager : Manager

- (void)setDefaultViewLayer:(ViewLayer*)viewLayer;

- (void)setEAGLView:(EAGLView*)eaglView;

- (EAGLView*)getEAGLView;

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
