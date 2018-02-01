//
//  EventCatcher.m
//  Analytics
//
//  Created by Test on 01/02/18.
//  Copyright © 2018 Analytics. All rights reserved.
//

#import "EventCatcher.h"
#import <UIKit/UIKit.h>
#import "Aspects.h"

@implementation ViewLoadInfo

@end


@implementation ControlClickInfo

@end

@interface EventCatcher()

@property (nonatomic, weak) id<EventCatcherDelegate> delegate;

@end

@implementation EventCatcher

- (id)initWithDelegate:(id<EventCatcherDelegate>)aDelegate {
    if(self = [super init]) {
        self.delegate = aDelegate;
        return self;
    }
    
    return nil;
}

- (id<AspectToken>)swizzleViewLoad {
    NSError *error = nil;
    
    id<AspectToken> retVal = [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        
        if([aspectInfo.instance isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)aspectInfo.instance;
            
            ViewLoadInfo *info = [[ViewLoadInfo alloc] init];
            
            info.viewControllerName = NSStringFromClass([vc class]);
            info.title = vc.title;
            
            [self.delegate didCatchViewLoadInfo:info];
        }
        
        
    } error:&error];
    
    if(error != nil) {
        return nil;
    }
    
    return retVal;
}

- (id<AspectToken>)swizzleControlClick {
    NSError *error = nil;
    
    id<AspectToken> retVal = [UIControl aspect_hookSelector:@selector(beginTrackingWithTouch:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        if([aspectInfo.instance isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)aspectInfo.instance;
            
            ControlClickInfo *info = [[ControlClickInfo alloc] init];
            
            info.controlName = NSStringFromClass([button class]);
            info.aid = button.accessibilityIdentifier;
            info.title = button.titleLabel.text;
            
            [self.delegate didCatchControlClickInfo:info];
        }
        
        
    } error:&error];
    
    if(error != nil) {
        return nil;
    }
    
    return retVal;
}

@end
