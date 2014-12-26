//
//  AssetInfoDTO.h
//  VeriScanQR
//
//  Created by Adnan Ahmad on 13/04/2013.
//  Copyright (c) 2013 Adnan Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetInfoDTO : BaseDTO

@property (nonatomic,retain) NSString *photo;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *scannedDate;
@property (nonatomic,retain) NSString *empID;
@property (nonatomic,retain) NSString *serialNumber;

@property (nonatomic,retain) NSString *street;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *state;
@property (nonatomic,retain) NSString *postalCode;
@property (nonatomic,retain) NSString *country;
@property (nonatomic,retain) NSString *assetID;

@property (nonatomic,retain) NSString *latitude;
@property (nonatomic,retain) NSString *longitude;
@property (nonatomic,retain) NSString *fullName;

+(id)initWithAsset:(NSDictionary *)dict;

@end
