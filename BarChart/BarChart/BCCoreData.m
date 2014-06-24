//
//  BCCoreData.m
//  BarChart
//
//  Created by 김지선 on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BCCoreData.h"

static NSString *RESOURCE_URL = @"BarChart";
static NSString *SQLITE_FILE_NAME = @"BarChartData.sqlite";

static NSString *ENTITY_PRODUCT = @"Product";
static NSString *ENTITY_SALES = @"Sales";

@implementation BCCoreData

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - CoreData
+ (BCCoreData *)sharedInstance
{
    static BCCoreData *_instance;
    static dispatch_once_t initCoreDataOnce;
    if (!_instance)
    {
        dispatch_once(&initCoreDataOnce, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

- (id)init
{
    if(self = [super init])
    {
        [self managedObjectContext];
        [self managedObjectModel];
        [self persistentStoreCoordinator];
    }
    return self;
}

#pragma mark - initializingChartData
- (void)initializeChartData
{
    [self saveProductData];
    
}

- (void)saveProductData
{
    NSArray *displayName = @[@"챗온", @"카카오톡", @"페이스북", @"트위터", @"인스타그램", @"마플", @"밴드", @"라인"];
    NSArray *modelName = @[@"ChatOn", @"KaKaoTalk", @"FaceBook", @"Twitter", @"Instagram", @"MyPeople", @"Band", @"Line"];
   
    for(int i = 0; i < 1; i++)
    {
        NSManagedObject *contact = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_PRODUCT
                                                                 inManagedObjectContext:self.managedObjectContext];
        
        [contact setValue:[displayName objectAtIndex:i] forKey:@"displayName"];
        [contact setValue:[modelName objectAtIndex:i] forKey:@"model"];
        [contact setValue:[NSDate date] forKey:@"releaseDate"];
//        [contact setValue:[self returnInitialSalesData] forKey:@"sales"];
        
        [self saveContext];
    }
}

- (NSSet *)returnInitialSalesData
{
    NSMutableArray *arrReturn = [[NSMutableArray alloc] init];
    
    NSInteger maxCount = random() % 500;

    for(int i=0; i< maxCount; i++)
    {
        NSInteger count = random() % 1000;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-mm-dd"];
        
        NSDate *startDay = [formatter dateFromString:@"2014-01-01"];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unitFlags =  NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:startDay];
        
        int r = arc4random() % 364;
        [dateComponents setDay:r];
        NSDate *newDate = [calendar dateFromComponents:dateComponents];
        NSLog(@"i: %d = count/newDate: %d/%@",i, count, newDate);
        
        NSDictionary *dic = @{@"count": [NSNumber numberWithInt:count], @"date": newDate};
        [arrReturn addObject:dic];
        
    }
    
    NSSet *returnSet = [[NSSet alloc] initWithArray:arrReturn];
    
    return returnSet;
    
}

#pragma mark -bcCoreData
-(void)saveContext
{
    NSError *error;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil)
    {
        // 변경 사항이 있지만 저장에 실패한 경우
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // 실제 구현할때 이 부분은 수정해야한다. abort 메소드는 crash를 유발하므로 사용하면 안된다!
            NSLog(@"Unresolved error : %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask]
            lastObject];
}


#pragma mark - property

-(NSManagedObjectModel *)managedObjectModel
{
    //데이터베이스 스키마: 데이터베이스에 저장하는 각각의 객체들을 위한 정의를 담고 있는 클래스
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    //컴파일된 Data Object Model(Xcode상의 .xcdatamodeld)에 접근하여 객체로 생성.
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:RESOURCE_URL withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

-(NSManagedObjectContext *)managedObjectContext
{
    //데이터베이스로부터 나온 객체들을 위한 “임시저장소”: 객체들을 불러올때, 삽입할때, 또는 삭제할때마다 사용한다
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        
        // Persistent Store Coordinator 연결.
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    //데이터베이스 커넥션: 객체들을 저장할 데이터베이스들이 실제로 어떤 이름들을 갖을지, 어떤 위치들에 놓일지를 설정
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
     NSManagedObjectModel *mom = [self managedObjectModel];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
//                                   initWithManagedObjectModel:[self managedObjectModel]];
    
    NSError *error = nil;
    NSURL *documentsDirectory =[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:SQLITE_FILE_NAME];
    
    // 마이그레이션 옵션
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    // Persistent Store Coordinator 설정. 저장소 타입을 SQLite로 한다.
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error])
    {
        // 여기도 마찬가지로 실제 앱 개발시에는 반드시 수정해야한다.
        NSLog(@"Unresolved error : %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
@end