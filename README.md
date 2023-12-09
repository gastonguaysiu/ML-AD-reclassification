# ML-AD-reclassification
ML-alzheimer's disease reclassification using k-means and EM

Estimation Maximization (EM) is a general-purpose iterative algorithm used in machine learning to maximize a posteriori (MAP) estimates of parameters in statistical models; in our case, the parameter is the probes used in the k-means clustering. Given that we know the outcome of the patients, the EM part of the algorithm would be considered supervised, and the K-means would be regarded as unsupervised. EM is beneficial in situations where some of the variables or parameters are unobserved or hidden. The idea behind EM is to alternate between estimating the missing or hidden variables and updating the model parameters based on these estimates. This process continues until the estimates of the model parameters converge to a maximum or a local maximum.

**The differential methylation EM K-means workflow comprises the following steps.**

Phases 1-3 of the EM k-means algorithm use the **pip5.R** script.
Phase 4 requires the user to manually create a new em_see.csv file based on the previous iterations (Conv. A - Conv. E), then run the script **pip_opt5.R**

Phase 1, termed Initialization (e0), starts with using all available probes as a baseline, creating an initial (probe ✕ sample) matrix with rows for each DNA CpG probe, excluding any NA values. This matrix is clustered via k-means clustering. Each cluster is scored based on accuracy to the diagnosed  Brakk stage, thereby predicting methylation signature associated with AD severity.

Phase 2, the Estimation Maximization Inner Loop, refines the best list of probes to improve sample clustering based on the Braak Stage categorization. The process includes the following steps:

1. The probes from the current best list are copied to create a trial clone.
2. Generate a new estimation by randomly adding and removing a unique set of probes in the trial clone.
3. Perform unsupervised k-means clustering on the samples with the new estimation, creating three groups (k=3).
4. Use the diagnosed Brakk stage to score and compare the new estimations to previous ones. Update the best-estimated probe list if at least one of the following criteria is met.
    - The clustering is more accurate.
    - A new estimation with fewer probes but identical scoring, maximizing the weight of new probes or eliminating probes in the k-means clustering step.
6. Iterate until a predetermined number of new estimation trials fail to improve the best estimation, indicating that the optimal list of probes for k-means clustering has been reached.

Phase 3 follows a process similar to the Estimation Maximization Inner Loop in Phase 2, but with slight modifications to the scoring criteria. After optimizing the scoring in Phase 2, the focus in Phase 3 shifts to enhancing the model's robustness. To achieve this, the scoring criteria now prioritize adding probes when the scoring is equal to the best estimation.

Phase 4, the Estimation Maximization Optimization, saves the probe list that yields the best results in Phase 3 and removes them from the potential probe pool. The algorithm returns to Phases 1-3, using fewer probes, and iterates five times (Conv. A - Conv. E). Finally, the list of probes from the previous five instances is initialized at the start of Phase 2. In contrast, the rest of the probes remain available to be added and exchanged during the EM cycles, resulting in an optimized list of probes. The end of Phase 3 with the new probes is where our optimized list of CpG probes is finalized.

![flowchar](https://github.com/gastonguaysiu/ML-AD-reclassification/blob/main/flowchart_EMAD.png?raw=true)



**The formulation of the scoring in the EM algorithm --> fitness**

The patient samples were categorized into three groups according to their Braak stage. Group A contained samples with no Alzheimer's disease symptoms or only early-stage signs, specifically Braak stages I and II, comprising 23 patient samples. Group B included patients at Braak stages III and IV, totalling 16 samples. Group C encompassed patient samples at Braak stages V and VI, amounting to 56 samples.
The scoring metric was established based on the clustering accuracy for each group, with larger groups allowing for greater leniency in sample miscategorization. We employed the following formula to compute a score based on the scoring of each group (eq. 1):

A = ∑  R - ( T - R ) / G

In this equation, 'A' represents the sum of scores for all groups. 'T' denotes the total number of patients in each group, 'R' signifies the number of correctly categorized samples, and 'G' corresponds to the initial number of samples assigned to each group.
