//
//  SMWebService.h
//  OnlineCourseProject
//
//  Created by Nick Woodward on 9/3/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMOnlineCourseWebService : NSObject <NSXMLParserDelegate>

-(NSDictionary *)doWebService:(NSString *)name withElements:(NSArray *)elements forValues:(NSArray *)values;


@end
