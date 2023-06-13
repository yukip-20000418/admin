# set project
gcloud config set project dev-chottodake-admin

# api & service
gcloud services list --format='csv(TITLE,NAME)' \
| awk 'NR>=2 {print}' \
| sort \
| awk -F, '{printf("# %s\n%s %s %s\n",$1,"gcloud services disable",$2,"--force")}' \
> disable-services.sh
chmod +x disable-services.sh
./disable-services.sh

# Service Usage API
gcloud services enable serviceusage.googleapis.com

# create bucket
# gcloud storage buckets create gs://admin.chottodake.dev \
# --default-storage-class="STANDARD" \
# --location="ASIA-NORTHEAST2" \
# --uniform-bucket-level-access
