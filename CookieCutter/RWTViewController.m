//
//  ViewController.m
//  CookieCutter
//
//  Created by Chris Lowe on 6/26/14.
//  Copyright (c) 2014 Chris Lowe. All rights reserved.
//

#import "RWTViewController.h"
#import "RWTCookieCutterMasks.h"

@interface RWTViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *introLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *cookieControl;

@end

@implementation RWTViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Orientation Change

// On rotation, have the mask re-applied to account for the change in width/height sizes
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  if (self.photoImageView.image) {
    [self didChangeCookieMaskSegment:nil];
  }
}

#pragma mark - IBActions

- (IBAction)addPictureButtonSelected:(id)sender {
  if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Cannot access Saved Photos on device :["
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles: nil] show];
  } else {
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.allowsEditing = YES;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self showDetailViewController:photoPicker sender:self];
  }
}

- (IBAction)didChangeCookieMaskSegment:(id)sender
{
  switch(self.cookieControl.selectedSegmentIndex) {
    case 0:
      [self removeMask];
      break;
    case 1:
      [self addCookieMaskToImage];
      break;
    case 2:
      [self addStarMaskToImage];
      break;
    case 3:
      [self addHeartMaskToImage];
      break;
    default:
      break;
  }
}

- (IBAction)shareImage:(id)sender {
  UIImage *imageToSave = [self currentMaskedImage];
  
  NSString *shareText = @"Check out this picture I made in Cookie Cutter!";
  NSArray *items   = @[shareText,imageToSave];
  
  UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
  [activityViewController setValue:shareText forKey:@"subject"];
  
  [self showDetailViewController:activityViewController sender:self];
}

#pragma mark - Private

- (void)addHeartMaskToImage {
  UIBezierPath *bezle = [RWTCookieCutterMasks bezierPathForHeartShapeInRect:self.photoImageView.frame];
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  shapeLayer.path = bezle.CGPath;
  [self.photoImageView.layer setMask:shapeLayer];
}

- (void)addStarMaskToImage {
  UIBezierPath *bezle = [RWTCookieCutterMasks bezierPathForStarShapeInRect:self.photoImageView.frame];
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  shapeLayer.path = bezle.CGPath;
  [self.photoImageView.layer setMask:shapeLayer];
}

- (void)addCookieMaskToImage {
  UIBezierPath *bezle = [RWTCookieCutterMasks bezierPathForCircleShapeInRect:self.photoImageView.frame];
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  shapeLayer.path = bezle.CGPath;
  [self.photoImageView.layer setMask:shapeLayer];
}

- (void)removeMask {
  self.photoImageView.layer.mask = nil;
}

#pragma mark - Image Capture

- (UIImage *)currentMaskedImage {
  UIGraphicsBeginImageContext(self.photoImageView.bounds.size);
  [self.photoImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

#pragma mark - Delegate Callbacks

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [picker dismissViewControllerAnimated:YES completion:^{
    self.photoImageView.image = info[UIImagePickerControllerEditedImage];
    self.introLabel.hidden = YES;
  }];
}

@end
