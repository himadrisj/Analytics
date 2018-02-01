//
//  EventCatcher.m
//  Analytics
//
//  Created by Test on 01/02/18.
//  Copyright © 2018 Analytics. All rights reserved.
//

#import "EventCatcher.h"
#import <UIKit/UIKit.h>

@implementation EventCatcher

- (id<AspectToken>)swizzleViewLoad {
    return [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"View Controller %@ will appear animated: %tu", aspectInfo.instance, animated);
    } error:NULL];
}

@end
