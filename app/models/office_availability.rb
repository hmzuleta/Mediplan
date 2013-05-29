class OfficeAvailability < ActiveRecord::Base

  #una oficina tiene tambien un dia,hora y lugar en los cuales prestará sus servicios a el hospital
  #no se puede poner disponibilidad total debido a labores de mantenimiento y demas de la sala
  #NO ESCRIBIR ACCESSOR
  attr_accessible :day,:hour,:location
end