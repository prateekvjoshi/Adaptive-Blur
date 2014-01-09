//
// ABBlurredImageView.m
//
// Created by Prateek Joshi
//


#import "ABBlurredImageView.h"

@implementation ABBlurredImageView
{
  UIImageView   *_imageView;
  UIImageView   *_blurredImageView;
  
  BOOL          _userInteractionEnabled;
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Init
////////////////////////////////////////////////////////
- (id)initWithImage:(UIImage *)image
{
  // Make sure we have an image to work with
  if (!image)
    return nil;
  
  // Calculate frame size
  CGRect frame = (CGRect){CGPointZero, image.size};
  
  self = [super initWithFrame:frame];
  
  if (!self)
    return nil;
  
  // Pass along parameters
  _image = image;
  
  [self ABBlurredImageView_commonInit];
  
  return self;
}

////////////////////////////////////////////////////////
- (void)ABBlurredImageView_commonInit
{
  // Make sure we're not subclassed
  if ([self class] != [ABBlurredImageView class])
    return;
  
  // Set user interaction to NO
  [self setUserInteractionEnabled:NO];
  
  // Set up regular image
  _imageView = [[UIImageView alloc] initWithImage:_image];
  [self addSubview:_imageView];
  
  // Set blurred image
  _blurredImageView = [[UIImageView alloc] initWithImage:[self blurredImage]];
  [_blurredImageView setAlpha:0.95f];
  
  if (_blurredImageView)
    [self addSubview:_blurredImageView];
  
  NSLog(@"imageview frame = %@", NSStringFromCGRect(_imageView.frame));
  NSLog(@"blurred frame = %@", NSStringFromCGRect(_blurredImageView.frame));
}


////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Blur
////////////////////////////////////////////////////////
/*
========================
- (UIImage *)blurredImage
Description: Returns a Gaussian blurred version of _image
========================
*/
- (UIImage *)blurredImage
{
  // Make sure that we have an image to work with
  if (!_image)
    return nil;
  
  // Create context
  CIContext *context = [CIContext contextWithOptions:nil];
  
  // Create an image
  CIImage *image = [CIImage imageWithCGImage:_image.CGImage];
  
  // Set up a Gaussian Blur filter
  CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
  [blurFilter setValue:image forKey:kCIInputImageKey];
    
  // Get blurred image out
  CIImage *blurredImage = [blurFilter valueForKey:kCIOutputImageKey];
  
  // Set up vignette filter
  CIFilter *vignetteFilter = [CIFilter filterWithName:@"CIVignette"];
  [vignetteFilter setValue:blurredImage forKey:kCIInputImageKey];
  [vignetteFilter setValue:@(4.f) forKey:@"InputIntensity"];
  
  // get vignette & blurred image
  CIImage *vignetteImage = [vignetteFilter valueForKey:kCIOutputImageKey];

  CGFloat scale = [[UIScreen mainScreen] scale];
  CGSize scaledSize = CGSizeMake(_image.size.width * scale, _image.size.height * scale);
  CGImageRef imageRef = [context createCGImage:vignetteImage fromRect:(CGRect){CGPointZero, scaledSize}];
  
  return [UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
}

/*
========================
- (void)setBlurIntensity
Description: Changes the opacity on the blurred image to change intensity
========================
*/
- (void)setBlurIntensity:(CGFloat)blurIntensity
{
  if (blurIntensity < 0.f)
    blurIntensity = 0.f;
  else if (blurIntensity > 1.f)
    blurIntensity = 1.f;
  
  _blurIntensity = blurIntensity;
  
  [_blurredImageView setAlpha:blurIntensity];
}

////////////////////////////////////////////////////////
@end
