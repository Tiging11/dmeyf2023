### -------------------------------------------------------------------------------------
###                           CÓDIGO PRINCIPAL
### -------------------------------------------------------------------------------------

# Cargo el dataset con las variables modificadas: 
dataset <- fread("./datasets/feature_eng/competencia_01_FE_5.csv")

dtrain <- dataset[foto_mes == 202103] # defino donde voy a entrenar
dapply <- dataset[foto_mes == 202105] # defino donde voy a aplicar el modelo

# genero el modelo,  aqui se construye el arbol
# quiero predecir clase_ternaria a partir de el resto de las variables
modelo <- rpart(
        formula = "clase_ternaria ~ .",
        data = dtrain, # los datos donde voy a entrenar
        xval = 0,
        cp = -0.5, # esto significa no limitar la complejidad de los splits
        minsplit = 800, # minima cantidad de registros para que se haga el split
        minbucket = 100, # tamaño minimo de una hoja
        maxdepth = 8 # profundidad maxima del arbol
) 

# grafico el arbol
prp(modelo,
        extra = 101, digits = -5,
        branch = 1, type = 4, varlen = 0, faclen = 0
)


# aplico el modelo a los datos nuevos
prediccion <- predict(
        object = modelo,
        newdata = dapply,
        type = "prob"
) 

prediccion

# prediccion es una matriz con TRES columnas,
# llamadas "BAJA+1", "BAJA+2"  y "CONTINUA"
# cada columna es el vector de probabilidades

# agrego a dapply una columna nueva que es la probabilidad de BAJA+2
dapply[, prob_baja2 := prediccion[, "BAJA+2"]]

# solo le envio estimulo a los registros
#  con probabilidad de BAJA+2 mayor  a  1/40
dapply[, Predicted := as.numeric(prob_baja2 > 1 / 33)]  # Se puede variar el punto de corte (originalmente en 1/40)
                                                        # para enviar menos o más casos positivos a Kaggle
table(dapply$Predicted) #Para ver cuántos 0 y 1 tengo

# genero el archivo para Kaggle
# primero creo la carpeta donde va el experimento
dir.create("./exp/")
dir.create("./exp/KA2001") # cambio el nombre del archivo para no perder los anteriores

# solo los campos para Kaggle
fwrite(dapply[, list(numero_de_cliente, Predicted)],
        file = "./exp/KA2001/K101_001_FE_11.csv",
        sep = ","
)



