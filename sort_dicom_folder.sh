#/usr/bin/env bash

#
# Worst case solution for copying files by running dcmdump for every file.
# Do not use this solution, have a look at github.com/HaukeBartsch/sdcm.
#

input="${1}"
output="${2}"

if [ "$#" != 2 ]; then
    echo "Usage: <input folder> <output folder>"
    exit -1
fi

if [ ! -d "${input}" ]; then
    echo "Error: cannot see input folder \"${input}\""
    exit -1 
fi
if [ ! -d "${output}" ]; then
    echo "create output folder..."
    mkdir -p "${output}"
fi

function sanitizeSTR() {
    if [[ "${STR}" == *"no value available"* ]]; then
	STR=""
    fi
}


find "${input}" -type f -print0 | while read -d $'\0' file
do
    PatientID=`dcmdump +P PatientID "${file}" | cut -d'[' -f2 | cut -d']' -f1 | head -1`
    STR="${PatientID}" sanitizeSTR && PatientID="${STR}"
    PatientName=`dcmdump +P PatientName "${file}" | cut -d'[' -f2 | cut -d']' -f1 | head -1`
    STR="${PatientName}" sanitizeSTR && PatientName="${STR}"
    StudyInstanceUID=`dcmdump +P StudyInstanceUID "${file}" | cut -d'[' -f2 | cut -d']' -f1 | head -1`
    SeriesInstanceUID=`dcmdump +P SeriesInstanceUID "${file}" | cut -d'[' -f2 | cut -d']' -f1 | head -1`
    SOPInstanceUID=`dcmdump +P SOPInstanceUID "${file}" | cut -d'[' -f2 | cut -d']' -f1 | head -1`
    SeriesNumber=`dcmdump +P SeriesNumber "${file}" | cut -d'[' -f2 | cut -d']' -f1 | head -1`
    STR="${SeriesNumber}" sanitizeSTR && SeriesNumber="${STR}"
    Modality=`dcmdump +P Modality "${file}" | cut -d'[' -f2 | cut -d']' -f1 | head -1`
    STR="${SeriesNumber}" sanitizeSTR && SeriesNumber="${STR}"
    SeriesDescription=`dcmdump +P SeriesDescription "${file}" | cut -d'[' -f2 | cut -d']' -f1 | head -1`
    STR="${SeriesDescription}" sanitizeSTR && SeriesDescription="${STR}"
    StudyDescription=`dcmdump +P StudyDescription "${file}" | cut -d'[' -f2 | cut -d']' -f1 | head -1`
    STR="${StudyDescription}" sanitizeSTR && StudyDescription="${STR}"
    if [ ! -z "${SOPInstanceUID}" ]; then
	# create the output path
	path="${output}/${PatientID}_${PatientName}/${StudyInstanceUID}/${SeriesInstanceUID}/${Modality}_${SOPInstanceUID}.dcm"
	mkdir -p `dirname ${path}`
	#echo "create: $file with $StudyInstanceUID ${SeriesNumber} ${PatientID} ${PatientName}"
	ln -s "${file}" "${path}"
    fi
done
