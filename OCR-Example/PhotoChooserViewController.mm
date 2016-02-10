//
//  ViewController.m
//  OCR-Example
//
//  Created by Christopher Constable on 5/10/13.
//  Copyright (c) 2013 Christopher Constable. All rights reserved.
//

#import "PhotoChooserViewController.h"
#import "ResultsViewController.h"
#import "ImageProcessing.h"

@interface PhotoChooserViewController ()
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic) int threshold;
@end

@implementation PhotoChooserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Show process button
    if (self.selectedImage) {
        
        // Shrink the image. Tesseract works better with smaller images than what the iPhone puts out.
        CGSize newSize = CGSizeMake(self.selectedImage.size.width / 3, self.selectedImage.size.height / 3);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [self.selectedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.selectedImage = resizedImage;
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Process"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(processWasPressed:)];
        [self.navigationItem setRightBarButtonItem:barButton animated:YES];
        [self.selectedImageView setImage:self.selectedImage];
        
        self.threshold = 80;
        [self.thresholdField setText:[NSString stringWithFormat:@"%d", self.threshold]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)processWasPressed:(id)sender
{
    ResultsViewController *resultsVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"Results"];
    
    // Create loading view.
    resultsVC.loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    resultsVC.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [resultsVC.view addSubview:resultsVC.loadingView];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
    [resultsVC.loadingView addSubview:activityView];
    activityView.center = resultsVC.loadingView.center;
    [activityView startAnimating];
    
    resultsVC.selectedImage = self.selectedImage;
    resultsVC.threshold = self.threshold;
    [resultsVC.selectedImageView setImage:self.selectedImage];
    
    // Push
    [self.navigationController pushViewController:resultsVC animated:YES];
    
}

- (IBAction)choosePhotoWasTapped:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:nil];
}

- (IBAction)thresholdInc:(id)sender {
    self.threshold += 10;
    [self.thresholdField setText:[NSString stringWithFormat:@"%d", self.threshold]];
    [self updateImage];
}

- (IBAction)thresholdDec:(id)sender {
    self.threshold -= 10;
    [self.thresholdField setText:[NSString stringWithFormat:@"%d", self.threshold]];
    [self updateImage];
}


- (void)updateImage {
    ImageWrapper *greyScale=Image::createImage(self.selectedImage, self.selectedImage.size.width, self.selectedImage.size.height, false);
    ImageWrapper *edges = greyScale.image->fixedThreshold(self.threshold);
    
    UIImage *processedImage = edges.image->toUIImage();
    [self.selectedImageView setImage:processedImage];
    
}

@end
