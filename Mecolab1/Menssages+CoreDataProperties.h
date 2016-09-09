//
//  Menssages+CoreDataProperties.h
//  Mecolab1
//
//  Created by rene Acuña Hernández on 27-06-16.
//  Copyright © 2016 rene Acuña Hernández. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Menssages.h"

NS_ASSUME_NONNULL_BEGIN

@interface Menssages (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *contenido;
@property (nullable, nonatomic, retain) NSNumber *tipo;
@property (nullable, nonatomic, retain) NSString *number;

@end

NS_ASSUME_NONNULL_END
