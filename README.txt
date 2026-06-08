# Image Mosaic Generator (MATLAB)

This project presents a MATLAB implementation of a block-based image mosaic generation algorithm, completed with an intuitive Graphical User Interface (GUI) developed using MATLAB App Designer.
The application reconstructs a larger target image by using a dataset of smaller images (called tiles) based on various visual feature descriptors.

## Team Members & Contributions
Badr Kassou: Responsible for the preprocessing phase, including spatial normalization, adaptive cropping, and data loading functionalities.
Diljit Chokar: Implemented and evaluated the core tile matching algorithms, feature engineering models, and similarity metrics.
Dorine Lenoir: Designed and developed the Graphical User Interface (GUI) using MATLAB App Designer, integrated overall system components, and adjusted execution parameters for optimal performance.

## Project Structure

Due to archive size limitations for submission, large dataset folders (such as CIFAR-10 raw batches) have been excluded from the ZIP archive. The structure of your project directory is organized as follows:


├── IMPROJECT_MOSAIC/
│   ├── docs/                   # Documentation
│   ├── functions/              # Contains processing and descriptor functions (.m)
│   ├── download_cifar.m        # Automated CIFAR-10 downloader script
│   ├── download_flowers.m      # Automated Oxford Flowers downloader script
│   ├── main.m                  # Main execution script
│   ├── mosaic_app.mlapp        # GUI Application (App Designer)
│   ├── README.txt              # This file
│   └── target.png              # Default target background image for testing


## Download the Datasets

Before you can generate any mosaics, you must download a tile dataset.
We provide two automated options directly inside the project directory so you do not have to download them manually.

Launch MATLAB and make sure your current folder is set to the project root directory.

Depending on which dataset you want to test, type one (or both) of these exact commands in the MATLAB Command Window :
To use the CIFAR-10 Dataset (~175 MB): download_cifar (This automatically creates the cifar-10-batches-mat folder with all required image batches)
To use the Oxford Flowers Dataset (~60 MB) : download_flowers (This automatically creates the datasets/flowers folder and populates it with flower tile images).

## Launch the App
Once your dataset download is complete, start the application by running the following command in the MATLAB Command Window:
mosaic_app