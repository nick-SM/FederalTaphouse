//
//  SMRefresh.m
//  FederalTaphouse
//
//  Created by Nick Woodward on 9/25/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import "SMRefresh.h"
#import "CATEGORY.h"
#import "BEER.h"
#import "SMOnlineCourseWebService.h"

@implementation SMRefresh
+(void)refresh:(NSManagedObjectContext *)context{
    NSFetchRequest * allBeers = [[NSFetchRequest alloc] initWithEntityName:@"BEER"];
    NSFetchRequest * allCategories = [[NSFetchRequest alloc] initWithEntityName:@"CATEGORY"];
    NSArray * beers = [context executeFetchRequest:allBeers error:nil];
    NSArray * categories = [context executeFetchRequest:allCategories error:nil];
    for (NSManagedObject * beer in beers) {
        [context deleteObject:beer];    }
    
    for (NSManagedObject * category in categories) {
        [context deleteObject:category];
    }
    
    SMOnlineCourseWebService *service = [[SMOnlineCourseWebService alloc]init];
    
    NSMutableArray *inputElements = [[NSMutableArray alloc]init];
    
    NSMutableArray *elementValues = [[NSMutableArray alloc]init];
    
    NSDictionary *result = [service doWebService:@"getBeerList" withElements:inputElements forValues:elementValues];
    
    NSArray *beerNames = result[@"beer_name"];
    NSArray *beerCategorys = result[@"beer_category_name"];
    NSArray *beerDescriptions = result[@"beer_description"];
    NSArray *beerABVs = result[@"beer_ABV"];
    NSArray *beerLocations = result[@"beer_location"];
    NSArray *beerPrices = result[@"beer_price"];
    NSArray *beerSizes = result[@"beer_size"];
    NSArray *beerDateAdded = result[@"beer_date_added"];
    NSMutableDictionary *catDict = [NSMutableDictionary new];
    for(int i = 0;i< [beerCategorys count];i++){
        if(!catDict[beerCategorys[i]]){
            CATEGORY *moCategory;
            moCategory = [NSEntityDescription
                          insertNewObjectForEntityForName:@"CATEGORY"
                          inManagedObjectContext:context];
            
            moCategory.categoryName = beerCategorys[i];
            [catDict setObject:moCategory forKey:beerCategorys[i]];
        }
    }
    
    for(int i = 0;i< [beerNames count];i++){
        BEER *moBEER;
        moBEER = [NSEntityDescription
                  insertNewObjectForEntityForName:@"BEER"
                  inManagedObjectContext:context];
        moBEER.beerName = beerNames[i];
        moBEER.beerLocation = beerLocations[i];
        moBEER.beerSize = beerSizes[i];
        moBEER.beerDescription = beerDescriptions[i];
        moBEER.beerPrice = beerPrices[i];
        moBEER.beerABV = beerABVs[i];
        moBEER.beerCategory = catDict[beerCategorys[i]];
        moBEER.beerDateAdded = beerDateAdded[i];
        
        
    }
    
    [context save:nil];
}
@end
