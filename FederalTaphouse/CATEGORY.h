//
//  CATEGORY.h
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/7/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BEER;

@interface CATEGORY : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSSet *categoryBeers;
@end

@interface CATEGORY (CoreDataGeneratedAccessors)

- (void)addCategoryBeersObject:(BEER *)value;
- (void)removeCategoryBeersObject:(BEER *)value;
- (void)addCategoryBeers:(NSSet *)values;
- (void)removeCategoryBeers:(NSSet *)values;

@end
