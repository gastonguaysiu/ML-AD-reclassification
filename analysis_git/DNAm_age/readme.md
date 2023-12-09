
I wrote in the data folder to build boxplots to evaluate my machine learning (ML) model by comparing its classification of Alzheimer's disease (AD) patients with clinical categorizations. Our primary focus was analyzing chronological and DNA methylation (DNAm) age.

**Key Findings and Observations**

Age-Based Classification Analysis: Comparing clinically categorized and ML-classified AD patients. We noted a broader spread in data when patients were categorized by chronological age compared to DNAm age.

Braak Stage Grouping and Age Trends: An interesting observation was that patients in the intermediate Braak stage group exhibited a higher average age than those in the advanced AD group, evident in both DNAm and chronological age metrics.

Mean Relative Error (MRE) Insights: We observed stronger inconsistencies in MRE when comparing DNAm age with the clinically classified patient group than with our methylated-classified groups.

![clinical_def](https://github.com/gastonguaysiu/ML-AD-reclassification/blob/main/analysis_git/DNAm_age/data/clinical_def.png?raw=true)

![methylation_ML_Def](https://github.com/gastonguaysiu/ML-AD-reclassification/blob/main/analysis_git/DNAm_age/data/meth_def.png?raw=true)


**Implications and Validity of the ML Algorithm**

Our findings reveal a notable trend: ML-classified patients exhibited a more consistent increased chronological age and DNAm age aligned with AD risk and progression. This trend is a key indicator of the ML algorithm's validity, as age is a well-known risk factor in the development and progression of AD. The mean relative error (MRE) values in these groups showed enhanced consistency, further underscoring our ML model's effectiveness in categorizing AD patients.

Moreover, the ML model's ability to identify novel genes and CpG sites involved in the disease contributes significantly to a deeper understanding of AD's epigenetic landscape. This enhanced understanding is crucial for a more accurate assessment of risk and progression in AD patients. By pinpointing these genetic and epigenetic markers, our ML approach opens up new avenues for personalized therapeutic strategies and early diagnosis of Alzheimer's disease. These findings validate the potential of ML in AD research and highlight its importance in advancing personalized medicine and improving patient care in the context of neurodegenerative diseases.


-----------------------------------------

Please note that I did not develop this script in this folder but rather used Steve Horvath's script that accompanied his "DNA methylation age of human tissues and cell types" paper.

Horvath, S. (2013). DNA methylation age of human tissues and cell types. Genome Biology, 14(10), R115. https://doi.org/10.1186/gb-2013-14-10-r115
