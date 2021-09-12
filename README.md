# KAAR-Learning from multiple annotators using Kernel Alignment

We introduce a new kernel alignment-based annotator relevance analysis--(KAAR) approach to estimate the expertise of the labelers in scenarios where the gold standard is not available. KAAR computes the relevance of each annotator as an averaged matching between the input features and the expert labels. In turn, a new sample label is predicted as a convex combination of classifiers adopting the achieved KAAR-based coding. Unlike previous works, our approach estimates the performance of the annotators using a non-parametric model, allowing it to be more flexible concerning the distribution of the labels. Moreover, our methodology relaxes the assumption of independence between the annotators, which highlights possible correlations between the opinions of the labelers to code their expertise. 

Moreover, we provide the implementation for some state-of-the-art classification models in the context of multiple annotators, which are described below  

## Gaussian Process-based classification with majority voting--(GPC-MV):  
a typical classification scheme based on Gaussian Processes is carried out, and the gold standard is estimated as the majority voting from the annotations

## Multiple annotators using learning from crowds--(MA-LFC):
it uses a classification model based on logistic regression where the performance of each annotator is measured in terms of sensitivity and specificity. An Expectation-Maximization algorithm is used to infer both the classifier parameters and the annotator performance. This implementation is based on the article

Raykar, V. C., Yu, S., Zhao, L. H., Valadez, G. H., Florin, C., Bogoni, L., & Moy, L. (2010). Learning from crowds. Journal of Machine Learning Research, 11(Apr), 1297-1322.

## Multiple annotators: Modeling annotator expertise--(MA-MAE):
this approach enhances the MA-LFC technique by relaxing the assumption that the expertise of the annotators is constant across the input space. This approach a logistic regression-based classifier and it models the performance of each annotator by using a logistic regression model. An Expectation-Maximization algorithm to infer both the classifier parameters and the annotator expertise. This model is based on the document

Yan, Yan, et al. "Learning from multiple annotators with varying expertise." Machine learning 95.3 (2014): 291-327.

##  Multiple annotators: Distinguish good from random labelers--(MA-DGRL):
it treats as latent variables the reliability of each annotator, where the performance of the labelers is measured in terms of accuracy. An Expectation-Maximization-based optimization is employed to estimate the annotator expertise and the parameters related to the classification scheme based on logistic regression. This model is described on the article 

Rodrigues, Filipe, Francisco Pereira, and Bernardete Ribeiro. "Learning from multiple annotators: distinguishing good from random labelers." Pattern Recognition Letters 34.12 (2013): 1428-1436.

## Gaussian Process-based classification with Positive LAbel frequency Threshold--(GPC-PLAT)
it uses using a typical binary classification scheme based on Gaussian Processes, where the unknown gold standard is estimated by using the Positive LAbel frequency Threshold--(PLAT) algorithm, which is described in the document 

Zhang, Jing, Xindong Wu, and Victor S. Sheng. "Imbalanced multiple noisy labeling." IEEE Transactions on Knowledge and Data Engineering 27.2 (2015): 489-503.


### Note: For KAAR, GPC-MV and GPC-PLAT it is necessary to use GPmat (https://github.com/SheffieldML/GPmat). Moreover, for MA-DGRL, MA-MAE, MA-LFC it is necessary to use netlab (https://github.com/sods/netlab) 


Please, if you use this code, cite this [paper](https://www.sciencedirect.com/science/article/abs/pii/S0167865518307888)
