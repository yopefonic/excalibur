module Excalibur
  # the Duplicator module helps in making sure duplication of nested objects
  # functions properly and is used by the class Configuration and the class
  # TruncableContent
  module Duplicator
    # duplicates TruncatableContent and calls the deep_dup method on any form
    # of Hash. Otherwise return the object as not all objects do not need to
    # be duplicated.
    def dup_instance(obj)
      if obj.is_a?(TruncateableContent)
        obj.dup
      elsif obj.is_a?(Hash)
        obj.deep_dup
      else
        obj
      end
    end
  end
end
