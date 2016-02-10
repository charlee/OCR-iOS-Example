//
//  ViewController.h
//  OCR-Example
//
//  Created by Christopher Constable on 5/10/13.
//  Copyright (c) 2013 Christopher Constable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoChooserViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UISlider *thresholdSlider;
@property (weak, nonatomic) IBOutlet UILabel *thresholdField;

- (IBAction)choosePhotoWasTapped:(id)sender;
- (IBAction)thresholdInc:(id)sender;
- (IBAction)thresholdDec:(id)sender;

@end
