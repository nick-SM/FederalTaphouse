//
//  UINavigationController+SMDisableAutorotate.m
//  FederalTaphouse
//
//  Created by Nick Woodward on 10/20/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import "UINavigationController+SMDisableAutorotate.h"

@implementation UINavigationController (SMDisableAutorotate)

- (BOOL) shouldAutorotate
{
    return [[self topViewController] shouldAutorotate];
}

- (NSUInteger) supportedInterfaceOrientations
{
    return [[self topViewController] supportedInterfaceOrientations];
}
@end
