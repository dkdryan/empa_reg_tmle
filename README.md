# Applying targeted maximum likelihood estimation and machine learning methods for the generation of real-world evidence: key considerations from a trial emulation using electronic health record data

David K Ryan<sup>1\*</sup>, Karla Diaz-Ordaz<sup>2</sup>, Patrick Bidulka<sup>3</sup>, R Thomas Lumbers<sup>1</sup>, Anoop D Shah<sup>1,4</sup>, Elizabeth Williamson<sup>5\*\*</sup>, Ruth H Keogh<sup>5\*\*</sup>

## Affiliations

1. Institute of Health Informatics, University College London, UK.
2. Department of Statistical Science, University College London, UK.
3. Department of Health Services Research and Policy, London School of Hygiene & Tropical Medicine, UK.
4. National Institute for Health and Care Research, University College London Hospitals Biomedical Research Centre, UK.
5. Medical Statistics Department, London School of Hygiene and Tropical Medicine, UK.

**\* Corresponding author:** David K Ryan — [smgxdry@ucl.ac.uk](mailto:smgxdry@ucl.ac.uk)

**\*\* Elizabeth Williamson and Ruth H Keogh are joint last authors.**

## Repository overview

This repository contains R code for estimating the effect of initiating empagliflozin versus DPP-4 inhibitors on 3-year all-cause mortality using UK primary care electronic health record data.

The analyses include:

- **Singly robust methods:** g-computation (standardisation) using Cox outcome models and inverse-probability of treatment weighting (IPTW) using weighted Cox models.
- **Discrete-time targeted maximum likelihood estimation (TMLE)** using the `lmtp` R package.

