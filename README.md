# KAAR-Learning from multiple annotators using Kernel Alignment

We introduce a new kernel alignment-based annotator relevance analysis--(KAAR) approach to estimate the expertise of the labelers in scenarios where the gold standard is not available. KAAR computes the relevance of each annotator as an averaged matching between the input features and the expert labels. In turn, a new sample label is predicted as a convex combination of classifiers adopting the achieved KAAR-based coding. Unlike previous works, our approach estimates the performance of the annotators using a non-parametric model, allowing it to be more flexible concerning the distribution of the labels. Moreover, our methodology relaxes the assumption of independence between the annotators, which highlights possible correlations between the opinions of the labelers to code their expertise. 

Moreover, we provide the implementation for some state-of-the-art classification models in the context of multiple annotators, which are described below  

## Gaussian Process-based classification with majority voting--(GPC-MV):  
a typical classification scheme based on Gaussian Processes is carried out, and the gold standard is estimated as the majority voting from the annotations

## Multiple annotators using learning from crowds--(MA-LFC):
uses a classification model based on logistic regression where the performance of each annotator is measured in terms of sensitivity and specificity. An Expectation-Maximization algorithm is used to infer both the classifier parameters and the annotator performance. This implementation is based on the article

Raykar, V. C., Yu, S., Zhao, L. H., Valadez, G. H., Florin, C., Bogoni, L., & Moy, L. (2010). Learning from crowds. Journal of Machine Learning Research, 11(Apr), 1297-1322.

