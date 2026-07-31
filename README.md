# Sort DICOM files from one folder to another

An example script to sort DICOM files. Command line arguments are <input> folder and <output> folder.

> [!NOTE]
> The python and the bash version published here are not the fastest ways to sort large numbers of files. Have a look at https://github.com/HaukeBartsch/sdcm for a faster (compiled and multi-threaded) DICOM file sorter.

### Problem

Image data in a hospital is stored in the DICOM file format. This file format uses a build-in header (instead of filenames, directory names or attached JSON files). We need to read the header and find out which of the DICOM files to process, what patient they belong to and what the scan parameter where used.

DICOM data comes in a sort of random directory structure. Changing to a different directory structure will not change the meaning of DICOM data as all information is in the header of each DICOM file.

### Solution

The included python program uses pydicom to read in a DICOM directory structure and build an output folder structure where different DICOM images are sorted into folders for image series.

### Setup

Make sure your python (version 3) environment includes the pydicom package (+argparse,+shutil).


```{bash}
conda activate base
./sort_dicom_folder.py ../Research-Information-System/components/Workflow-Image-AI/data/hackathon-dataset /tmp/output
tree -L 3 /tmp/output/
/tmp/output/
└── siim_jean_radiotherapy-001
    ├── 20190825_155039.251000
    │   ├── 002__ct_5.0_h30s
    │   ├── 605__pet_wb-uncorrected
    │   └── 606__pet_wb
    ├── 20190825_161756.695000
    │   ├── 002__abdomenct_5.0_b40s
    │   ├── 605__pet_wb-uncorrected
    │   └── 606__pet_wb
    ├── 20190825_empty
    │   ├── 002__rtstruct_from_rtog_conversion
    │   ├── 003__rt_plan_(excerpt)_-_fx1hetero
    │   └── 004__rt_dose_-_fx1hetero
    ├── 20190825_unknown
    │   └── 001__cts_from_rtog_conversion
    ├── 20191212_173124.091000
    │   ├── 002__ct_5.0_h30s
    │   ├── 605__pet_wb-uncorrected
    │   └── 606__pet_wb
    └── 20191212_175550.419000
        ├── 002__abdomenct_5.0_b40s
        ├── 605__pet_wb-uncorrected
        └── 606__pet_wb
 ```


