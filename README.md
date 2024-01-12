# Sort DICOM files from one folder to another

An example script to sort DICOM files. Command line arguments are <input> folder and <output> folder.

### Problem

Image data in a hospital is stored in the DICOM file format. This file format uses a build-in header (instead of filenames, directory names or attached JSON files). We need to read the header and find out which of the DICOM files to process, what patient they belong to and what the scan parameter where used.

DICOM data comes in a sort of random directory structure. Changing to a different directory structure will not change the meaning of DICOM data as all information is in the header of each DICOM file.

### Solution

The included python program uses pydicom to read in a DICOM directory structure and build an output folder structure where different DICOM images are sorted into folders for image series.

