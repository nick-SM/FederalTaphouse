//
//  BEER.h
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/7/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BEER : NSManagedObject

@property (nonatomic, retain) NSString * beerName;
@property (nonatomic, retain) NSString * beerDescription;
@property (nonatomic, retain) NSString * beerABV;
@property (nonatomic, retain) NSString * beerPrice;
@property (nonatomic, retain) NSString * beerLocation;
@property (nonatomic, retain) NSString * beerSize;
@property (nonatomic, retain) NSString * beerDateAdded;

@property (nonatomic, retain) NSManagedObject *beerCategory;

@end
