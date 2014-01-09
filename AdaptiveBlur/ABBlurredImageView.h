//
// ABBlurredImageView.h
//

#import <UIKit/UIKit.h>

@interface ABBlurredImageView : UIView

- (id)initWithImage:(UIImage *)image;

@property (nonatomic, strong) UIImage   *image;           // default is nil
@property (nonatomic, assign) CGFloat   blurIntensity;    // default is 0.f

@property (nonatomic, assign, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;   // default is NO

@end
