//
//  PlaceObject.h
//  PlaceSearchAPIDEMO
//
//  Created by Mrugrajsinh Vansadia on 25/04/14.
//  Copyright (c) 2014 Mrugrajsinh Vansadia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLPAutoCompletionObject.h"
@import GoogleMaps;

typedef void (^MVPlaceObjectCallback)(GMSPlace * place);

@interface PlaceObject : NSObject<MLPAutoCompletionObject>

@property (nonatomic, strong) NSString *placeID;;

- (id)initWithPlaceId:(NSString *)identifier andName:(NSString *)name;
- (id)initWithPlaceName:(NSString *)name;

-(void)getGMSPlaceByCallback:(MVPlaceObjectCallback)callback;

@end
