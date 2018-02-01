//
//  EventCatcher.h
//  Analytics
//
//  Created by Test on 01/02/18.
//  Copyright © 2018 Analytics. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AspectToken;

@interface ViewLoadInfo: NSObject

@property (nonatomic, copy) NSString *viewControllerName;
@property (nonatomic, copy) NSString *title;

@end

@interface ControlClickInfo: NSObject

@property (nonatomic, copy) NSString *controlName;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *title;

@end

@protocol EventCatcherDelegate

- (void)didCatchViewLoadInfo:(ViewLoadInfo *)viewInfo;
- (void)didCatchControlClickInfo:(ControlClickInfo *)clickInfo;

@end


@interface EventCatcher : NSObject

- (id)initWithDelegate:(id<EventCatcherDelegate>)aDelegate;

- (id<AspectToken>)swizzleViewLoad;

- (id<AspectToken>)swizzleControlClick;

@end
