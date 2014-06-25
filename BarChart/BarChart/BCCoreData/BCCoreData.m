//
//  BCCoreData.m
//  BarChart
//
//  Created by 김지선 on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BCCoreData.h"
#import "Utility.h"

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
        [self managedObjectModel];
        [self managedObjectContext];
        [self persistentStoreCoordinator];
    }
    return self;
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
        else
        {
            NSLog(@"saveContext : Save Context Has Changes %@", [managedObjectContext userInfo]);
        }
    }
}

- (void)cleanUpCoreData
{
    
    NSError *error = nil;
    NSArray *stores = [_persistentStoreCoordinator persistentStores];
    
    for (NSPersistentStore *store in stores)
    {
        [_persistentStoreCoordinator removePersistentStore:store error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:&error];
    }
    
    NSLog(@"Core Data, Clean up... error : %@", error);
    
    [self managedObjectContext];
    [self managedObjectModel];
    [self persistentStoreCoordinator];
    
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
