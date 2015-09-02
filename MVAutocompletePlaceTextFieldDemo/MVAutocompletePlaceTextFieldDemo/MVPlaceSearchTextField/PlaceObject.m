//
//  PlaceObject.m
//  PlaceSearchAPIDEMO
//
//  Created by Mrugrajsinh Vansadia on 25/04/14.
//  Copyright (c) 2014 Mrugrajsinh Vansadia. All rights reserved.
//

#import "PlaceObject.h"
@interface PlaceObject ()
@property (strong) NSString *placeName;
@end

@implementation PlaceObject
-(id)initWithPlaceName:(NSString *)name{
    self = [super init];
    if (self) {
        [self setPlaceName:name];
    }
    return self;
}
-(id)initWithPlaceId:(NSString *)identifier andName:(NSString *)name{
    self = [super init];
    if (self) {
        [self setPlaceID:identifier];
        [self setPlaceName:name];
    }
    return self;
}

-(NSString *)autocompleteString{
    return self.placeName;
}
-(void)getGMSPlaceByCallback:(MVPlaceObjectCallback)callback {
    [[[GMSPlacesClient alloc] init] lookUpPlaceID:self.placeID callback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        callback(place);
    }];
}


@end
