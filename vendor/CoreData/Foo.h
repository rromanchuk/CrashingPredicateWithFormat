//
//  Foo.h
//  CrashingPredicateWithFormat
//
//  Created by Ryan Romanchuk on 7/2/14.
//  Copyright (c) 2014 Ryan Romanchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Foo : NSManagedObject

@property (nonatomic, retain) NSNumber * boolFlag;
@property (nonatomic, retain) NSNumber * someIdentifier;
@property (nonatomic, retain) NSString * someString;

@end
