//
//  DSTableViewWithDynamicHeight.m

//  Created by Daniel Saidi on 2014-02-18.
//  https://github.com/danielsaidi/DSTableViewWithDynamicHeight
//

#import "DSTableViewWithDynamicHeight.h"

#define DEFAULT_CELL_HEIGHT             44


@interface DSTableViewWithDynamicHeight ()<UITableViewDataSource>
@end


@implementation DSTableViewWithDynamicHeight {
    UITableView *_calculationTableView;
    NSLineBreakMode _textLabelLineBreakMode;
    CGFloat _textLabelWidth;
}


#pragma mark - Overrides

- (void)reloadData {
	[super reloadData];
	if (![self isCellDataCollected]) {
		[self collectData];
    }
}


#pragma mark - Public methods

- (void)handleOrientationChange {
    [self resetData];
    [self collectData];
}

- (CGFloat)heightForCell:(UITableViewCell *)cell withStyle:(UITableViewCellStyle)style {
    switch (style) {
        case UITableViewCellStyleDefault:
            return [self heightForCellWithDefaultStyleAndText:cell.textLabel.text
                                                         font:cell.textLabel.font];
        case UITableViewCellStyleSubtitle:
            return [self heightForCellWithSubtitleStyleAndTitleText:cell.textLabel.text
                                                          titleFont:cell.textLabel.font
                                                       subTitleText:cell.detailTextLabel.text
                                                       subTitleFont:cell.detailTextLabel.font];
        default:
            return DEFAULT_CELL_HEIGHT;
    }
}

- (CGFloat)heightForCellWithDefaultStyleAndText:(NSString *)text font:(UIFont *)font {
	if (![self isCellDataCollected]) {
		return DEFAULT_CELL_HEIGHT;
    }
    
    CGSize constraint = CGSizeMake(_textLabelWidth, INT32_MAX);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:_textLabelLineBreakMode];
    
    return size.height;
}

- (CGFloat)heightForCellWithDynamicHeight:(id<DSTableViewCellWithDynamicHeight>)cell {
    return [cell heightForCellWidth:_cellWidth];
}

- (CGFloat)heightForCellWithSubtitleStyleAndTitleText:(NSString *)titleText titleFont:(UIFont *)titleFont subTitleText:(NSString *)subTitleText subTitleFont:(UIFont *)subTitleFont {
    if (![self isCellDataCollected]) {
		return DEFAULT_CELL_HEIGHT;
    }
    
    CGSize constraint = CGSizeMake(_textLabelWidth, INT32_MAX);
    CGSize titleSize = [titleText sizeWithFont:titleFont constrainedToSize:constraint lineBreakMode:_textLabelLineBreakMode];
    CGSize detailSize = [subTitleText sizeWithFont:subTitleFont constrainedToSize:constraint lineBreakMode:_textLabelLineBreakMode];
	
    return titleSize.height + detailSize.height;
}



#pragma mark - Private methods

- (void)collectData {
    _calculationTableView = [[UITableView alloc] initWithFrame:self.bounds];
    _calculationTableView.dataSource = self;
    [self insertSubview:_calculationTableView atIndex:0];
    [_calculationTableView reloadData];
}

- (void)collectDataForCellAtIndexPath:(NSArray *)data {
    UITableViewCell *cell = [data objectAtIndex:0];
    _cellWidth = cell.frame.size.width;
    _textLabelWidth = cell.textLabel.frame.size.width;
    _textLabelLineBreakMode = cell.textLabel.lineBreakMode;
    [_calculationTableView removeFromSuperview];
    _calculationTableView = nil;
    [self reloadRowsAtIndexPaths:[self indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

- (BOOL)isCellDataCollected {
    if (_cellWidth == 0) {
        return false;
    }
    if (_textLabelWidth == 0) {
        return false;
    }
    return true;
}

- (void)resetData {
    _cellWidth = 0;
    _textLabelWidth = 0;
}


#pragma mark - Data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    cell.textLabel.text = @" ";
    [self performSelector:@selector(collectDataForCellAtIndexPath:) withObject:[NSArray arrayWithObjects:cell, indexPath, nil] afterDelay:0.01];
    
    return cell;
}

@end