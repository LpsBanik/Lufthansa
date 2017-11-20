//
//  Country.h
//  LufthansaApplication
//
//  Created by Сергей Кохан on 11/2/17.
//  Copyright © 2017 Siarhei Kokhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Country :  NSObject
@property (retain , nonatomic) NSString *countryName;
@property (retain , nonatomic) NSString *countryCode;

- (id) initWithServerResponse : (NSDictionary *) responseObject;

@end



//Дима Плющай подсказал, как пофиксить баги, связанные с созданием базыДанных.
//создавались модельки с пропертями, как-то по бредовому, Дима подсказал их удалить, и создать новые классы и те данные, созданные от CoreData, перекинуть в созданные мной классы
//Я мучился с этим 2-3 дня, ошибка была 401 вроде как.
//Все остальное я черпал из уроков Скутаренко есть группа в VK https://vk.com/iosdevcourse
//Чего толком не было, так это работы с GoogleMaps, Так же ДИма объяснил, что надо установить libs и как установить.
