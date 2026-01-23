import functions_framework
from cloudevents.http import CloudEvent

@functions_framework.cloud_event
def log_file_metadata(cloud_event: CloudEvent):
    """Triggered by a change in a storage bucket."""
    data = cloud_event.data
    
    # Extract filename and size
    file_name = data.get("name")
    file_size = data.get("size")  # Size is in bytes
    bucket_name = data.get("bucket")

    print(f"File uploaded: {file_name}")
    print(f"Bucket: {bucket_name}")
    print(f"Size: {file_size} bytes")
