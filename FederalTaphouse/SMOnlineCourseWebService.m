//
//  SMWebService.m
//  OnlineCourseProject
//
//  Created by Nick Woodward on 9/3/14.
//  Copyright (c) 2014 softwaremerchant. All rights reserved.
//

#import "SMOnlineCourseWebService.h"

@implementation SMOnlineCourseWebService{
    
    NSMutableDictionary *result;
    NSString *currentElementValue;
}

-(NSDictionary *)doWebService:(NSString *)name withElements:(NSArray *)elements forValues:(NSArray *)values{
    result = [NSMutableDictionary new];
    NSString *envelopeText=
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
    "  <soap12:Body>\n";
    
    NSString *format;
    format = [NSString stringWithFormat:@"    <%@ xmlns=\"http://tempuri.org/\">\n",name];
    
    envelopeText =[envelopeText stringByAppendingString:format];
    
    for(int i = 0;i<elements.count;i++){
        format = [NSString stringWithFormat:@"      <%@>%@</%@>\n",elements[i],values[i],elements[i]];
        envelopeText =[envelopeText stringByAppendingString:format];
    }
    
    format = [NSString stringWithFormat:@"    </%@>\n",name];
    envelopeText =[envelopeText stringByAppendingString:format];
    envelopeText =[envelopeText stringByAppendingString:@"  </soap12:Body>\n"
                   "</soap12:Envelope>"];
    
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url=@"http://www.softwaremerchant.com/OnlineCourse.asmx";
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelope];
    [request setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d",[envelope length]] forHTTPHeaderField:@"Content-Length"];

    NSData *responseData;
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",responseText);
    
    NSXMLParser *parser= [[NSXMLParser alloc]initWithData:responseData];
    parser.delegate = self;
    [parser parse];
    return result;
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
    currentElementValue = @"";
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    currentElementValue = [currentElementValue stringByAppendingString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if(result[elementName] == nil){
        NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:currentElementValue, nil];
        [result setObject:array forKey:elementName];
    }
    else{
        [result[elementName] addObject:currentElementValue];
    }
}


@end
