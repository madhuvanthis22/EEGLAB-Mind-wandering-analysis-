# Mind-Wandering EEG Analysis Pipeline
This repository contains the MATLAB analysis scripts used in my MSc Cognitive Science thesis investigating the relationship between attentional state, mind-wandering, and learning under massed and spaced learning conditions. The study examined neural correlates of attentional engagement and mind-wandering during massed and spaced learning using EEG.
The EEG preprocessing and ICA stages were performed manually in EEGLAB for each participant. The scripts included in this repository correspond to the analysis stage that followed preprocessing and were used to organise trials, create condition-specific datasets, and extract alpha and theta power measures for statistical analysis.

## Overview of the Analysis Pipeline
My analysis workflow consisted of three main stages:
1. Creating attentional-state and learning-condition labels from the continuous EEG recording.
2. Splitting clean epoched EEG datasets into condition-specific datasets.
3. Extracting alpha and theta power measures from predefined electrode clusters for each condition.
The scripts are intended to be run sequentially.

---
## Script 1: continuousfilelabels.m
This script generates trial labels from the continuous EEG recording. During the experiment, participants periodically responded to thought probes indicating whether they were:
* On-task
* Intentionally mind-wandering (IMW)
* Unintentionally mind-wandering (UMW)
The script identifies each probe event and extracts the participant's corresponding response. It also determines whether the probe occurred during a Massed or Spaced learning block.

The output consists of two variables:
* response_labels
* condition_labels
These labels are used throughout the remainder of the analysis pipeline.

---
## Script 2: splitcleanepochedbycondition.m
After preprocessing and epoching, this script uses the labels generated in the previous stage to separate EEG trials into condition-specific datasets.
Trials are divided into six conditions:
* Massed On-task
* Massed IMW
* Massed UMW
* Spaced On-task
* Spaced IMW
* Spaced UMW
Each condition is saved as a separate EEGLAB dataset for further analysis.
For one participant, EEG data from two recording blocks were stored in separate files, unlike all other participants' data. The script therefore also includes a step used to merge the two blocks before condition-based splitting.

---
## Script 3: alphathetapipeline.m
This script extracts alpha and theta power measures from the condition-specific datasets. Power Spectral Density (PSD) is estimated using Welch's method.
The analysis focuses on:
### Theta Power (4–8 Hz)
Electrodes: Fz, FCz
### Alpha Power (8–12 Hz)
Electrodes: Pz, POz

For each condition, power values are extracted from the five-second period preceding the thought probe. The script outputs mean alpha and theta power values along with trial-count information for each participant and condition.

---
## Notes
The preprocessing stage, including filtering, artifact rejection, and ICA-based cleaning, was performed manually within EEGLAB and is therefore not included in this repository. The scripts contained here represent the analysis workflow used after preprocessing and were developed as part of my thesis research.
