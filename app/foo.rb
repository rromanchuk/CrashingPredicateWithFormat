# @property (nonatomic, retain) NSNumber * boolFlag;
# @property (nonatomic, retain) NSNumber * someIdentifier;
# @property (nonatomic, retain) NSString * someString;

class Foo
  
  def self.doSomething(context)
    childContext = NSManagedObjectContext.alloc.initWithConcurrencyType(NSPrivateQueueConcurrencyType)
    childContext.parentContext = context
    
    objects = []
    objects << {boolFlag: true, someIdentifier: 83748, someString: "some string"}
    objects << {boolFlag: true, someIdentifier: 3423, someString: "some strjdfkljdsfing"}
    objects << {boolFlag: true, someIdentifier: 83443748, someString: "jsdfljjsdkf string"}
    objects << {boolFlag: false, someIdentifier: 802347, someString: "some dsif"}
    objects << {boolFlag: false, someIdentifier: 74982374932, someString: "jfsdlkf string"}


    childContext.performBlock(lambda {
      fooEntities = []
      objects.each do |object|
        fooEntities << entityWithRestModel(object, childContext)
      end
      childContext.save(nil)
    })
  end
  
  def self.doSomething2(context)
    request = NSFetchRequest.alloc.init
    request.entity = NSEntityDescription.entityForName(self.name, inManagedObjectContext:context)
    request.predicate = NSPredicate.predicateWithFormat("boolFlag == %@", true)
    request.includesSubentities = false
    
    results = context.executeFetchRequest(request, error:nil)
    results
  end
  
  def self.entityWithRestModel(restModel, context)
  
    request = NSFetchRequest.alloc.init
    request.entity = NSEntityDescription.entityForName(self.name, inManagedObjectContext:context)
    request.predicate = NSPredicate.predicateWithFormat("#{lookupProperty} == %@", restModel[restModelLookupValue])
    
    error_ptr = Pointer.new(:object)
    data = context.executeFetchRequest(request, error:error_ptr)
    _entity = nil

    if data == nil

    elsif data.length == 0
      self.newEntity(context) do |entity|
        _entity = entity.updateEntityWithRestModel(restModel)
      end
    else
      entity = data.lastObject
      _entity = entity.updateEntityWithRestModel(restModel)
    end
    _entity
  end
  
  def self.lookupProperty
    'boolFlag'
  end

  def self.restModelLookupValue
    :boolFlag
  end
  
  def self.newEntity(context)
    yield NSEntityDescription.insertNewObjectForEntityForName(self.name, inManagedObjectContext:context)
  end
  
  def updateEntityWithRestModel(restModel)
    puts "Updating with #{restModel}"
    self.boolFlag             = restModel[:boolFlag]
    self.someIdentifier       = restModel[:someIdentifier]
    self.someString           = restModel[:someString]
    
    self
  end
  
end