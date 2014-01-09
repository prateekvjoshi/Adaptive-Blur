//
//  ABViewController.m
//  AdaptiveBlur
//
//  Created by Prateek Joshi
//

#import "ABViewController.h"
#import "ABBlurredImageView.h"

CGFloat const kFullBlurOffset = 400;  // content offset of the scrollview that will result in the full blur effect
CGFloat const kParallaxRatio  = 4;    // for every 4 pixels the foreground moves, we'll move the background 1 pixel
CGFloat const kParallaxMax    = 20;   // our background can move 10 pixels up

@interface ABViewController ()
<UIScrollViewDelegate>
@end

@implementation ABViewController
{
    ABBlurredImageView    *_blurredImageView;
    
    UIScrollView          *_scrollView;
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - Init
////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (!self)
        return nil;
    
    return self;
}

////////////////////////////////////////////////////////

- (void)loadView
{
    // Capture frame
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    
    // Create a scrollview
    self.view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, appFrame.size}];
    
    // Create blurred image view
    // Note that our image is 10px taller than the largest iPhone screen (568 + 10px), so we can have a parallax effect
    _blurredImageView = [[ABBlurredImageView alloc] initWithImage:[UIImage imageNamed:@"test.jpg"]];
    [_blurredImageView setBlurIntensity:0.f];
    [self.view addSubview:_blurredImageView];
    
    // Set up our scrollview above the background
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setDelegate:self];
    [self.view addSubview:_scrollView];
    
    // Add text title
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:36.f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.f alpha:0.3f]];
    [titleLabel setShadowOffset:(CGSize){1,1}];
    [titleLabel setText:@"Adaptive Blur"];
    [titleLabel sizeToFit];
    [_scrollView addSubview:titleLabel];
    
    // Position title label
    CGFloat margin = 20.f;
    CGPoint titleCenter = (CGPoint){margin + (titleLabel.frame.size.width * 0.5f),
        appFrame.size.height - margin - (titleLabel.frame.size.height * 0.5f)};
    [titleLabel setCenter:titleCenter];
    
    // Calculate scroll view's content size
    CGFloat contentHeight = CGRectGetMaxY(titleLabel.frame) + CGRectGetMinY(titleLabel.frame);
    CGSize contentSize = (CGSize){appFrame.size.width, contentHeight};
    [_scrollView setContentSize:contentSize];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    
    // Add info label
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin,
                                                                   CGRectGetMaxY(titleLabel.frame) + margin,
                                                                   appFrame.size.width - (margin*2),
                                                                   appFrame.size.height * 0.5f)];
    [infoLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:24.f]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setTextColor:[UIColor whiteColor]];
    [infoLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [infoLabel setNumberOfLines:0];
    [infoLabel setText:@"As you can see here, the image gets progressively blurry as you keep dragging it up. You can also see the parallax effect being used. "];
    [_scrollView addSubview:infoLabel];
}


////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
#pragma mark - ScrollView Delegate
////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    // Bounds checks
    if (contentOffsetY < 0)
        contentOffsetY = 0;
    else if (contentOffsetY > kFullBlurOffset)
        contentOffsetY = kFullBlurOffset;
    
    // Update blur
    [_blurredImageView setBlurIntensity:contentOffsetY / kFullBlurOffset];
    
    // Calculate image view's new frame
    CGFloat imageY = contentOffsetY / kParallaxRatio;
    
    if (contentOffsetY < kParallaxRatio)
        imageY = 0;
    else if (imageY > kParallaxMax)
        imageY = kParallaxMax;
    
    CGRect imageFrame = _blurredImageView.frame;
    imageFrame.origin.y = -imageY; // make origin negative since we want the frame to go up
    
    [_blurredImageView setFrame:imageFrame];
}

////////////////////////////////////////////////////////


@end