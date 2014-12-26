//
//  SignatureViewController.h
//
//  Created by John Montiel on 5/11/12.
//

#import <UIKit/UIKit.h>
#import "SignatureView.h"

@class SignatureViewController;

@protocol SignatureViewControllerDelegate <NSObject>
- (void) signatureViewController:(SignatureViewController *)viewController didSign:(NSData *)signature;
@end


@interface SignatureViewController : UIViewController
@property (strong, nonatomic) IBOutlet SignatureView *signatureView;
@property (strong, nonatomic) id<SignatureViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *signatureTextField;
-(void)checkSign;

@end
