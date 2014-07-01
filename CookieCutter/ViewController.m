//
//  ViewController.m
//  CookieCutter
//
//  Created by Chris Lowe on 6/26/14.
//  Copyright (c) 2014 Chris Lowe. All rights reserved.
//

#import "ViewController.h"
#import "CookieMaskView.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet UIButton *pictureButton;
@property (nonatomic, strong) IBOutlet UILabel *introLabel;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *cookieControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPictureButtonSelected:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Cannot access Saved Photos on device :("
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        self.photoImageView.image = info[UIImagePickerControllerEditedImage];
//        self.scrollView.contentSize = CGSizeMake(self.photoImageView.image.size.width * 2.0f, self.photoImageView.image.size.height);
    }];
}

- (IBAction)segmentControlAction:(id)sender
{
    switch(self.cookieControl.selectedSegmentIndex) {
        case 0: {
            [self removeMask];
            break;
        }
        case 1: {
            [self addCookieMaskToImage];
            break;
        }
        case 2: {
            [self addStarMaskToImage];
            break;
        }
        case 3: {
            [self addHeartMaskToImage];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)removeMask {
    self.photoImageView.layer.mask = nil;
//    self.scrollView.layer.mask = nil;
    self.view.layer.mask = nil;

}

- (void)addHeartMaskToImage {
    UIBezierPath *bezzie = [CookieMaskView heartShape:self.photoImageView.frame];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezzie.CGPath;
    [self.photoImageView.layer setMask:shapeLayer];
    
    //    CookieMaskView *cookieMask = [[CookieMaskView alloc] initWithFrame:self.photoImageView.frame];
    //or make it as [imageview.layer setMask:shapeLayer];
    //and add imageView as subview of whichever view you want. draw the original image
    //on the imageview in that case
    //    [self.view addSubview:self.photoImageView]
    //    UIBezierPath *aPath = [UIBezierPath bezierPath];
    //    // Set the starting point of the shape.
    //    [aPath moveToPoint:CGPointMake(0.0, 0.0)];
    //    // Draw the lines.
    //    [aPath addLineToPoint:CGPointMake(50.0, 0.0)];
    //    [aPath addLineToPoint:CGPointMake(50.0, 50.0)];
    //    [aPath addLineToPoint:CGPointMake(0.0, 50.0)];
    //    [aPath closePath];
    //
    //    [self setClippingPath:aPath :self.photoImageView];
    //    [self.photoImageView addSubview:self.photoImageView];
}

- (void)addStarMaskToImage {
    UIBezierPath *bezzie = [CookieMaskView starShape:self.photoImageView.frame];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezzie.CGPath;
    [self.photoImageView.layer setMask:shapeLayer];
}

- (void)addCookieMaskToImage {
    CGRect path = CGRectMake(self.photoImageView.center.x-150.0f, self.photoImageView.center.y-150.0f, 300.0f, 300.0f);
    UIBezierPath *bezzie = [UIBezierPath bezierPathWithOvalInRect:path];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezzie.CGPath;
    [self.photoImageView.layer setMask:shapeLayer];
}

#pragma mark - Sharing image
- (UIImage *)currentMaskedImage {
    UIGraphicsBeginImageContext(self.photoImageView.bounds.size);
    [self.photoImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)shareImage:(id)sender {
    UIImage *imageToSave = [self currentMaskedImage];
    
    
    NSString *shareText = [NSString stringWithFormat:@"Check out this picture I made in Cookie Cutter!"];
    NSArray *items   = [NSArray arrayWithObjects:
                        shareText,
                        imageToSave,
                        nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [activityViewController setValue:shareText forKey:@"subject"];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - UIScrollView delegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoImageView;
}

@end
