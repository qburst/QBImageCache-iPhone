
//
//  Smoothens out the table scrolling
//
//  ABTableViewCell.h
//
//  Created by Loren Brichter
//  Copyright 2008 Loren Brichter. All rights reserved.
//
//  
//

#import <UIKit/UIKit.h>

// to use: subclass ABTableViewCell and implement -drawContentView:

@interface ABTableViewCell : UITableViewCell
{
	UIView *contentView;
}

- (void)drawContentView:(CGRect)r; // subclasses should implement

@end
