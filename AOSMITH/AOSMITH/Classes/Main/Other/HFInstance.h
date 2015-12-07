//
//  HFInstance.h
//  HangingFurnace
//
//  Created by 李晓 on 15/9/10.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

// 设备的工作模式定义
typedef enum {
    heating_fun,      // 采暖
    hotwater_fun,    //  热水
}deviceFunction;


// 采暖方式
typedef enum {
    heating_radiator,   // 暖气片采暖
    heating_floor,     //  地暖采暖
}heatingState;


// 设备正在运行的模式
typedef enum {
    ceaseless_run,      // 无定时模式
    business_one,      //商务模式1
    business_two,     //商务模式2
    economy,         //经济模式
    custom,         //自定义模式
}heatingDeviceModel;


typedef enum {
    convention,   //常规模式
    comfortable, //舒适模式
}hotwaterDeviceModel;


@interface HFInstance : NSObject
//LXSingletonH(HFInstance)

/**
 *  当前选择的是“取暖”还是“热水”
 */
@property (nonatomic,assign) deviceFunction deviceFunState;
/**
 *  当前选择的供暖方式
 */
@property (nonatomic,assign) heatingState heatingState;

/**
 *  设备不同功能下所选择的过的模式，用于切换模式使用
 */
@property (nonatomic,assign) heatingDeviceModel heating_select_model;
@property (nonatomic,assign) hotwaterDeviceModel hotwater_select_model;

/**
 *  不同功能下的不同模式的默认温度
 */
@property (nonatomic,assign) NSInteger defaultTem;
/**
 *  不同模式下的温度范围
 */
@property (nonatomic,strong) NSArray *tRange;


//------------------------------------------------------------------------

/**
 *  采暖------散热器片的温度 Array
 */
@property (nonatomic,strong) NSMutableArray *heating_radiator;
/**
 *  采暖------地暖温度 Array
 */
@property (nonatomic,strong) NSMutableArray *heating_floor;
/**
 *  采暖------设备模式选择 Array
 */
@property (nonatomic,strong) NSArray *deviceHeatingModelArray;
/**
 *  采暖------设备模时间段 Array
 */
@property (nonatomic,strong) NSMutableArray *deviceHeatingDateArray;



/**
 *  热水------常规温度 Array
 */
@property (nonatomic,strong) NSMutableArray *hotwater_convention;
/**
 *  热水------舒适温度 Array
 */
@property (nonatomic,strong) NSMutableArray *hotwater_comfortable;
/**
 *  热水------设备模式选择 Array
 */
@property (nonatomic,strong) NSArray *deviceHotwaterModelArray;

@end
