//
//  HomeTableViewCell.h
//  ImageCacheSampleProject
//
//  Created by martin on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"


@interface HomeTableViewCell :  ABTableViewCell {
	
	 UIImage *logo_;
	 NSString *titleLabel_;
}

@property (nonatomic,retain) UIImage *logo;
@property (nonatomic,retain) NSString *titleLabel;

- (void)setLogo:(UIImage *)logo;
- (void)setTitleLabel:(NSString *)titleLabel;
@end
