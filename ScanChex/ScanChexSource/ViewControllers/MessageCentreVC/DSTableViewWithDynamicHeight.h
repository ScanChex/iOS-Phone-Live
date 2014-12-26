//
//  DSTableViewWithDynamicHeight.h

//  Created by Daniel Saidi on 2014-02-18.
//  https://github.com/danielsaidi/DSTableViewWithDynamicHeight
//

#import <UIKit/UIKit.h>
#import "DSTableViewCellWithDynamicHeight.h"

@interface DSTableViewWithDynamicHeight : UITableView

@property (nonatomic, assign, readonly) CGFloat cellWidth;

- (void)handleOrientationChange;
- (CGFloat)heightForCell:(UITableViewCell *)cell withStyle:(UITableViewCellStyle)style;
- (CGFloat)heightForCellWithDefaultStyleAndText:(NSString *)text font:(UIFont *)font;
- (CGFloat)heightForCellWithSubtitleStyleAndTitleText:(NSString *)titleText titleFont:(UIFont *)titleFont subTitleText:(NSString *)subTitleText subTitleFont:(UIFont *)subTitleFont;

@end
