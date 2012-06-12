//
//  HomeTableViewCell.m
//  ImageCacheSampleProject
//
//  Created by martin on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeTableViewCell.h"

static UIFont *textFont = nil;

@implementation HomeTableViewCell

@synthesize logo = logo_;
@synthesize titleLabel = titleLabel_;

+ (void)initialize {
	
    if (self==[HomeTableViewCell class]) {
        textFont = [[UIFont boldSystemFontOfSize:16] retain];
    }
}

- (void)setLogo:(UIImage *)logoImage {
	
    if (logo_) {
        [logo_ release];        
    }
    logo_ = [logoImage retain];
    [self setNeedsDisplay];
}

- (void)setTitleLabel:(NSString *)title {
	
    if (titleLabel_) {
        [titleLabel_ release];
    }
    titleLabel_=[title retain];
    [self setNeedsDisplay];
}

/*
 Draws the title and image in the already drawn cell
 */
- (void)drawContentView:(CGRect)r {
	
    UIColor *backgroundColor = nil;
    UIColor * textColor = nil;
    if (self.selected||self.highlighted) {
		backgroundColor = [UIColor whiteColor];
        textColor = [UIColor whiteColor];
    } else {
       textColor = [UIColor blackColor];
		backgroundColor = [UIColor whiteColor];

   }
	[backgroundColor set];
       
    if (logo_) {
		
        [logo_ drawInRect:CGRectMake(10.0, 0.0, 40.0, 40.0)];
		
    }
    if (titleLabel_) {
       [textColor set];
        [titleLabel_ drawInRect:CGRectMake(90.0, 10.0, 180.0, 20.0) withFont:textFont lineBreakMode:UILineBreakModeTailTruncation];       
    }
}

- (void)dealloc{
	
    [logo_ release];
    [titleLabel_ release];
    [super dealloc];
}

@end
