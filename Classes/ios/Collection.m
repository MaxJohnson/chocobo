//
//  Collection.m
//  PetroFeedApp
//
//  Created by Mark on 11/22/2013.
//  Copyright (c) 2013 PetroFeed. All rights reserved.
//

#import "Collection.h"

@implementation Collection

@synthesize models = _models;

-(id)model
{
    NSLog(@"[Collectionb] model: method not overriden.");
    return nil;
}

-(NSMutableArray *)models
{
    if (!_models)
        _models = [[NSMutableArray alloc] init];
    return _models;
}

-(NSString *) collectionEndpoint
{
    NSLog(@"[Collection] collectionEndpoint: method not overriden");
    return nil;
}

-(void)clearModels
{
    [self.models removeAllObjects];
}

-(void) fetchWithParams:(NSDictionary *)params onSuccess:(void (^)(id responseObject))success onFailure:(void (^)(NSError* error))failure
{
    [self clearModels];
    [self getFromEndpoint:[self collectionEndpoint] withParams:params onSuccess:^(id responseObject) {
        NSDictionary *attributes = [responseObject valueForKey:@"rigs"];
        
        for (NSDictionary* key in attributes) {
            
            Class modelFromString = NSClassFromString([self model]);
            id modelObject = [[modelFromString alloc] init];
            
            [modelObject performSelector: NSSelectorFromString(@"updateModelWithJson:") withObject:key];
            
            // add the object to the model group
            [self.models addObject:modelObject];
        }

        success(responseObject);
        
    } onFailure:^(NSError *error) {
        
        failure(error);
        
    }];
}

@end
