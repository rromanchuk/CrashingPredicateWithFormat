class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    puts "application:didFinishLaunchingWithOptions"
    managedObjectContext
    
    Foo.doSomething(managedObjectContext)
    Foo.doSomething2(managedObjectContext)
    true
  end
  
  def managedObjectContext
    @managedObjectContext ||= begin
      coordinator = persistentStoreCoordinator
      if coordinator
          @privateWriterContext = NSManagedObjectContext.alloc.initWithConcurrencyType(NSPrivateQueueConcurrencyType)
          @privateWriterContext.setPersistentStoreCoordinator(coordinator)

          # create main thread MOC
          _managedObjectContext = NSManagedObjectContext.alloc.initWithConcurrencyType(NSMainQueueConcurrencyType)
          _managedObjectContext.parentContext = @privateWriterContext
      end
      _managedObjectContext
    end
  end

  def managedObjectModel
    @managedObjectModel ||= begin
      modelURL = NSBundle.mainBundle.URLForResource("CrashingPredicateWithFormat", withExtension:"momd")
      _managedObjectModel = NSManagedObjectModel.alloc.initWithContentsOfURL(modelURL)
      _managedObjectModel
    end
  end

  # Returns the persistent store coordinator for the application.
  # If the coordinator doesn't already exist, it is created and the application's store added to it.
  def persistentStoreCoordinator
    @persistentStoreCoordinator ||= begin
      storeURL = applicationDocumentsDirectory.URLByAppendingPathComponent("CrashingPredicateWithFormat.sqlite")
      error = Pointer.new(:object)
      _persistentStoreCoordinator = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(managedObjectModel)
      if !_persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:storeURL, options:nil, error:error)
          NSFileManager.defaultManager.removeItemAtURL(storeURL, error:nil)
          _persistentStoreCoordinator = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(managedObjectModel)
          _persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:storeURL, options:nil, error:error)
          puts "Unresolved error #{error}"
      end
      _persistentStoreCoordinator
    end
  end

  def applicationDocumentsDirectory
    NSFileManager.defaultManager.URLsForDirectory(NSDocumentDirectory, inDomains:NSUserDomainMask).lastObject
  end

  def resetCoreData
    storeURL = applicationDocumentsDirectory.URLByAppendingPathComponent("CrashingPredicateWithFormat.sqlite")
    NSFileManager.defaultManager.removeItemAtURL(storeURL, error:nil)
    @persistentStoreCoordinator = nil
    @managedObjectContext = nil
    @managedObjectModel = nil
    @privateWriterContext = nil
  end
end
