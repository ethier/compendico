class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.table_name_prefix
    'compendico_'
  end
end
