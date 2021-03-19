# METU Trademark Dataset Evaluation Help File

All experiments on METU dataset are implemented via following this process:

1. Feature extraction -> 2. Similarity Calculation -> 3. Evaluation based on ranking.

## Feature Extraction

We have not provided feature extraction codes, however, here, we briefly describe our feature extraction process.

Features are extracted in an order given in `list.txt` file. In experiments, we have used HDF5 format for saving deep features (hand-crafted features are saved in a different way, but the idea will be similar), and we created 1000 sub-datasets in a HDF5 dataset that will be helpful for memory problems. The First sub-dataset includes query features. 

## Similarity Calculation

We have provided the similarity calculation code that is self-explanatory. We calculated the similarity using L2 distance after normalisation. You can use consine distance as if features are l2 normalised.

## Evaluation

We have provided the evaluation code that is self-explanatory as well. Some features might create tie problems when ranking. We solved this issue by placing the query at the end of the tie queue.

For both Similarity Calculation and Evaluation, you need to import `datainfo` file, which includes file lists and ground-truth information. For generating `datainfo`, run `getDataInfo.m`.

## Further Help

If you need further help, feel-free to send us an email.

 Sinan Kalkan - Email: skalkan@ceng.metu.edu.tr
 Osman Tursun - Email: osmanjan.t@gmail.com