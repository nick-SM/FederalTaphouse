//
//  FederalTaphouseTests.m
//  FederalTaphouseTests
//
//  Created by Nick Woodward on 9/7/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SMMasterViewController.h"

@interface FederalTaphouseTests : XCTestCase

@end

@implementation FederalTaphouseTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testNewIndicator{
    SMMasterViewController *m = [[SMMasterViewController alloc]init];
    ;
    XCTAssertEqualObjects([m findIfNew:@"9/27/2014 12:12:12 PM"],@"NEW!",@"new date not detected");
    XCTAssertEqualObjects([m findIfNew:@"9/20/2014 12:12:12 PM"],@"",@"old date not detected");
}

/*- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}*/

@end
