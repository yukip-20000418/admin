#!/bin/bash
set -v

# set project
gcloud config set project dev-chottodake-admin


# api & service list
gcloud services list --format='csv(TITLE,NAME)' \
| awk 'NR>=2 {print}' \
| sort \
| awk -F, '{printf("# %s\n%s %s %s\n",$1,"gcloud services disable",$2,"--force")}' \
> /tmp/disable-services-admin.sh


# api & service disable
bash -v /tmp/disable-services-admin.sh


# api & service enable
gcloud services enable serviceusage.googleapis.com


# create bucket
gcloud storage rm -r gs://admin.chottodake.dev

gcloud storage buckets create gs://admin.chottodake.dev \
--default-storage-class="STANDARD" \
--location="ASIA-NORTHEAST2" \
--uniform-bucket-level-access
