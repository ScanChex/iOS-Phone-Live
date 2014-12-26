//
//  UploadAdminVC.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "BaseVC.h"

@interface UploadAdminVC : BaseVC <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (retain, nonatomic) UIImage *picture;
@property (retain, nonatomic) NSString *assetIDString;
@property (assign, nonatomic) BOOL isPicture;
@property (retain, nonatomic) IBOutlet AsyncImageView *logo;
@property (retain, nonatomic) IBOutlet AsyncImageView *asset;
@property (retain, nonatomic) IBOutlet UILabel *assetID;
@property (retain, nonatomic) IBOutlet UILabel *lblDescription;
@property (retain, nonatomic) IBOutlet UILabel *serialNumber;
@property (retain, nonatomic) IBOutlet UITextView *address;
@property (retain, nonatomic) IBOutlet UILabel *lastScannedDate;
@property (retain, nonatomic) IBOutlet UILabel *enployee;
@property (retain, nonatomic) IBOutlet UIButton *submit;
@property (retain, nonatomic) IBOutlet UIButton *cancel;
@property (retain, nonatomic) IBOutlet UIButton *takePicture;
@property (retain, nonatomic) UIProgressView *myProgressIndicator;

- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)takePictureButtonPressed:(id)sender;

+(id)initWithUpload:(UIImage *)image assetID:(NSString *)asset isPicture:(BOOL)isPic;
@end
