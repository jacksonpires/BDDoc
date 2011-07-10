class Tipo < ActiveRecord::Base
	has_many :documentos
	validates_uniqueness_of :tipodescricao
end
