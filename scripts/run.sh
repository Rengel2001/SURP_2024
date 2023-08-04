#!/bin/bash

PS3='Please enter your choice: '
options=("Run Galactica"
		 "Run LLaMA"
		 "Run Alpaca"
		 "Run RST"
		 "Run BioGPT"
		 "Run BioMedLM"
		 "Quit")
select opt in "${options[@]}"
do
	case $opt in
		"Run Galactica")
			echo "you chose Run Galactica."

			export MODEL_NAME=Galactica
			export MODEL_TYPE=standard

			# Prompt type selection
			PS3='Choose the type of prompts: '
			prompt_options=("Trained Prompts" "Manual Prompts")
			select prompt_opt in "${prompt_options[@]}"
			do
				case $prompt_opt in
					"Trained Prompts")
						echo "you chose to use Trained Prompts"
						export PROMPT_TYPE="trained"
						break
						;;
					"Manual Prompts")
						echo "you chose to use Manual Prompts"
						export PROMPT_TYPE="manual"
						break
						;;
					*) echo "invalid option $REPLY";;
				esac
			done

			export DATA_REPO_PATH=~/data
			export OUTPUT_DIR=~/result
			export DATA_NAME=string # string, kegg, indra
			export TASK=entity # entity, relation, entity_relation, relation_type
			export TEST_SAMPLE_SIZE=1000 # -1 means all data
			export KEGG_DATA_TYPE=low-dose # low-dose, high-dose
			export NUM_OF_INDRA_CLASSES=2
			export BATCH_SIZE=32
			export N_SHOTS=1
			
			srun -p voltadebug -A student-v -t 4:00:00 -N 1 --gres=gpu:2 --qos=volta -J    llm \
			python ~/src/run_model.py \
                --model_name $MODEL_NAME \
                --model_type $MODEL_TYPE \
                --data_repo_path $DATA_REPO_PATH \
                --output_dir $OUTPUT_DIR \
                --data_name $DATA_NAME \
                --task $TASK \
				--test_sample_size $TEST_SAMPLE_SIZE \
				--kegg_data_type $KEGG_DATA_TYPE \
				--num_of_indra_classes $NUM_OF_INDRA_CLASSES \
                --batch_size $BATCH_SIZE \
                --n_shots $N_SHOTS \
				--prompt_type $PROMPT_TYPE
			
			: '
				--parallelizm
			'
			
			break
			;;
		"Run LLaMA")
			echo "you chose Run LLaMA."
			
			export MODEL_NAME=LLaMA
			export MODEL_TYPE=/scratch/ac.gpark/LLaMA_HF/7B
			export DATA_REPO_PATH=~/BioIE-LLM/data
			export OUTPUT_DIR=~/BioIE-LLM/result
			export DATA_NAME=string # string, kegg, indra
			export TASK=entity_relation # entity, relation, entity_relation, relation_type
			export TEST_SAMPLE_SIZE=500 # -1 means all data
			export KEGG_DATA_TYPE=low-dose # low-dose, high-dose
			export NUM_OF_INDRA_CLASSES=4
			export BATCH_SIZE=32
			export N_SHOTS=2

			python ~/BioIE-LLM/src/run_model.py \
                --model_name $MODEL_NAME \
                --model_type $MODEL_TYPE \
                --data_repo_path $DATA_REPO_PATH \
                --output_dir $OUTPUT_DIR \
                --data_name $DATA_NAME \
                --task $TASK \
				--test_sample_size $TEST_SAMPLE_SIZE \
				--kegg_data_type $KEGG_DATA_TYPE \
				--num_of_indra_classes $NUM_OF_INDRA_CLASSES \
                --batch_size $BATCH_SIZE \
                --n_shots $N_SHOTS
				
			break
			;;
		"Run Alpaca")
			echo "you chose Run Alpaca."
			
			export MODEL_NAME=Alpaca
			export MODEL_TYPE=/scratch/ac.gpark/LLaMA_HF/7B # decapoda-research/llama-7b-hf
			export LORA_WEIGHTS=tloen/alpaca-lora-7b
			export DATA_REPO_PATH=~/BioIE-LLM/data
			export OUTPUT_DIR=~/BioIE-LLM/result
			export DATA_NAME=indra # string, kegg, indra
			export TASK=relation_type # entity, relation, entity_relation, relation_type
			export TEST_SAMPLE_SIZE=1000 # -1 means all data
			export KEGG_DATA_TYPE=low-dose # low-dose, high-dose
			export NUM_OF_INDRA_CLASSES=6
			export BATCH_SIZE=8
			export N_SHOTS=2

			python ~/BioIE-LLM/src/run_model.py \
                --model_name $MODEL_NAME \
                --model_type $MODEL_TYPE \
				--lora_weights $LORA_WEIGHTS \
                --data_repo_path $DATA_REPO_PATH \
                --output_dir $OUTPUT_DIR \
                --data_name $DATA_NAME \
                --task $TASK \
                --test_sample_size $TEST_SAMPLE_SIZE \
				--kegg_data_type $KEGG_DATA_TYPE \
				--num_of_indra_classes $NUM_OF_INDRA_CLASSES \
                --batch_size $BATCH_SIZE \
                --n_shots $N_SHOTS
			
			: '
				--load_8bit
			'
			
			break
			;;
		"Run RST")
			echo "you chose Run RST."
			
			export MODEL_NAME=RST
			export MODEL_TYPE=XLab/rst-all-11b
			export DATA_REPO_PATH=~/BioIE-LLM/data
			export OUTPUT_DIR=~/BioIE-LLM/result
			export DATA_NAME=indra # string, kegg, indra
			export TASK=relation_type # entity, relation, entity_relation, relation_type
			export TEST_SAMPLE_SIZE=1000 # -1 means all data
			export KEGG_DATA_TYPE=low-dose # low-dose, high-dose
			export NUM_OF_INDRA_CLASSES=2
			export BATCH_SIZE=8
			export N_SHOTS=0

			python ~/BioIE-LLM/src/run_model.py \
                --model_name $MODEL_NAME \
                --model_type $MODEL_TYPE \
                --data_repo_path $DATA_REPO_PATH \
                --output_dir $OUTPUT_DIR \
                --data_name $DATA_NAME \
                --task $TASK \
                --test_sample_size $TEST_SAMPLE_SIZE \
				--kegg_data_type $KEGG_DATA_TYPE \
				--num_of_indra_classes $NUM_OF_INDRA_CLASSES \
                --batch_size $BATCH_SIZE \
                --n_shots $N_SHOTS
				
			break
			;;
		"Run BioGPT")
			echo "you chose Run BioGPT."
			
			export MODEL_NAME=BioGPT
			export MODEL_TYPE=microsoft/BioGPT-Large # microsoft/biogpt, microsoft/BioGPT-Large, microsoft/BioGPT-Large-PubMedQA
			export DATA_REPO_PATH=~/BioIE-LLM/data
			export OUTPUT_DIR=~/BioIE-LLM/result
			export DATA_NAME=kegg # string, kegg, indra
			export TASK=entity_relation # entity, relation, entity_relation, relation_type
			export TEST_SAMPLE_SIZE=1000 # -1 means all data
			export KEGG_DATA_TYPE=low-dose # low-dose, high-dose
			export NUM_OF_INDRA_CLASSES=4
			export BATCH_SIZE=64
			export N_SHOTS=0

			python ~/BioIE-LLM/src/run_model.py \
                --model_name $MODEL_NAME \
                --model_type $MODEL_TYPE \
                --data_repo_path $DATA_REPO_PATH \
                --output_dir $OUTPUT_DIR \
                --data_name $DATA_NAME \
                --task $TASK \
                --test_sample_size $TEST_SAMPLE_SIZE \
				--kegg_data_type $KEGG_DATA_TYPE \
				--num_of_indra_classes $NUM_OF_INDRA_CLASSES \
                --batch_size $BATCH_SIZE \
                --n_shots $N_SHOTS
				
			break
			;;
		"Run BioMedLM")
			echo "you chose Run BioMedLM."
			
			export MODEL_NAME=BioMedLM
			export MODEL_TYPE=stanford-crfm/BioMedLM
			export DATA_REPO_PATH=~/BioIE-LLM/data
			export OUTPUT_DIR=~/BioIE-LLM/result
			export DATA_NAME=indra # string, kegg, indra
			export TASK=relation_type # entity, relation, entity_relation, relation_type
			export TEST_SAMPLE_SIZE=1000 # -1 means all data
			export KEGG_DATA_TYPE=low-dose # low-dose, high-dose
			export NUM_OF_INDRA_CLASSES=3
			export BATCH_SIZE=4
			export N_SHOTS=0

			python ~/BioIE-LLM/src/run_model.py \
                --model_name $MODEL_NAME \
                --model_type $MODEL_TYPE \
                --data_repo_path $DATA_REPO_PATH \
                --output_dir $OUTPUT_DIR \
                --data_name $DATA_NAME \
                --task $TASK \
                --test_sample_size $TEST_SAMPLE_SIZE \
				--kegg_data_type $KEGG_DATA_TYPE \
				--num_of_indra_classes $NUM_OF_INDRA_CLASSES \
                --batch_size $BATCH_SIZE \
                --n_shots $N_SHOTS
				
			break
			;;
		"Quit")
			break
			;;
		*) echo "invalid option $REPLY";;
	esac
done