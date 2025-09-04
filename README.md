# magnetic-nanocultures
MATLAB scripts and data analysis workflows for characterizing microbial growth, motion, and magnetic responsiveness in PDMS-based magnetic nanocultures. 
Developed as part of my PhD dissertation and manuscript on magnetically responsive microbial nanocultures.

## Overview
Magnetic nanocultures are double-emulsion microcapsules with **functionalized PDMS membranes** embedded with magnetic nanoparticles (MNPs).  
This platform enables:
- Encapsulation of environmental or pathogenic microbes in semi-permeable microcapsules  
- Real-time imaging and tracking of microbial growth dynamics  
- Magnetophoretic manipulation and retrieval of capsules from complex environments  
- AI/MATLAB-based quantitative analysis of microbial motility and interactions  

## Contents
- `Tracking/` – MATLAB scripts for particle tracking and velocity analysis  
- `Magnetophoresis/` – scripts for velocity prediction and experimental validation under magnetic fields  
- `GrowthAnalysis/` – codes for fluorescence/microscopy-based growth quantification  
- Example datasets (capsule trajectories, velocity fields)  

## Requirements
- MATLAB R2021a or later  
- Image Processing Toolbox  
- Curve Fitting Toolbox (for some velocity fitting functions)  

## Usage
Clone the repo:
```bash
git clone https://github.com/yourusername/magnetic-nanocultures.git
