## docker pull jcrodriguez1989/rco


## docker run jcrodriguez1989/rco


## docker run -e RCO_PKG=rflights jcrodriguez1989/rco


## # Replace DEST_FOLDER path, with your desired output path

## DEST_FOLDER=/tmp/rco_dock_res

## docker run -v $DEST_FOLDER:/rco_results jcrodriguez1989/rco


## docker run -e RCO_PKG=rflights -v $DEST_FOLDER:/rco_results jcrodriguez1989/rco


## ls $DEST_FOLDER

## ## rflights  rflights_0.1.0.tar.gz  rflights_opt

