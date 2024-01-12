#!/usr/bin/env python

import os
import pydicom
import argparse
import shutil

input="/Users/haukebartsch/src/Research-Information-System/components/Workflow-Image-AI/data/hackathon-dataset"
output="/tmp/"

parser = argparse.ArgumentParser(
                    prog='test_sort_python',
                    description='Sort dicom folders into nicer folders')
parser.add_argument('input')
parser.add_argument('output')
args = parser.parse_args()

if args.input != None:
    input=args.input
if args.output != None:
    output=args.output

for root, dirs, files in os.walk(input, topdown=False):
    for name in files:
        # print name of file
        # print(os.path.join(root, name))
        # load with pydicom
        try:
            print(os.path.join(root, name))
            file_path=os.path.join(root, name)
            dataset = pydicom.dcmread(os.path.join(root, name))
            # get some header information from the dataset
            # StudyInstanceUID
            StudyInstanceUID=dataset.StudyInstanceUID
            SeriesInstanceUID=dataset.SeriesInstanceUID
            SOPInstanceUID=dataset.SOPInstanceUID

            SeriesNumber=""
            try:
                SeriesNumber="%03d" % dataset.SeriesNumber
            except TypeError:
                SeriesNumber="unknown"

            SeriesDescription=""
            try:
                SeriesDescription=dataset.SeriesDescription
            except AttributeError:
                SeriesDescription="unknown"
            SeriesDescription = SeriesDescription.lower().replace(" ", "_")

            StudyDate=dataset.StudyDate
            StudyTime=""
            try:
                StudyTime=dataset.StudyTime
            except AttributeError:
                StudyTime="unknown"
            if StudyTime == "":
                StudyTime="empty"

            PatientID=""
            try:
                PatientID=dataset.PatientID
            except AttributeError:
                PatientID="unknown"

            PatientName=""
            try:
                PatientName=str(dataset.PatientName)
            except AttributeError:
                PatientName="unknown"
            PatientName=PatientName.replace("^", "_").replace(" ","_").lower()

            # add dataset.Modality
            SequenceName=""
            try:
                SequenceName=dataset.SequenceName
            except AttributeError:
                SequenceName=""

            output_dir="%s/%s_%s_%s" % (output, SeriesNumber, SequenceName, SeriesDescription)
            output_path="%s/%s.dcm" % (output_dir,SOPInstanceUID)
            #print("found a dicom file: %s/%s.dcm\n" % (output_path,SOPInstanceUID))
            # create output directory
            if not os.path.exists(output_dir):
                os.makedirs(output_dir)
            # copy file
            shutil.copy(file_path, output_path)
            

        except pydicom.errors.InvalidDicomError:
            pass