/*
 * Copyright (c) 2014 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "RWTViewController.h"
#import "RWTCookieCutterMasks.h"

@interface RWTViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *sharePhotoButton;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *cookieControl;

@end

@implementation RWTViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  [self.cookieControl setTitleTextAttributes:attributes forState:UIControlStateSelected];
}

#pragma mark - Orientation Change

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    [self didChangeCookieMaskSegment:nil];
  }];
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
    [self showViewController:photoPicker sender:self];
  }
}

- (IBAction)didChangeCookieMaskSegment:(id)sender
{
  switch(self.cookieControl.selectedSegmentIndex) {
    case 0:
      [self applyNoMaskToImage];
      break;
    case 1:
      [self applyCookieMaskToImage];
      break;
    case 2:
      [self applyStarMaskToImage];
      break;
    case 3:
      [self applyHeartMaskToImage];
      break;
    default:
      [self applyNoMaskToImage];
      break;
  }
}

- (IBAction)shareImage:(id)sender {
  UIImage *imageToSave = [self currentMaskedImage];
  
  NSString *shareText = @"Check out this picture I made in Cookie Cutter!";
  UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[shareText, imageToSave] applicationActivities:nil];
  
  [self showViewController:activityViewController sender:self];
}

#pragma mark - Private

- (void)applyHeartMaskToImage {
  UIBezierPath *bezle = [RWTCookieCutterMasks bezierPathForHeartShapeInRect:self.photoImageView.frame];
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  shapeLayer.path = bezle.CGPath;
  [self.photoImageView.layer setMask:shapeLayer];
}

- (void)applyStarMaskToImage {
  UIBezierPath *bezle = [RWTCookieCutterMasks bezierPathForStarShapeInRect:self.photoImageView.frame];
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  shapeLayer.path = bezle.CGPath;
  [self.photoImageView.layer setMask:shapeLayer];
}

- (void)applyCookieMaskToImage {
  UIBezierPath *bezle = [RWTCookieCutterMasks bezierPathForCookieShapeInRect:self.photoImageView.frame];
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  shapeLayer.path = bezle.CGPath;
  [self.photoImageView.layer setMask:shapeLayer];
}

- (void)applyNoMaskToImage {
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
    self.addPhotoButton.hidden = YES;
  }];
}

@end
