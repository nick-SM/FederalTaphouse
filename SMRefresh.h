//
//  SMRefresh.h
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/25/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMRefresh : NSObject
+(void)refresh:(NSManagedObjectContext *)context;
    
@end
