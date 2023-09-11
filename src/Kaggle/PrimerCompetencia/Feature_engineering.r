### -------------------------------------------------------------------------------------
###                                 FEATURE ENGINEERING
### -------------------------------------------------------------------------------------

# Arbol elemental con libreria  rpart
# Debe tener instaladas las librerias  data.table  ,  rpart  y  rpart.plot

# cargo las librerias que necesito
require("data.table")
require("rpart")
require("rpart.plot")

# Aqui se debe poner la carpeta de la materia de SU computadora local
setwd("C:/Users/tgian/DMEyF") # Establezco el Working Directory

# cargo el dataset
dataset <- fread("./datasets/competencia_01.csv")


# Creo la columna de mtarjeta_consumo_total con la suma de los montos de consumos de Visa y Master:
dataset$mtarjeta_consumo_TOTAL = dataset$mtarjeta_visa_consumo + dataset$mtarjeta_master_consumo
# Dropeo las columnas sumadas:
dataset = subset(dataset, select = -c(mtarjeta_visa_consumo,mtarjeta_master_consumo) )


# Creo las columnas de tarjeta_rate como el cociente entre el monto de consumo de la tarjeta y el límite de compra:
dataset$tarjeta_visa_rate = dataset$mtarjeta_visa_consumo/dataset$Visa_mlimitecompra
dataset$tarjeta_master_rate = dataset$mtarjeta_master_consumo/dataset$Master_mlimitecompra


# Descargo csv:
write.csv(dataset, file = "competencia_01_FE_11.csv", row.names = FALSE) # Lo renombré a FE_5 para estar seguro de que es el último que usé.

### -------------------------------------------------------------------------------------