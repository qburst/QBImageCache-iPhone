//
//  NetworkActivity.h
//
//  Created by renjini on 06/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkActivity : NSObject {

}

// balance these calls with each other.
// i.e. for each push there should be one corresponding pop
+ (void)pushNetworkActivity;
+ (void)popNetworkActivity;

@end
