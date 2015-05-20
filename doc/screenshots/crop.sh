#!/bin/bash

for i in adminPanel.PNG correctPerLevel.PNG presentationsPerLevel.PNG reactionTime.PNG reversals.PNG viewlog.PNG
do
    b=`basename $i .PNG`
    convert $i -crop 1070x1200+485+170 $b"Crop.png"
done
