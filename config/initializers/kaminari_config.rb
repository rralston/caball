Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
  # config.default_per_page = 25
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  
  if defined?(WillPaginate)
    module WillPaginate
      module ActiveRecord
        module RelationMethods
          def per(value = nil) per_page(value) end
          def total_count() count end
        end
      end
      module CollectionMethods
        alias_method :num_pages, :total_pages
      end
    end
  end
end