//
//  EventCatcher.h
//  Analytics
//
//  Created by Test on 01/02/18.
//  Copyright © 2018 Analytics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Aspects.h"

@interface EventCatcher : NSObject

- (id<AspectToken>)swizzleViewLoad;


@end
