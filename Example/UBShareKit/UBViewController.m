//
//  UBViewController.m
//  UBShareKit
//
//  Created by crazysiri on 02/12/2020.
//  Copyright (c) 2020 crazysiri. All rights reserved.
//

#import "UBViewController.h"

#import <UBShareKit.h>

#import "Getter.h"

@interface UBViewController ()

@end

@implementation UBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Getter *getter = [[Getter alloc] init];

    UBShareKit *kit = [UBShareKit kitWithGetter:getter];
    [kit show];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
