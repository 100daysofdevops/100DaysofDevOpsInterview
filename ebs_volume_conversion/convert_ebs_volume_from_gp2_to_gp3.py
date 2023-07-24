import boto3
from botocore.exceptions import BotoCoreError, ClientError
import json

ec2 = boto3.resource("ec2")

def convert_volume(volume_id):
    try:
        volume = ec2.Volume(volume_id)
        if volume.volume_type == 'gp2':
            snapshot_choice = input(f"Do you want to take the snapshot of {volume_id} before converting it to gp3? (yes/no): ")
            if snapshot_choice.lower() == 'yes':
                snapshot = ec2.create_snapshot(VolumeId=volume_id, Description=f"Snapshot of volume {volume_id} before converting to gp3")
                print(f"Sucessfully created snapshot {snapshot.id} of volume {volume_id}")
            print("Now converting volume to gp3...")
            ec2.meta.client.modify_volume(VolumeId=volume_id, VolumeType='gp3')
            print(f'Sucessfully converted {volume_id} to gp3')
        else:
            print(f'Volume {volume_id} is not of type gp2. Skipped.')
    except BotoCoreError as e:
        print(f'Error from BotoCore on volume conversion: {e}')
    except ClientError as e:
        print(f'Error from AWS on volume conversion: {e}')
    except Exception as e:
        print(f'Unexpected error on volume conversion: {e}')

try:
    with open('migrate_volume.json','r') as f:
        data = json.load(f)
        for item in data:
            convert_volume(item['volume_id'])
except FileNotFoundError:
    print("The file migrate_volume.json was not found")
except json.JSONDecodeError:
    print("There was an error decoding json from file migrate_volume.json")    
except Exception as e:
    print(f'Unexpected error: {e}')            
