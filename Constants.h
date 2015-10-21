//
//  Constants.h
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/20/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark colors

#define MAX_MOVE_DISTANCE      30
#define MAP_RADIUS             300

#define orangeColor 0xB67A4E
#define pinColor    0xFDA235

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SHOW_POSITION_DETAILS_SEGUE       @"showDetails"

#pragma mark foursquare settings
#define F_CLIENTID      @"H0P14LNJPRDR4EPS5T4MBX2WHJG2ZG4EPL1SCO3KNI3F0S2I"
#define F_CLIENTSECRET  @"QEEYQWXORG1INP2GCHSXZPYMJXVODMXILN43RMSSHEACHOTL"

#pragma mark web_links
#define BASE_URL        @"https://api.foursquare.com"
#define SEARCH_URL      @"/v2/venues/search"
#define SEARCH_KEYPASS  @"response.venues"

#endif /* Constants_h */
