class Documento < ActiveRecord::Base
	belongs_to :tipo
	belongs_to :area
end
