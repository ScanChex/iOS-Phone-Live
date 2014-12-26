//
//  DSTableViewCellWithDynamicHeight.h

//  Created by Daniel Saidi on 2014-02-18.
//  https://github.com/danielsaidi/DSTableViewWithDynamicHeight
//


/*
 This protocol can be implemented by any cell class that
 has a dynamic height, and is able to calculate it based
 on the width of the cell.
 */

#import <Foundation/Foundation.h>

@protocol DSTableViewCellWithDynamicHeight <NSObject>

+ (CGFloat)heightForCellWidth:(CGFloat)cellWidth;

@end
