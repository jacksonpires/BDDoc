class Area < ActiveRecord::Base
	has_many :documentos
	validates_uniqueness_of :areadescricao
end
