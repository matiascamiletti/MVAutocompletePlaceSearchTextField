//
//  MVPlaceSearchTextField.m
//  PlaceSearchAPIDEMO
//
//  Created by Mrugrajsinh Vansadia on 26/04/14.
//  Copyright (c) 2014 Mrugrajsinh Vansadia. All rights reserved.
//

#import "MVPlaceSearchTextField.h"
//#import "Macro.h"
#import "PlaceObject.h"
#import "MLPAutoCompleteTextField.h"
@import GoogleMaps;

@interface MVPlaceSearchTextField ()<MLPAutoCompleteFetchOperationDelegate,MLPAutoCompleteSortOperationDelegate,MLPAutoCompleteTextFieldDataSource,MLPAutoCompleteTextFieldDelegate>

@end


@implementation MVPlaceSearchTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/



-(void)awakeFromNib{

    self.autoCompleteDataSource=self;
    self.autoCompleteDelegate=self;
    self.autoCompleteFontSize=14;
    self.autoCompleteTableBorderWidth=0.0;
    self.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=NO;
    self.autoCompleteShouldHideOnSelection=YES;
    self.maximumNumberOfAutoCompleteRows= 5;
    self.autoCompleteShouldHideClosingKeyboard = YES;

    
}
#pragma mark - Datasource Autocomplete
//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
        NSString *aQuery = textField.text;
        
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
        
        [[[GMSPlacesClient alloc] init] autocompleteQuery:aQuery
                                                   bounds:nil
                                                   filter:filter
                                                 callback:^(NSArray *results, NSError *error) {
                                                     if (error != nil) {
                                                         NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                                         return;
                                                     }
                                                    
                                                     NSMutableArray *arrfinal = [NSMutableArray array];
                                                     for (GMSAutocompletePrediction* result in results) {
                                                         //NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
                                                         PlaceObject * placeObj = [[PlaceObject alloc] initWithPlaceId:result.placeID andName:result.attributedFullText.string];
                                                         [arrfinal addObject:placeObj];
                                                     }
                                                     if([arrfinal count] > 0){
                                                         handler(arrfinal);
                                                     }else{
                                                         handler(nil);
                                                     }
        }];
}


#pragma mark - AutoComplete Delegates
-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didSelectAutoCompleteString:(NSString *)selectedString withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlaceObject *placeObj=(PlaceObject*)selectedObject;
    [self placeDetailForReferance:placeObj.placeID didFinishWithResult:placeObj];
    
}
-(BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
         shouldConfigureCell:(UITableViewCell *)cell
      withAutoCompleteString:(NSString *)autocompleteString
        withAttributedString:(NSAttributedString *)boldedString
       forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
           forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_placeSearchDelegate respondsToSelector:@selector(placeSearchResultCell:withPlaceObject:atIndex:)]){
        [_placeSearchDelegate placeSearchResultCell:cell withPlaceObject:autocompleteObject atIndex:indexPath.row];
    }else{
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    return YES;
}

-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView{
    if([_placeSearchDelegate respondsToSelector:@selector(placeSearchWillShowResult)]){
        [_placeSearchDelegate placeSearchWillShowResult];
    }
}
-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willHideAutoCompleteTableView:(UITableView *)autoCompleteTableView{
    if([_placeSearchDelegate respondsToSelector:@selector(placeSearchWillHideResult)]){
        [_placeSearchDelegate placeSearchWillHideResult];
    }
}


#pragma mark - PlaceDetail Delegate

-(void)placeDetailForReferance:(NSString *)referance didFinishWithResult:(PlaceObject *)resultDict{
    //dispatch_sync(dispatch_get_main_queue(), ^{
        //Respond To Delegate
        [_placeSearchDelegate placeSearchResponseForSelectedPlace:resultDict];
    //});
}


#pragma mark - URL Operation
- (NSDictionary *)stringWithUrl:(NSURL *)url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    if(urlData){
        // Construct a Dictionary around the Data from the response
        NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&error];
        return aDict;
    }else{return nil;}
    
}



@end
