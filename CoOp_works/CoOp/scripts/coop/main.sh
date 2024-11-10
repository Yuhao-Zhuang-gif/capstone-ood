#!/bin/bash

# custom config
DATA=../../DATA 
TRAINER=CoOp

# bash command positions:
DATASET=$1
CFG=$2  # config file .yaml
CTP=$3  # class token position (end or middle)
NCTX=$4  # number of context tokens for each class
SHOTS=$5  # number of shots (1, 2, 4, 8, 16), pictures for each class
CSC=$6  # class-specific context (False or True), the other one is unified context

for SEED in 1 2 3
do
    DIR=output/${DATASET}/${TRAINER}/${CFG}_${SHOTS}shots/nctx${NCTX}_csc${CSC}_ctp${CTP}/seed${SEED} # ouput dir
    if [ -d "$DIR" ]; then
        echo "Oops! The results exist at ${DIR} (so skip this job)"
    else
        python train.py \
        --root ${DATA} \
        --seed ${SEED} \
        --trainer ${TRAINER} \
        --dataset-config-file configs/datasets/${DATASET}.yaml \
        --config-file configs/trainers/${TRAINER}/${CFG}.yaml \
        --output-dir ${DIR} \
        TRAINER.COOP.N_CTX ${NCTX} \
        TRAINER.COOP.CSC ${CSC} \
        TRAINER.COOP.CLASS_TOKEN_POSITION ${CTP} \
        DATASET.NUM_SHOTS ${SHOTS}
    fi
done
