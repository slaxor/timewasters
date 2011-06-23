class Object
  def superclasses(classes = [])
    superclass.superclasses(classes << superclass) if superclass
    classes
  end
end


