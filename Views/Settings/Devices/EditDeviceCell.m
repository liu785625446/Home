//
//  EditDeviceCell.m
//  Home
//
//  Created by 刘军林 on 14-5-8.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EditDeviceCell.h"
#import "DeviceResource.h"
#import "EntityLine.h"

@implementation DeviceImgCell

@synthesize deviceName;
@synthesize deviceImg;

-(void) setEntity:(Entity *)entity
{
    _entity = entity;
    DeviceResource *resource = [DeviceResource objectForIndex:_entity.icon];
    [self.deviceImg setImage:[UIImage imageNamed:[DeviceResource getDefaultImage:_entity.icon]]];
    self.deviceName.text = resource.device_name;
}

@end


@implementation DeviceEditTitleCell

@synthesize deviceName;
@synthesize updateBut;

-(void) setEntity:(BaseModel *)entity
{
    _entity = entity;
    
    if ([entity isKindOfClass:[Entity class]]) {
        self.deviceName.text = ((Entity *)_entity).entityName;
    }else if ([entity isKindOfClass:[EntityLine class]]) {
        self.deviceName.text = ((EntityLine *)_entity).entityLineName;
    }
    [self.updateBut setImage:[UIImage imageNamed:@"icon_editorsave.png"]
                    forState:UIControlStateSelected];
}

@end


@implementation DeviceEditImgCell

@synthesize deviceImg;

-(void) setEntityLine:(EntityLine *)entityLine
{
    _entityLine = entityLine;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.deviceImg.image = [UIImage imageNamed:[DeviceResource getDefaultImage:entityLine.icon]];
}

@end


@implementation StartLinkCell

@synthesize startLinkBut;

-(void) setEntity:(Entity *)entity
{
    _entity = entity;
    if (_entity.link == 0) {
        [self.startLinkBut setOn:YES];
    }else{
        [self.startLinkBut setOn:NO];
    }
}

@end

@implementation RemoteCell

@synthesize remote_Img;
@synthesize remote_Name;

-(void) setEntityRemote:(EntityRemote *)entityRemote
{
    _entityRemote = entityRemote;
    self.remote_Img.image = [UIImage imageNamed:[DeviceResource getDefaultImage:_entityRemote.entityRemoteIcon]];
    self.remote_Name.text = _entityRemote.entityRemoteName;
}

@end

