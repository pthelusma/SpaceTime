//
//  CloudLocation.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/17/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "CloudLocation.h"
#import "Context.h"
#import "Location+Cloud.h"

@implementation CloudLocation

NSMutableData *webData;
NSMutableString *soapResults;
NSURLConnection *conn;

- (id) init
{
    self = [super init];
    
    if(!self.context)
    {
        [Context createContext:^(NSManagedObjectContext *context){
            self.context = context;
        } refresh:^{
            [self refresh];
        }];
    }
    
    return self;
}

- (void) refresh
{
    
}

- (void) fetchLocations
{
    
    NSURL *url = [NSURL URLWithString:@"http://pierrethelusma.com/Services/api/task/GetLocations/"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (conn)
    {
        webData = [NSMutableData data];
    }
}

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response
{
    [webData setLength: 0];
}

-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data
{
    [webData appendData:data];
}

-(void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error
{
    NSLog(@"There was an error!");
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    
    NSLog(@"DONE. Received Bytes: %d",[webData length]);
    
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    
    for(NSDictionary *dictionary in jsonObject)
    {
        [Location createLocation:dictionary context:self.context];
    }
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = nil;
    
    NSError *error = nil;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    
    NSLog(@"Locations: %d", matches.count);
}


@end
