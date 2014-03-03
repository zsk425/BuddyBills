//
//  Buddy.m
//  BuddyBills
//
//  Created by zhaosk on 14-3-1.
//  Copyright (c) 2014年 zhaosk. All rights reserved.
//

#import "Buddy.h"
#import "BuddyBill.h"


@implementation Buddy

@dynamic cteated_at;
@dynamic money;
@dynamic name;
@dynamic bills;

- (BOOL)validateForInsert:(NSError **)error
{
    NSLog(@"validateForInsert called");
    
    if (![super validateForInsert:error])
    {
        return NO;
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self.entity name] inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *ped = [NSPredicate predicateWithFormat:@"name == %@",[self valueForKey:@"name"]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:ped];
    
    NSError *aError;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&aError];
    if (count > 1)
    {
        NSLog(@"%d",count);
        *error = [NSError errorWithDomain:NSLocalizedDescriptionKey code:-1 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@已经存在了",[self valueForKey:@"name"] ]}];
        return NO;
    }
    
    return YES;
}

@end
